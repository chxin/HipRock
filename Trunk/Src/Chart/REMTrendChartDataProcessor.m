//
//  REMTrendChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import "REMTrendChart.h"
#import "REMTimeHelper.h"

@implementation REMTrendChartDataProcessor

-(REMTrendChartPoint*)processEnergyData:(REMEnergyData*)point startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return [[REMTrendChartPoint alloc]
            initWithX:[self processX:point.localTime startDate:startDate step:step]
            y:point.dataValue
            point:point];
}

-(float)processX:(NSDate*)localTime startDate:(NSDate*)startDate step:(REMEnergyStep)step  {
    float x = 0;
    if (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek) {
        x = [localTime timeIntervalSinceDate:startDate] / (step == REMEnergyStepHour ? 3600 : (step == REMEnergyStepDay ? 86400 : 604800));
    } else if (step == REMEnergyStepYear) {
        x = [REMTimeHelper getYear:localTime] - [REMTimeHelper getYear:startDate];
    } else {
        x = ([REMTimeHelper getYear:localTime] - [REMTimeHelper getYear:startDate]) * 12 + [REMTimeHelper getMonth:localTime] - [REMTimeHelper getMonth:startDate];
    }
    return x;
}

@end
