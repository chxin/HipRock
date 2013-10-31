//
//  REMBuildingTimeRangeDataModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/12/13.
//
//

#import "REMBuildingTimeRangeDataModel.h"
#import "REMTimeRange.h"

@implementation REMBuildingTimeRangeDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.timeRangeType = (REMRelativeTimeRangeType)[dictionary[@"TimeRangeType"] intValue];
    self.timeRangeData = [[REMEnergyViewData alloc] initWithDictionary:dictionary[@"TimeRangeData"]];
}

@end
