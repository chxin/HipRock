//
//  DCColumnsLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCColumnsLayer.h"

@interface _DCColumnsLayer()
@property (nonatomic, strong) NSMutableArray* series;
@property (nonatomic, strong) NSMutableArray* visableSeries;
@property (nonatomic, weak) _DCCoordinateSystem* coordinateSystem;

@property (nonatomic) CGFloat columnWidthInCoordinateSys;
@property (nonatomic) CGFloat columnHeightUnitInScreen;
@property (nonatomic, strong) DCRange* yRange;
@property (nonatomic, strong) DCRange* xRange;

@property (nonatomic, assign) BOOL enableGrowAnimation;
@end

@implementation _DCColumnsLayer

-(id)initWithCoordinateSystem:(_DCCoordinateSystem*)coordinateSystem {
    self = [super init];
    if (self) {
        _enableGrowAnimation = YES;
        NSMutableArray* s = [[NSMutableArray alloc]init];
        for (DCSeries* se in coordinateSystem.seriesList) {
            if ([se isKindOfClass:[DCColumnSeries class] ]) {
                [s addObject:se];
            }
        }
        _series = s;
        self.masksToBounds = YES;
        self.trashBoxSize = self.series.count;
        _visableSeries = s.mutableCopy;
        _coordinateSystem = coordinateSystem;
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    [self redraw:self.xRange y:self.yRange];
}

-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    [self redraw:self.xRange y:newRange];
    _yRange = [newRange copy];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if (oldRange == Nil) self.enableGrowAnimation = YES;
    [self redraw:newRange y:self.xRange];
    _xRange = [newRange copy];
    
}

-(CGRect) getRectForSeries:(DCColumnSeries*)series index:(NSUInteger)index stackedHeight:(double)stackedHeight {
    DCDataPoint* point = series.datas[index];
    CGFloat columnHeight = [self getHeightOfPoint:point];
    return CGRectMake(self.frame.size.width * (index + series.xRectStartAt - self.graphContext.hRange.location) / self.graphContext.hRange.length, self.frame.size.height-columnHeight-stackedHeight, self.frame.size.width * series.columnWidthInCoordinate / self.graphContext.hRange.length, columnHeight);
}

-(void)redraw:(DCRange*)xRange y:(DCRange*)yRange {
    if ([DCRange isRange:xRange equalTo:self.xRange] && [DCRange isRange:yRange equalTo:self.yRange]) return;
    [self forceRedraw];
}

-(void)forceRedraw {
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    if (self.visableSeries.count == 0) {
        for (DCDataPoint* key in self.xToLayerDic.allKeys) {
            [self moveLayerToTrashBox:self.xToLayerDic[key]];
        }
        [self.xToLayerDic removeAllObjects];
    } else {
        self.columnWidthInCoordinateSys = (1 - 2 * kDCColumnOffset) / ((self.graphContext.stacked) ? 1 : self.series.count);
        self.columnHeightUnitInScreen = (self.yRange != nil && self.yRange.length > 0) ? (self.frame.size.height / self.yRange.length) : 0;
        
        int start = floor(self.graphContext.hRange.location);
        int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
        start = MAX(0, start);
        
        NSMutableDictionary* xDics = [[NSMutableDictionary alloc]init];
//        CAAnimation* a = [CATransaction begin ];
        for (int j = start; j<=end; j++) {
            double stackedHeight = 0;
            for (DCColumnSeries* s in self.series) {
                if (j >= s.datas.count) continue;
                if (![self.visableSeries containsObject:s]) continue;
                DCDataPoint* key = s.datas[j];
                
                CALayer* column = self.xToLayerDic[key];
                CGRect toFrame = [self getRectForSeries:s index:j stackedHeight:stackedHeight];
                BOOL isRectVisable = [self isVisableInMyFrame:toFrame];
                if (self.graphContext.stacked) stackedHeight += toFrame.size.height;
                if (column == nil && isRectVisable) {
                    column = [[CALayer alloc]init];
                    column.frame = CGRectMake(toFrame.origin.x, self.frame.size.height, toFrame.size.width, toFrame.size.height);
                    [self addSublayer:column];
                    column.backgroundColor = s.color.CGColor;
                    [xDics setObject:column forKey:key];
                    if (self.enableGrowAnimation) {
                        CAAnimationGroup* g = [CAAnimationGroup animation];
                        CABasicAnimation* positionAnim = [CABasicAnimation animationWithKeyPath:@"position.y"];
                        positionAnim.removedOnCompletion = NO;
                        positionAnim.fillMode = kCAFillModeForwards;
                        positionAnim.duration = kDCAnimationDuration;
                        positionAnim.fromValue = @(self.frame.size.height);
                        positionAnim.toValue = @(toFrame.origin.y+toFrame.size.height/2);
                        g.animations = @[ positionAnim];
                        
                        [column addAnimation:g forKey:nil];
                    }
                    column.frame = toFrame;
                } else if (column == nil && !isRectVisable) {
                    continue;
                } else if (column != nil && isRectVisable) {
                    column.frame = toFrame;
                    [xDics setObject:column forKey:key];
                } else {
                    [self moveLayerToTrashBox:column];
                }
            }
        }
        
        for (DCDataPoint* key in self.xToLayerDic.allKeys) {
            if (xDics[key] == nil) {
                [self moveLayerToTrashBox:self.xToLayerDic[key]];
            }
        }
        self.xToLayerDic = xDics;
    }
    [CATransaction setDisableActions:caTransationState];
    self.enableGrowAnimation = NO;
}

-(CGFloat)getHeightOfPoint:(DCDataPoint*)point {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return self.columnHeightUnitInScreen * y;
}

-(void)removeFromSuperlayer {
    [self.series removeAllObjects];
    [self.visableSeries removeAllObjects];
    [super removeFromSuperlayer];
}

- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden {
    if ([self.series containsObject:series]) {
        if (hidden == [self.visableSeries containsObject:series]) {
            if (hidden) {
                [self.visableSeries removeObject:series];
                series.yAxis.visableSeriesAmount--;
                series.xAxis.visableSeriesAmount--;
            } else {
                [self.visableSeries addObject:series];
                series.yAxis.visableSeriesAmount++;
                series.xAxis.visableSeriesAmount++;
            }
            [self forceRedraw];
        }
    }
}
@end
