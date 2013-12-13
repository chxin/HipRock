/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTimeRangeDataModel.h
 * Created      : 张 锋 on 8/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMTimeRange.h"
#import "REMEnergyViewData.h"

@interface REMBuildingTimeRangeDataModel : REMJSONObject

@property (nonatomic) REMRelativeTimeRangeType timeRangeType;
@property (nonatomic,strong) REMEnergyViewData *timeRangeData;

@end
