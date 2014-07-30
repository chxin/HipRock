//
//  REMWidgetStepCalculationModel.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/9/14.
//
//

#import "REMWidgetStepCalculationModel.h"
#import "REMCommonHeaders.h"

@implementation REMWidgetStepCalculationModel

+(NSArray*) getStepIntervalRanges {
    NSMutableArray* intervalRanges = [[NSMutableArray alloc]init];
    [intervalRanges addObject:[NSNull null]];   //    REMEnergyStepNone=0
    [intervalRanges addObject:[NSValue valueWithRange:NSMakeRange(0, REMWEEK)]];    // REMEnergyStepHour=1,
    [intervalRanges addObject:[NSValue valueWithRange:NSMakeRange(REMDAY, REMMONTH*3 - REMDAY)]];// REMEnergyStepDay=2,
    [intervalRanges addObject:[NSValue valueWithRange:NSMakeRange(REMMONTH, NSUIntegerMax-REMMONTH)]];// REMEnergyStepMonth=3,
    [intervalRanges addObject:[NSValue valueWithRange:NSMakeRange(REMYEAR, NSUIntegerMax-REMYEAR)]];// REMEnergyStepYear=4
    [intervalRanges addObject:[NSValue valueWithRange:NSMakeRange(REMWEEK, REMMONTH*3 - REMWEEK)]];// REMEnergyStepWeek=5,
    return intervalRanges;
}

+ (REMWidgetStepCalculationModel *)tryNewStepByRange:(REMTimeRange *)range {
    long diff = [range.endTime timeIntervalSinceDate:range.startTime];
    NSMutableArray *lvs=[[NSMutableArray alloc]initWithCapacity:7];
    [lvs addObject:[NSNumber numberWithLong:REMDAY]];
    [lvs addObject:[NSNumber numberWithLong:REMWEEK]];
    [lvs addObject:[NSNumber numberWithLong:REMDAY*31]];
    [lvs addObject:[NSNumber numberWithLong:REMDAY*31*3]];
    [lvs addObject:[NSNumber numberWithLong:REMYEAR]];
    [lvs addObject:[NSNumber numberWithLong:REMYEAR*2]];
    
    [lvs addObject:[NSNumber numberWithLong:REMYEAR*10]];
    
    //long[ *lvs = @[REMDAY,REMWEEK,31*REMDAY,31*3*REMDAY,REMYEAR,REMYEAR*2,REMYEAR*10];
    int i=0;
    for ( ; i<lvs.count; ++i)
    {
        NSNumber *num = lvs[i];
        if(diff<=[num longValue])
        {
            break;
        }
    }
    NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *titleList=[[NSMutableArray alloc] initWithCapacity:3];
    int defaultStepIndex=0;
    switch (i) {
        case 0: //day
            [list addObject:@(REMEnergyStepRaw)];
            [list addObject:@(REMEnergyStepHour)];
            
            [titleList addObject:REMIPadLocalizedString(@"Widget_StepRaw")];
            [titleList addObject: REMIPadLocalizedString(@"Common_Hour")];
            defaultStepIndex=1;
            break;
        case 1: //week
            [list addObject:@(REMEnergyStepRaw)];
            [list addObject:@(REMEnergyStepHour)];
            [list addObject:@(REMEnergyStepDay)];
            [titleList addObject:REMIPadLocalizedString(@"Widget_StepRaw")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Hour")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];
            defaultStepIndex=2;
            break;
        case 2: //1month
            [list addObject:@(REMEnergyStepRaw)];
            [list addObject:@(REMEnergyStepHour)];
            [list addObject:@(REMEnergyStepDay)];
            [list addObject:@(REMEnergyStepWeek)];
            [titleList addObject:REMIPadLocalizedString(@"Widget_StepRaw")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Hour")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Week")];
            defaultStepIndex=2;
            break;
        case 3: //3month
            [list addObject:@(REMEnergyStepRaw)];
            [list addObject:@(REMEnergyStepHour)];
            [list addObject:@(REMEnergyStepDay)];
            [list addObject:@(REMEnergyStepWeek)];
            [list addObject:@(REMEnergyStepMonth)];
            [titleList addObject:REMIPadLocalizedString(@"Widget_StepRaw")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Hour")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Week")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];
            defaultStepIndex=4;
            break;
        case 4: // 1year
            [list addObject:@(REMEnergyStepHour)];
            [list addObject:@(REMEnergyStepDay)];
            [list addObject:@(REMEnergyStepWeek)];
            [list addObject:@(REMEnergyStepMonth)];
            [titleList addObject:REMIPadLocalizedString(@"Common_Hour")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Week")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];
            defaultStepIndex=3;
            break;
        case 5: //2year
        case 6: //10year
            [list addObject:@(REMEnergyStepDay)];
            [list addObject:@(REMEnergyStepWeek)];
            [list addObject:@(REMEnergyStepMonth)];
            [list addObject:@(REMEnergyStepYear)];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Week")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];
            [titleList addObject:REMIPadLocalizedString(@"Common_Year")];
            defaultStepIndex=2;
            break;
        case 7: //over 10 years
            [list addObject:@(REMEnergyStepYear)];
            [titleList addObject:REMIPadLocalizedString(@"Common_Year")];
            defaultStepIndex=0;
            break;
        default:
            break;
    }
    
    if (list.count==0) {
        return nil;
    }
    REMEnergyStep defaultStep=(REMEnergyStep)[list[defaultStepIndex] integerValue];
    
    REMWidgetStepCalculationModel *retModel=[[REMWidgetStepCalculationModel alloc]init];
    retModel.stepList=list;
    retModel.titleList=titleList;
    retModel.defaultStep=defaultStep;
    retModel.defaultStepIndex=defaultStepIndex;
    
    return retModel;
}

@end
