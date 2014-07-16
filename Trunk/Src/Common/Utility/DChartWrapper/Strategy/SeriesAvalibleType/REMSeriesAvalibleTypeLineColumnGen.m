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
    return DCSeriesTypeStatusColumn | DCSeriesTypeStatusLine;
}

@end
