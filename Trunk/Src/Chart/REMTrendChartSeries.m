//
//  REMTrendChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/13/13.
//
//

#import "REMTrendChart.h"

@interface REMTrendChartView()
    
@property (nonatomic, readonly) REMTrendChartView* view;

@end

@implementation REMTrendChartSeries 

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMTrendChartDataProcessor*)processor dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate {
    self = [super init];
    if (self) {
        self.yAxisIndex = 0;
        NSMutableArray* data = [[NSMutableArray alloc]init];
        for (REMEnergyData *p in energyData) {
            [data addObject:[processor processEnergyData:p startDate:startDate step:step]];
        }
        _points = data;
    }
    return self;
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.points.count;
}

@end
