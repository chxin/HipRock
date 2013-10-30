//
//  REMEnergyCalendarData.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/11/13.
//
//

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
