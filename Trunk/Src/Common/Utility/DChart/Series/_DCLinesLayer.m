//
//  _DCLineLayer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLinesLayer.h"
#import "DCDataPoint.h"
#import "DCUtility.h"
#import "DCLineSeries.h"
#import "REMColor.h"

@implementation _DCLinesLayer

-(NSArray*)getLines {
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    start = MAX(0, start);
    
    CGFloat symbolAlpha = kDCUnfocusPointSymbolAlph;
    if (self.focusX == INT32_MIN) {
        symbolAlpha = 1;
    }
    NSMutableArray* lines = [[NSMutableArray alloc]init];
    for (DCLineSeries* s in self.series) {
        if (s.hidden) continue;
        if (start >= s.datas.count) continue;
        int loopEnd = s.datas.count-1;
        if (end < loopEnd) loopEnd = end;
        UIColor* lineColor = [REMColor makeTransparent:symbolAlpha withColor:s.color];
        NSMutableArray* points = [[NSMutableArray alloc]init];
        
        // 从RangeStart向前再搜索一个非空点，并绘制曲线
        for (int j = start-1; j >= 0; j--) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                [points addObject:[NSValue valueWithCGPoint:[self getPointBy:j y:point.value.doubleValue]]];
                break;
            }
        }
        // 绘制图形的主要部分
        for (int j = start; j <= loopEnd; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeNormal) {
                [points addObject:[NSValue valueWithCGPoint:[self getPointBy:j y:point.value.doubleValue]]];
            } else {
                _DCLine* line = [[_DCLine alloc]init];
                line.points = points;
                line.lineColor = lineColor;
                line.lineWidth = s.lineWidth;
                [lines addObject:line];
                points = [[NSMutableArray alloc]init];
            }
        }
        // 从RangeEnd向前后搜索一个非空点，并绘制曲线
        for (int j = loopEnd+1; j < s.datas.count; j++) {
            DCDataPoint* point = s.datas[j];
            if (point.pointType == DCDataPointTypeEmpty) {
                continue;
            } else if (point.pointType == DCDataPointTypeBreak) {
                break;
            } else {
                [points addObject:[NSValue valueWithCGPoint:[self getPointBy:j y:point.value.doubleValue]]];
                break;
            }
        }
        if (points.count != 0) {
            _DCLine* line = [[_DCLine alloc]init];
            line.points = points;
            line.lineColor = lineColor;
            line.lineWidth = s.lineWidth;
            [lines addObject:line];
        }
    }
    return lines;
    
}

-(CGPoint)getPointBy:(int)x y:(double)y {
    CGFloat xOffset = 0;
    if (!self.graphContext.pointAlignToTick) xOffset = 0.5;
    CGPoint point;
    point.x = self.frame.size.width*(x+xOffset-self.graphContext.hRange.location)/self.graphContext.hRange.length;
    point.y = self.frame.size.height-self.heightUnitInScreen*y;
    return point;
}

-(BOOL)isValidSeriesForMe:(DCXYSeries*)series {
    return [series isKindOfClass:[DCLineSeries class]];
}


//-(void)didYRangeChanged:(DCRange*)oldRange newRange:(DCRange*)newRange {
//    if ([DCRange isRange:oldRange equalTo:newRange]) return;
//    [super didYRangeChanged:oldRange newRange:newRange];
//    [self setNeedsDisplay];
////    [self renderSymbols];
//}
//
//-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
//    if ([DCRange isRange:oldRange equalTo:newRange]) return;
//    [super didHRangeChanged:oldRange newRange:newRange];
//    [self setNeedsDisplay];
////    [self renderSymbols];
//}
//-(void)redraw {
//    [self setNeedsDisplay];
//}

//-(void)lazyRenderSymbol {
//    if (REMIsNilOrNull(self.symbolsLayer)) return;
//    self.symbolsLayer.hidden = NO;
//    self.symbolsAreHidden = NO;
//    [self renderSymbols];
//    [self.timer setFireDate:nil];
//    [self.timer invalidate];
//}

-(NSArray*)getSymbols {
    int start = floor(self.graphContext.hRange.location);
    int end = ceil(self.graphContext.hRange.length+self.graphContext.hRange.location);
    CGFloat pointXOffset = 0;
    if (!self.graphContext.pointAlignToTick) pointXOffset = 0.5;
    NSMutableArray* pointsToDraw = [[NSMutableArray alloc]init];
    for (DCLineSeries* s in self.series) {
        if (s.hidden) continue;
        NSMutableArray* seriesPoints = [[NSMutableArray alloc]init];
        NSUInteger i = 0;
        for (int j = start; j<=end; j++) {
            if (s.symbolType == DCLineSymbolTypeNone || s.symbolSize == 0) continue;
            if (j >= s.datas.count) continue;
            
            DCDataPoint* key = s.datas[j];
            CGRect toFrame = CGRectMake(self.frame.size.width*(j+pointXOffset-self.graphContext.hRange.location)/self.graphContext.hRange.length-s.symbolSize/2, self.frame.size.height-[self getHeightOfPoint:key]-s.symbolSize/2, s.symbolSize, s.symbolSize);
            BOOL isRectVisable = [DCUtility isFrame:toFrame visableIn:self.bounds] && (key.value != nil) && ![key.value isEqual:[NSNull null]];
            if (isRectVisable) {
                CGPoint location = CGPointMake(toFrame.origin.x+toFrame.size.width/2, toFrame.origin.y+toFrame.size.height/2);
                CGFloat symbolAlpha = 0;
                if (j == self.focusX || self.focusX == INT32_MIN)
                    symbolAlpha = kDCSymbolAlpha;
                else
                    symbolAlpha = kDCUnfocusPointSymbolAlph;
                [seriesPoints addObject:@{ @"dcpoint": s.datas[j], @"location": [NSValue valueWithCGPoint:location], @"symbolAlpha":@(symbolAlpha) }];
            }
        }
        
        [pointsToDraw addObject:seriesPoints];
        i++;
    }
    return pointsToDraw;
}

-(CGFloat)getHeightOfPoint:(DCDataPoint*)point {
    double y = 0;
    if (point.value != nil && ![point.value isEqual:[NSNull null]]) {
        y = point.value.doubleValue;
    }
    return self.heightUnitInScreen * y;
}
@end
