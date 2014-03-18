//
//  REMWidgetStepCalculationModel.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/9/14.
//
//

#import "REMWidgetStepCalculationModel.h"
#import "REMCommonDefinition.h"

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
        case 0:
            [list addObject:[NSNumber numberWithInt:1]];
            [titleList addObject: REMIPadLocalizedString(@"Common_Hour")];//小时
            defaultStepIndex=0;
            break;
        case 1:
            [list addObject:[NSNumber numberWithInt:1]];
            [list addObject:[NSNumber numberWithInt:2]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Hour")];//小时
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];//天
            defaultStepIndex=1;
            break;
        case 2:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];//天
            [titleList addObject:REMIPadLocalizedString(@"Common_Week")];//周
            defaultStepIndex=0;
            break;
        case 3:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Day")];//天
            [titleList addObject:REMIPadLocalizedString(@"Common_Week")];//周
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];//月
            defaultStepIndex=2;
            break;
        case 4:
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];//月
            defaultStepIndex=0;
            break;
        case 5:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];//月
            [titleList addObject:REMIPadLocalizedString(@"Common_Year")];//年
            defaultStepIndex=0;
            break;
        case 6:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Month")];//月
            [titleList addObject:REMIPadLocalizedString(@"Common_Year")];//年
            defaultStepIndex=0;
            break;
        case 7:
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:REMIPadLocalizedString(@"Common_Year")];//年
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
