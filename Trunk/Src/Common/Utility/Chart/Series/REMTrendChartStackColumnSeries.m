//
//  REMTrendChartStackColumnSeries.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 10/23/13.
//
//

#import "REMChartHeader.h"
@interface REMTrendChartStackColumnSeries ()
//@property (nonatomic) NSMutableArray* convertedValues;  // Stack的基准值
@end

//const NSString* xKey = @"x";
//const NSString* yKey = @"y";
//const NSString* baseKey = @"b";

@implementation REMTrendChartStackColumnSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle startDate:startDate];
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
    NSDate* startDate = [self.dataProcessor deprocessX:self.visableRange.location];
    NSDate* endDate = [self.dataProcessor deprocessX:self.visableRange.length+self.visableRange.location+2];
    
    NSUInteger index = 0;
    REMEnergyData* data = nil;
    NSUInteger allDataCount = self.energyData.count;
    while (index < allDataCount) {
        data = self.energyData[index];
        index++;
        if ([data.localTime compare:startDate]==NSOrderedAscending) continue;
        if ([data.localTime compare:endDate]==NSOrderedDescending) break;
        [source addObject:@{@"x":[self.dataProcessor processX:data.localTime], @"y":[self.dataProcessor processY:data.dataValue], @"enenrgydata":data}];
    }
    [[self getPlot]reloadData];
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
