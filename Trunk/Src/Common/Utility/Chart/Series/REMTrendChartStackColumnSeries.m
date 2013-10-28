//
//  REMTrendChartStackColumnSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/23/13.
//
//

#import "REMChartHeader.h"
@interface REMTrendChartStackColumnSeries ()
@property (nonatomic) NSMutableArray* convertedValues;  // Stack的基准值
@end

//const NSString* xKey = @"x";
//const NSString* yKey = @"y";
//const NSString* baseKey = @"b";

@implementation REMTrendChartStackColumnSeries
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle startDate:startDate];
    occupy = NO;
    self.convertedValues = [[NSMutableArray alloc]initWithCapacity:self.energyData.count];
    return self;
}
-(NSDictionary*)getPointDicAtX:(NSNumber*)xLocation {
    NSNumber* pointX = xLocation;
    
    NSDictionary* pointDic = nil;
    for (NSDictionary* pointInArray in self.convertedValues) {
        NSNumber* arrayX = (NSNumber*)pointInArray[@"x"];
        if ([arrayX isEqualToNumber:pointX]) {
            pointDic = pointInArray;
            break;
        }
    }
    return pointDic;
}
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSDictionary* pointDic = self.convertedValues[idx];
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [pointDic objectForKey:@"x"];
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        return [pointDic objectForKey:@"y"];
    } else {
        return [pointDic objectForKey:@"base"];
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
    for (int i = 0; i < self.energyData.count; i++) {
        REMEnergyData* point = self.energyData[i];
        NSNumber* pointX = [self.dataProcessor processX:point.localTime];
        NSNumber* pointY = [self.dataProcessor processY:point.dataValue];
        REMTrendChartStackColumnSeries* previousSeries = self.previousStackSeries;
        NSDecimalNumber* baseVal = [NSDecimalNumber decimalNumberWithString:@"0"];
        
        while (previousSeries) {
            NSDictionary* previousPointDic = [previousSeries getPointDicAtX:pointX];
            if (previousPointDic) {
                baseVal = [baseVal decimalNumberByAdding:previousPointDic[@"base"]];
            }
            previousSeries = previousSeries.previousStackSeries;
        }
        
        [self.convertedValues setObject:@{ @"x": pointX, @"y":pointY, @"base":baseVal } atIndexedSubscript:i];
    }
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
}

@end
