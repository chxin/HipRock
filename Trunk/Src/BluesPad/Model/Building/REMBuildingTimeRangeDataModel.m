//
//  REMBuildingTimeRangeDataModel.m
//  Blues
//
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
