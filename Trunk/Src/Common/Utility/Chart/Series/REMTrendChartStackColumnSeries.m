/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendChartStackColumnSeries.m
 * Created      : Zilong-Oscar.Xu on 10/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartHeader.h"
@interface REMTrendChartStackColumnSeries ()
//@property (nonatomic) NSMutableArray* convertedValues;  // Stack的基准值
@end

//const NSString* xKey = @"x";
//const NSString* yKey = @"y";
//const NSString* baseKey = @"b";

@implementation REMTrendChartStackColumnSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    occupy = NO;
//    self.convertedValues = [[NSMutableArray alloc]initWithCapacity:self.energyData.count];
    return self;
}
//-(NSDictionary*)getPointDicAtX:(NSNumber*)xLocation {
//    NSNumber* pointX = xLocation;
//    
//    NSDictionary* pointDic = nil;
//    for (NSDictionary* pointInArray in self.convertedValues) {
//        NSNumber* arrayX = (NSNumber*)pointInArray[@"x"];
//        if ([arrayX isEqualToNumber:pointX]) {
//            pointDic = pointInArray;
//            break;
//        }
//    }
//    return pointDic;
//}

-(void)cacheDataOfRange {
    NSUInteger index = self.visableRange.location;
    
    NSUInteger endLocation = self.visableRange.location + self.visableRange.length + 2;
    
    for (REMEnergyData* data in self.energyData) {
        int xVal = [self.dataProcessor processX:data.localTime].intValue;
        if (xVal < self.visableRange.location) continue;
        if (xVal > endLocation) break;
        
        while (index != xVal) {
            NSNumber* base = [self getBaseValueAtIndex:index];
            [source addObject:@{@"x":@(index), @"y":[NSNull null], @"base":base, @"enenrgydata":[NSNull null]}];
            index++;
        }
        
        NSNumber* base = [self getBaseValueAtIndex:index];
        [source addObject:@{@"x":@(xVal), @"y":@([self.dataProcessor processY:data.dataValue].doubleValue+base.doubleValue), @"base":base, @"enenrgydata":data}];
        index++;
        
    }
    while (index < endLocation) {
        [source addObject:@{@"x":@(index), @"y":[NSNull null], @"enenrgydata":[NSNull null]}];
        index++;
    }
    [[self getPlot]reloadData];
}

-(NSNumber*)getBaseValueAtIndex:(NSUInteger)index {
    REMTrendChartStackColumnSeries* thePreviousSeries = self.previousStackSeries;
    if (self.previousStackSeries) {
        NSDictionary* prePoint = [thePreviousSeries getCurrentRangeSource][index];
        NSNumber* base = prePoint[@"y"];
        if ([base isEqual:[NSNull null]]) {
            base = prePoint[@"base"];
        }
        return base;
    } else {
        return @(0);
    }
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    ((CPTBarPlot*)plot).barBasesVary = YES;
    for (int i=selfIndex-1; i >= 0; i--) {
        REMChartSeries* thePreviousSeries = seriesList[i];
        if ([thePreviousSeries isMemberOfClass:[REMTrendChartStackColumnSeries class]]) {
            self.previousStackSeries = (REMTrendChartStackColumnSeries*)thePreviousSeries;
            break;
        }
    }
//    for (int i = 0; i < self.energyData.count; i++) {
//        REMEnergyData* point = self.energyData[i];
//        NSNumber* pointX = [self.dataProcessor processX:point.localTime];
//        
//        REMTrendChartStackColumnSeries* previousSeries = self.previousStackSeries;
//        NSDecimalNumber* baseVal = [NSDecimalNumber decimalNumberWithString:@"0"];
//        if (previousSeries) {
//            NSDictionary* previousPointDic = [previousSeries getPointDicAtX:pointX];
//            if (previousPointDic) {
//                NSNumber* previousY = previousPointDic[@"y"];
//                baseVal = [NSDecimalNumber decimalNumberWithDecimal: previousY.decimalValue];
//            }
//        }
//        NSNumber* pointValue =[self.dataProcessor processY:point.dataValue];
//        NSNumber* pointY = [baseVal decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:pointValue.decimalValue]];
//        
//        [self.convertedValues setObject:@{ @"x": pointX, @"y":pointY, @"base":baseVal } atIndexedSubscript:i];
//    }
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
}

-(NSNumber*)maxYInCache {
//    NSNumber* minXObj = @(minX);
//    NSNumber* maxXObj = @(maxX);
//    NSNumber* maxY = [NSNumber numberWithInt:0];
//    for (NSDictionary* dic in self.convertedValues) {
//        NSNumber* x = dic[@"x"];
//        if ([x isGreaterThan:maxXObj] || [x isLessThan:minXObj]) continue;
//        NSNumber* yVal = dic[@"y"];
//        if (yVal == nil || yVal == NULL || [yVal isEqual:[NSNull null]] || [yVal isLessThan:([NSNumber numberWithInt:0])]) continue;
//        if (maxY.floatValue < yVal.floatValue) {
//            maxY = yVal;
//        }
//    }
    return @(0);
}

@end
