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
        _stacked = NO;
        _isUnitOrRatioChart = NO;
        _isMultiTimeChart = NO;
    }
    return self;
}

-(id)initWith:(REMWidgetContentSyntax*)contentSyntax {
    self = [self init];
    if (self) {
        _calendarType=contentSyntax.calendarType;
        _rankingDefaultSortOrder=contentSyntax.rankingSortOrder;
        _rankingRangeCode=contentSyntax.rankingRangeCode;
        REMDataStoreType storeType = contentSyntax.dataStoreType;
        _isUnitOrRatioChart = (storeType==REMDSEnergyTagsTrendUnit || storeType==REMDSEnergyCarbonUnit || storeType==REMDSEnergyCostUnit || storeType==REMDSEnergyRatio);
        _isMultiTimeChart = (storeType == REMDSEnergyMultiTimeTrend || storeType == REMDSEnergyMultiTimeDistribute);
    }
    return self;
}
@end
