//
//  REMEnergyCalendarData.m
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMEnergyCalendarData.h"

@implementation REMEnergyCalendarData

-(void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.calendarType = (REMCalendarType)[dictionary[@"CalendarType"] intValue];
    
    NSArray *timeArray = dictionary[@"CalendarTimeRanges"];
    
    NSMutableArray *timeMArray = [[NSMutableArray alloc]initWithCapacity:timeArray.count];
    
    for (NSDictionary *rangeDic in timeArray)
    {
        [timeMArray addObject:[[REMTimeRange alloc] initWithDictionary:rangeDic]];
    }
    
    self.timeRanges = timeMArray;
    
}

@end
