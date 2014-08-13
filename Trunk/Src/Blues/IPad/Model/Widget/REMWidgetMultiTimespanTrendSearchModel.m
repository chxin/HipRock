/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMultiTimespanTrendSearchModel.m
 * Date Created : 张 锋 on 8/13/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetMultiTimespanTrendSearchModel.h"

@implementation REMWidgetMultiTimespanTrendSearchModel

- (NSArray *)timeRangeToDictionaryArray
{
    NSTimeInterval distance = [[self.timeRangeArray[0] endTime] timeIntervalSinceDate:[self.timeRangeArray[0] startTime]];
    
    for (int i=0; i<self.timeRangeArray.count; i++){
        REMTimeRange *range = self.timeRangeArray[i];
        NSTimeInterval temp = [range.endTime timeIntervalSinceDate:range.startTime];
        
        if (distance < temp) {
            distance = temp;
        }
    }
    
    NSMutableArray *newTimeRangeArray=[[NSMutableArray alloc]initWithCapacity:self.timeRangeArray.count];
    
    for (int i=0; i<self.timeRangeArray.count; i++){
        REMTimeRange *range = self.timeRangeArray[i];
        NSDate *endTime = [range.startTime dateByAddingTimeInterval:distance];
        
        [newTimeRangeArray addObject:@{@"StartTime":[REMTimeHelper jsonStringFromDate:range.startTime],@"EndTime":[REMTimeHelper jsonStringFromDate:endTime]}];
    }
    
    return newTimeRangeArray;
}

@end
