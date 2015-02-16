/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyCalendarData.m
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyCalendarData.h"

@implementation REMEnergyCalendarData

-(void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.calendarType = (REMCalendarType)[dictionary[@"CalendarType"] intValue];
    
    NSArray *timeArray = dictionary[@"TimeRangeArray"];
    
    NSMutableArray *timeMArray = [[NSMutableArray alloc]initWithCapacity:timeArray.count];
    
    for (NSArray *rangeDic in timeArray)
    {
        [timeMArray addObject:[[REMTimeRange alloc] initWithArray:rangeDic]];
    }
    
    self.timeRanges = timeMArray;
    
}

@end
