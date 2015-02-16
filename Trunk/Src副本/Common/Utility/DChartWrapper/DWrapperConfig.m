//
//  DWrapperConfig.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/14/14.
//
//

#import "DWrapperConfig.h"

@implementation DWrapperConfig
-(id)init {
    self = [super init];
    if (self) {
        _dataStoreType = -1;
    }
    return self;
}

-(id)initWith:(REMWidgetContentSyntax*)contentSyntax {
    self = [self init];
    if (self) {
        _calendarType=contentSyntax.calendarType;
        _rankingSortOrder=contentSyntax.rankingSortOrder;
        _rankingRangeCode=contentSyntax.rankingRangeCode;
        _relativeDateType = contentSyntax.relativeDateType;
        _dataStoreType = contentSyntax.dataStoreType;
//        _storeType = contentSyntax.storeType;
        _timeRanges = [contentSyntax.timeRanges copy];
        _seriesStates = contentSyntax.seriesStates;
        
        _defaultSeriesType = DCSeriesTypeStatusNone;

        NSString* defaultType = contentSyntax.config[@"type"];
        if ([defaultType isEqualToString:@"line"]) {
            _defaultSeriesType = DCSeriesTypeStatusLine;
        } else if ([defaultType isEqualToString:@"column"]) {
            _defaultSeriesType = DCSeriesTypeStatusColumn;
        } else if ([defaultType isEqualToString:@"pie"]) {
            _defaultSeriesType = DCSeriesTypeStatusPie;
        } else if ([defaultType isEqualToString:@"stack"]) {
            _defaultSeriesType = DCSeriesTypeStatusStackedColumn;
        }
        
        self.contentSyntax = contentSyntax;
    }
    return self;
}

-(REMChartFromLevel2)getWidgetFrom {
    REMChartFromLevel2 widgetFrom = REMChartFromLevel2None;
    switch (self.dataStoreType) {
        case REMDSEnergyTagsTrend:
        case REMDSEnergyTagsDistribute:
        case REMDSEnergyMultiTimeTrend:
        case REMDSEnergyMultiTimeDistribute:
            widgetFrom = REMChartFromLevel2EnergyAnalysis;
            break;
        case REMDSEnergyCarbon:
        case REMDSEnergyCarbonDistribute:
            widgetFrom = REMChartFromLevel2Carbon;
            break;
        case REMDSEnergyCost:
        case REMDSEnergyCostDistribute:
        case REMDSEnergyCostElectricity:
            widgetFrom = REMChartFromLevel2Cost;
            break;
        case REMDSEnergyTagsTrendUnit:
        case REMDSEnergyCarbonUnit:
        case REMDSEnergyCostUnit:
            widgetFrom = REMChartFromLevel2Unit;
            break;
        case REMDSEnergyRatio:
            widgetFrom = REMChartFromLevel2Ratio;
            break;
        case REMDSEnergyLabeling:
            widgetFrom = REMChartFromLevel2Labeling;
            break;
        case REMDSEnergyRankingEnergy:
        case REMDSEnergyRankingCost:
        case REMDSEnergyRankingCarbon:
            widgetFrom = REMChartFromLevel2Ranking;
            break;
        default:
            widgetFrom = REMChartFromLevel2None;
            break;
    }
    return widgetFrom;
}

-(BOOL)getIsMultiTimeEnergyAnalysisChart {
    if (self.widgetFrom != REMChartFromLevel2EnergyAnalysis) return NO;
    return  self.dataStoreType == REMDSEnergyMultiTimeTrend || self.dataStoreType == REMDSEnergyMultiTimeDistribute;
}

-(BOOL)getIsTouChart {
    return self.dataStoreType == REMDSEnergyCostElectricity;
}
@end
