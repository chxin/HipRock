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
        _storeType = -1;
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
    }
    return self;
}

-(REMChartFromLevel2)getWidgetFrom {
    REMChartFromLevel2 widgetFrom = REMChartFromLevel2None;
    switch (self.storeType) {
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
    return  self.storeType == REMDSEnergyMultiTimeTrend || self.storeType == REMDSEnergyMultiTimeDistribute;
}

-(BOOL)getIsTouChart {
    return self.storeType == REMDSEnergyCostElectricity;
}
@end
