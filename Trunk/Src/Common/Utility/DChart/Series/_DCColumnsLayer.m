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
@property (nonatomic, strong) NSMutableDictionary* columnsDic;
@end

@implementation _DCColumnsLayer
-(id)initWithContext:(DCContext *)graphContext view:(DCXYChartView *)view coordinateSystems:(NSArray *)coordinateSystems {
    self = [super initWithContext:graphContext view:view coordinateSystems:coordinateSystems];
    if (self) {
        _columnsDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)redraw {
    if (self.enableGrowAnimation) {
        self.enableGrowAnimation = NO;
        CALayer* superLayer = self.superlayer;
        CGRect superFrame = superLayer.frame;
        CGRect newBounds = superLayer.bounds;
        CGRect oldBounds = CGRectMake(newBounds.origin.x, newBounds.origin.y, newBounds.size.width, 0);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:oldBounds];
        animation.toValue = [NSValue valueWithCGRect:newBounds];
        animation.delegate = self;
        animation.duration = kDCAnimationDuration;
        superLayer.anchorPoint = CGPointMake(0, 1);
        superLayer.position = CGPointMake(superFrame.origin.x, superFrame.size.height+superFrame.origin.y);
        [superLayer addAnimation:animation forKey:@"bounds"];
    }
    if ([self getVisableSeriesCount] == 0) {
        [self clearSublayersAndDictionary];
    } else {
        int start = floor(self.graphContext.hRange.location);
        int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
        if (start < 0) start = 0;
        
        if (end < 0) {
            [self clearSublayersAndDictionary];
            return;
        }
        
        BOOL caTransationState = CATransaction.disableActions;
        [CATransaction setDisableActions:YES];
        double stackedHeights[end-start+1];
        for (int i = 0; i < end-start+1; i++) {
            stackedHeights[i] = 0;
        }
        NSMutableDictionary* xDics = [[NSMutableDictionary alloc]init];
        int seriesAmount = self.seriesList.count;
        for (int i = 0; i < seriesAmount; i++) {
            DCColumnSeries* s = self.seriesList[self.graphContext.stacked ? (seriesAmount-i-1) : i];
            if (s.hidden) continue;
            _DCCoordinateSystem* coordinateSystem = s.coordinate;
            for (int j = start; j<=end; j++) {
                if (j >= s.datas.count) continue;
                
                DCDataPoint* point = s.datas[j];
                NSString* key = [NSString stringWithFormat:@"%u@%i", point.series.hash, j];
                CALayer* column = self.columnsDic[key];
                CGRect toFrame = [self getRectForSeries:s index:j stackedHeight:stackedHeights[j-start] coordinate:coordinateSystem];
                if (self.graphContext.stacked) {
                    stackedHeights[j-start] = stackedHeights[j-start] + toFrame.size.height;
                }
                BOOL isRectVisable = [DCUtility isFrame:toFrame visableIn:self.bounds];
                
                if (column == nil && isRectVisable) {
                    column = [[CALayer alloc]init];
                    column.frame = CGRectMake(toFrame.origin.x, self.frame.size.height, toFrame.size.width, toFrame.size.height);
                    [self addSublayer:column];
                    if (self.graphContext.focusX == INT32_MIN || j == self.graphContext.focusX) {
                        column.backgroundColor = s.color.CGColor;
                    } else {
                        column.backgroundColor = [REMColor makeTransparent:kDCFocusPointAlpha withColor:s.color].CGColor;
                    }
                    [xDics setObject:column forKey:key];
                    column.frame = toFrame;
                } else if (column == nil && !isRectVisable) {
                    continue;
                } else if (column != nil && isRectVisable) {
                    column.frame = toFrame;
                    [xDics setObject:column forKey:key];
                    if (self.graphContext.focusX == INT32_MIN || j == self.graphContext.focusX) {
                        column.backgroundColor = s.color.CGColor;
                    } else {
                        column.backgroundColor = [REMColor makeTransparent:kDCFocusPointAlpha withColor:s.color].CGColor;
                    }
                } else {
                    [column removeFromSuperlayer];
                }
            }
        }
        
        for (NSString* key in self.columnsDic.allKeys) {
            if (xDics[key] == nil) {
                [self.columnsDic[key] removeFromSuperlayer];
            }
        }
        self.columnsDic = xDics;
        [CATransaction setDisableActions:caTransationState];
    }
}

-(void)clearSublayersAndDictionary {
    while (self.columnsDic.count != 0) {
        id key = self.columnsDic.allKeys[0];
        [self.columnsDic[key] removeFromSuperlayer];
        [self.columnsDic removeObjectForKey:key];
    }
}

-(CGRect) getRectForSeries:(DCColumnSeries*)series index:(NSUInteger)index stackedHeight:(double)stackedHeight coordinate:(_DCCoordinateSystem*)coordinate {
    DCDataPoint* point = series.datas[index];
    CGFloat columnHeight = [self getHeightOfPoint:point coordinate:coordinate];
    CGFloat pointXOffset = self.graphContext.pointHorizentalOffset;
//    if (!self.graphContext.pointAlignToTick) pointXOffset = 0.5;
    return CGRectMake(self.frame.size.width * (index + pointXOffset + series.xRectStartAt - self.graphContext.hRange.location) / self.graphContext.hRange.length,
                      self.frame.size.height-columnHeight-stackedHeight,
                      self.frame.size.width * series.columnWidthInCoordinate / self.graphContext.hRange.length,
                      columnHeight);
}

-(CGFloat)getHeightOfPoint:(DCDataPoint*)point coordinate:(_DCCoordinateSystem*)coordinate {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return coordinate.heightUnitInScreen * y;
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCColumnSeries class]];
}

@end
