//
//  REMSeriesAvalibleTypeDefaultGen.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMSeriesAvalibleTypeDefaultGen.h"

@implementation REMSeriesAvalibleTypeDefaultGen
-(int)getAvalibleTypeBySeriesKey:(NSString *)seriesKey targetTypeFromServer:(REMEnergyTargetType)targetType defaultChartType:(DCSeriesTypeStatus)defaultChartType {
    int allTrendType = DCSeriesTypeStatusColumn | DCSeriesTypeStatusLine | DCSeriesTypeStatusStackedColumn;
    int aType = 0;
    if (targetType == REMEnergyTargetBenchmarkValue) {
        aType = DCSeriesTypeLine;
    } else {
        switch (defaultChartType) {
            case DCSeriesTypeStatusColumn:
            case DCSeriesTypeStatusLine:
            case DCSeriesTypeStatusStackedColumn:
                aType = allTrendType;
                break;
            case DCSeriesTypeStatusPie:
                aType = DCSeriesTypeStatusPie;
            default:
                break;
        }
    }
    return aType;
}
@end
