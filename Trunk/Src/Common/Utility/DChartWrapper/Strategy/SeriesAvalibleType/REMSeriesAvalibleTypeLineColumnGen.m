//
//  REMSeriesAvalibleTypeLineColumnGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesAvalibleTypeLineColumnGen.h"

@implementation REMSeriesAvalibleTypeLineColumnGen

-(int)getAvalibleTypeBySeriesKey:(NSString *)seriesKey targetTypeFromServer:(REMEnergyTargetType)targetType defaultChartType:(DCSeriesTypeStatus)defaultChartType {
    if (targetType == REMEnergyTargetBenchmarkValue) return DCSeriesTypeStatusLine;
    return DCSeriesTypeStatusColumn | DCSeriesTypeStatusLine;
}

@end
