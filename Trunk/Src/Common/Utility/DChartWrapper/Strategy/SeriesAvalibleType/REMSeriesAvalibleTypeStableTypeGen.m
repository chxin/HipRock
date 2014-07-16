//
//  REMSeriesAvalibleTypeStableTypeGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesAvalibleTypeStableTypeGen.h"

@implementation REMSeriesAvalibleTypeStableTypeGen
-(int)getAvalibleTypeBySeriesKey:(NSString *)seriesKey targetTypeFromServer:(REMEnergyTargetType)targetType defaultChartType:(DCSeriesTypeStatus)defaultChartType {
    return defaultChartType;
}
@end
