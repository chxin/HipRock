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
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate {
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle yAxisIndex:yAxisIndex dataStep:step startDate:startDate];
    occupy = NO;
    self.convertedValues = [[NSMutableArray alloc]init];
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
    REMEnergyData* point = [self.energyData objectAtIndex:idx];
    NSNumber* pointX = [self.dataProcessor processX:point.localTime startDate:self.startDate step:self.step];
    
    NSDictionary* pointDic = [self getPointDicAtX:pointX];
    if (pointDic == nil) {
        REMTrendChartStackColumnSeries* previousSeries = self.previousStackSeries;
        NSDecimalNumber* baseVal = [NSDecimalNumber decimalNumberWithString:@"0"];
        
        while (previousSeries) {
            NSDictionary* previousPointDic = [previousSeries getPointDicAtX:pointX];
            if (previousPointDic) {
                baseVal = [baseVal decimalNumberByAdding:previousPointDic[@"base"]];
            }
            previousSeries = previousSeries.previousStackSeries;
        }
        
        pointDic = @{
                     @"x": pointX,
                     @"y":[self.dataProcessor processY:point.dataValue startDate:self.startDate step:self.step],
                     @"base":baseVal
                     };
        [self.convertedValues addObject:pointDic];
    }
    
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return [pointDic objectForKey:@"x"];
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        return [pointDic objectForKey:@"y"];
    } else {
        return [pointDic objectForKey:@"base"];
    }
}

-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex {
    for (int i=selfIndex-1; i >= 0; i--) {
        REMChartSeries* thePreviousSeries = seriesList[i];
        if ([thePreviousSeries isMemberOfClass:[REMTrendChartStackColumnSeries class]]) {
            self.previousStackSeries = (REMTrendChartStackColumnSeries*)thePreviousSeries;
            break;
        }
    }
    [super beforePlotAddToGraph:graph seriesList:seriesList selfIndex:selfIndex];
}

@end
