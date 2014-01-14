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
        _isUnitChart = NO;
    }
    return self;
}

-(id)initWith:(REMWidgetObject*)widgetObj {
    self = [self init];
    if (self) {
        _calendarType=widgetObj.contentSyntax.calendarType;
        _rankingDefaultSortOrder=widgetObj.contentSyntax.rankingSortOrder;
        _rankingRangeCode=widgetObj.contentSyntax.rankingRangeCode;
        REMDataStoreType storeType = widgetObj.contentSyntax.dataStoreType;
        _isUnitChart = (storeType==REMDSEnergyTagsTrendUnit || storeType==REMDSEnergyCarbonUnit || storeType==REMDSEnergyCostUnit);
    }
    return self;
}
@end
