//
//  REMBuildingTimeRangeDataModel.h
//  Blues
//
//  Created by 张 锋 on 8/12/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeRange.h"
#import "REMEnergyViewData.h"

@interface REMBuildingTimeRangeDataModel : REMJSONObject

@property (nonatomic) REMRelativeTimeRangeType timeRangeType;
@property (nonatomic,strong) REMEnergyViewData *timeRangeData;

@end
