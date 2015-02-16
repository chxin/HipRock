/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTimeRangeDataModel.m
 * Created      : 张 锋 on 8/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingTimeRangeDataModel.h"
#import "REMTimeRange.h"

@implementation REMBuildingTimeRangeDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.timeRangeType = (REMRelativeTimeRangeType)[dictionary[@"TimeRangeType"] intValue];
    self.timeRangeData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"TimeRangeData"]];
}

@end
