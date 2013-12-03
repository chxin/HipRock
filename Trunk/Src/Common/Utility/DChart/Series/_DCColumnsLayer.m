//
//  DCColumnsLayer.m
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "_DCColumnsLayer.h"
#import "DCUtility.h"
#import "REMColor.h"
#import "DCDataPoint.h"
#import "DCXYSeries.h"
#import "DCColumnSeries.h"

@interface _DCColumnsLayer()
@property (nonatomic, strong) _DCLayerTrashbox* trashbox;
@end

@implementation _DCColumnsLayer

-(id)initWithCoordinateSystem:(_DCCoordinateSystem*)coordinateSystem {
    self = [super initWithCoordinateSystem:coordinateSystem];
    if (self) {
        self.trashbox = [[_DCLayerTrashbox alloc]init];
    }
    return self;
}

-(void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    [self redraw];
}

-(void)redraw {
    
    
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    BOOL allSeriesAreHidden = YES;
    for (DCXYSeries* s in self.series) {
        if (!s.hidden) {
            allSeriesAreHidden = NO;
            break;
        }
    }
    if (allSeriesAreHidden) {
        for (DCDataPoint* key in self.trashbox.xToLayerDic.allKeys) {
            [self.trashbox moveLayerToTrashBox:self.trashbox.xToLayerDic[key]];
        }
        [self.trashbox.xToLayerDic removeAllObjects];
    } else {
        self.columnWidthInCoordinateSys = (1 - 2 * kDCColumnOffset) / ((self.graphContext.stacked) ? 1 : self.series.count);
        
        int start = floor(self.graphContext.hRange.location);
        int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
        start = MAX(0, start);
        
        NSMutableDictionary* xDics = [[NSMutableDictionary alloc]init];
        int seriesAmount = self.series.count;
        for (int j = start; j<=end; j++) {
            double stackedHeight = 0;
            for (int i = 0; i < seriesAmount; i++) {
                DCColumnSeries* s = self.series[self.graphContext.stacked ? (seriesAmount-i-1) : i];
                if (s.hidden) continue;
                if (j >= s.datas.count) continue;
                DCDataPoint* key = s.datas[j];
                
                CALayer* column = self.trashbox.xToLayerDic[key];
                CGRect toFrame = [self getRectForSeries:s index:j stackedHeight:stackedHeight];
                BOOL isRectVisable = [DCUtility isFrame:toFrame visableIn:self.bounds];
                if (self.graphContext.stacked) stackedHeight += toFrame.size.height;
                if (column == nil && isRectVisable) {
                    column = [[CALayer alloc]init];
                    column.frame = CGRectMake(toFrame.origin.x, self.frame.size.height, toFrame.size.width, toFrame.size.height);
                    [self addSublayer:column];
                    if (self.focusX == INT32_MIN || j == self.focusX) {
                        column.backgroundColor = s.color.CGColor;
                    } else {
                        column.backgroundColor = [REMColor makeTransparent:kDCFocusPointAlpha withColor:s.color].CGColor;
                    }
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
                    if (self.focusX == INT32_MIN || j == self.focusX) {
                        column.backgroundColor = s.color.CGColor;
                    } else {
                        column.backgroundColor = [REMColor makeTransparent:kDCFocusPointAlpha withColor:s.color].CGColor;
                    }
                } else {
                    [self.trashbox moveLayerToTrashBox:column];
                    [column removeFromSuperlayer];
                }
            }
        }
        
        for (DCDataPoint* key in self.trashbox.xToLayerDic.allKeys) {
            if (xDics[key] == nil) {
                [self.trashbox.xToLayerDic[key] removeFromSuperlayer];
                [self.trashbox moveLayerToTrashBox:self.trashbox.xToLayerDic[key]];
            }
        }
        self.trashbox.xToLayerDic = xDics;
    }
    [CATransaction setDisableActions:caTransationState];
    self.enableGrowAnimation = NO;
    [self.trashbox.trashLayerBox removeAllObjects];
}


-(CGRect) getRectForSeries:(DCColumnSeries*)series index:(NSUInteger)index stackedHeight:(double)stackedHeight {
    DCDataPoint* point = series.datas[index];
    CGFloat columnHeight = [self getHeightOfPoint:point];
    return CGRectMake(self.frame.size.width * (index + series.pointXOffset + series.xRectStartAt - self.graphContext.hRange.location) / self.graphContext.hRange.length, self.frame.size.height-columnHeight-stackedHeight, self.frame.size.width * series.columnWidthInCoordinate / self.graphContext.hRange.length, columnHeight);
}

-(CGFloat)getHeightOfPoint:(DCDataPoint*)point {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return self.heightUnitInScreen * y;
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCColumnSeries class]];
}

-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if ([DCRange isRange:self.yRange equalTo:newRange]) return;
    [super didYRangeChanged:oldRange newRange:newRange];
    [self redraw];
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    if ([DCRange isRange:self.xRange equalTo:newRange]) return;
    [super didHRangeChanged:oldRange newRange:newRange];
    [self redraw];
}

-(void)focusOnX:(int)x {
    if (self.focusX != x) {
        [super focusOnX:x];
        [self redraw];
    }
}

-(void)defocus {
    if (self.focusX != INT32_MIN) {
        [super defocus];
        [self redraw];
    }
}
@end
