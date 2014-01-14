/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMultiTimespanSearchModel.m
 * Date Created : tantan on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetMultiTimespanSearchModel.h"

@implementation REMWidgetMultiTimespanSearchModel


- (void)setTimeRangeItem:(REMTimeRange *)range AtIndex:(NSUInteger)index
{
    REMTimeRange *oldRange=self.timeRangeArray[0];

    if([oldRange.startTime isEqualToDate:range.startTime]==NO){
        NSMutableArray *newArray=[[NSMutableArray alloc]initWithCapacity:self.timeRangeArray.count];
        NSTimeInterval elapsed=[range.endTime timeIntervalSinceDate:range.startTime];
        NSTimeInterval startGap=[range.startTime timeIntervalSinceDate:oldRange.startTime];
        
        for (int i=0; i<self.timeRangeArray.count; ++i) {
            REMTimeRange *r=self.timeRangeArray[i];
            NSDate *newStart= [r.startTime dateByAddingTimeInterval:startGap];
            NSDate *newEnd=[newStart dateByAddingTimeInterval:elapsed];
            REMTimeRange *newR=[[REMTimeRange alloc]initWithStartTime:newStart EndTime:newEnd];
            [newArray addObject:newR];
        }
        self.timeRangeArray=newArray;
        [self resetStepByTimeRange:newArray[0]];
    }
    
    
    
}

@end
