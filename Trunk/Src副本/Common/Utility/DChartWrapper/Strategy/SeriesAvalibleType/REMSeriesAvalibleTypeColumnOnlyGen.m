//
//  REMSeriesAvalibleTypeColumnOnlyGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesAvalibleTypeColumnOnlyGen.h"

@implementation REMSeriesAvalibleTypeColumnOnlyGen

-(int)getAvalibleTypeBySeriesKey:(NSString *)seriesKey targetTypeFromServer:(REMEnergyTargetType)targetType defaultChartType:(DCSeriesTypeStatus)defaultChartType {
    return DCSeriesTypeStatusColumn;
}
@end
