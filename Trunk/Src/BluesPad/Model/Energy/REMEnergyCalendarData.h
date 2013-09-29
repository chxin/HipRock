//
//  REMEnergyCalendarData.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeRange.h"
#import "REMEnum.h"
/*
typedef enum _REMCalendarType:NSUInteger {
    WorkDay = 0,
    Holiday = 1,
    WorkTime=2,
    RestTime=3,
    HeatingSeason=4,
    CoolingSeason=5,
    Day=6,
    Night=7
} REMCalendarType;*/



@interface REMEnergyCalendarData : REMJSONObject


@property (nonatomic,strong) NSArray *timeRanges;
@property (nonatomic) REMCalendarType calendarType;


@end
