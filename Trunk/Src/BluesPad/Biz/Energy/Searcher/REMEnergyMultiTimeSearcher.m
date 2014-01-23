/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyMultiTimeSearcher.m
 * Created      : tantan on 10/10/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyMultiTimeSearcher.h"
#import "REMTargetEnergyData.h"
#import "REMEnergyData.h"
#import "REMWidgetTagSearchModel.h"


@implementation REMEnergyMultiTimeSearcher

- (REMWidgetTagSearchModel *)tagModel{
    return (REMWidgetTagSearchModel *)self.model;
}

- (NSDate *)deltaTimeIntervalFromBaseTime:(NSDate *)baseTime ToSecondTime:(NSDate *)secondTime origTime:(NSDate *)origTime{
    
    NSDate *newBase;
    NSDate *newFollow;
    REMEnergyStep step=[self tagModel].step;
    
    if(step == REMEnergyStepDay){
        newBase=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:baseTime] Month:[REMTimeHelper getMonth:baseTime] Day:[REMTimeHelper getDay:baseTime] Hour:0];
        if([REMTimeHelper getHour:baseTime]>0){
            newBase =[REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:newBase];
        }
        newFollow=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:secondTime] Month:[REMTimeHelper getMonth:secondTime] Day:[REMTimeHelper getDay:secondTime] Hour:0];
        if([REMTimeHelper getHour:newFollow]>0){
            newFollow =[REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:newFollow];
        }
        return [origTime dateByAddingTimeInterval:-[newFollow timeIntervalSinceDate:newBase]];
    }
    else if(step == REMEnergyStepWeek)
    {
        newBase =[REMTimeHelper getNextMondayFromDate:baseTime];
        newFollow=[REMTimeHelper getNextMondayFromDate:secondTime];
        return [origTime dateByAddingTimeInterval:-[newFollow timeIntervalSinceDate:newBase]];
    }
    else if(step == REMEnergyStepMonth){
        newBase=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:baseTime] Month:[REMTimeHelper getMonth:baseTime] Day:1 Hour:0];
        if([REMTimeHelper getDay:baseTime] !=1 || [REMTimeHelper getHour:baseTime]!=0){
            newBase =[REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:newBase];
        }
        newFollow=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:secondTime] Month:[REMTimeHelper getMonth:secondTime] Day:1 Hour:0];
        if([REMTimeHelper getDay:secondTime] !=1 || [REMTimeHelper getHour:secondTime]!=0){
            newFollow =[REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:newFollow];
        }
        NSTimeInterval interval=[newFollow timeIntervalSinceDate:newBase];
        CGFloat m=60*60*24*31;
        int gap= round(interval/m);
        return [REMTimeHelper add:-gap onPart:REMDateTimePartMonth ofDate:origTime];
        
        
    }
    else if(step==REMEnergyStepYear){
        newBase=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:baseTime] Month:1 Day:1 Hour:0];
        if( [REMTimeHelper getMonth:newBase] !=1 || [REMTimeHelper getDay:baseTime] !=1 || [REMTimeHelper getHour:baseTime]!=0){
            newBase =[REMTimeHelper add:1 onPart:REMDateTimePartYear ofDate:newBase];
        }
        newFollow=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:secondTime] Month:1 Day:1 Hour:0];
        if( [REMTimeHelper getMonth:newFollow] !=1 || [REMTimeHelper getDay:newFollow] !=1 || [REMTimeHelper getHour:newFollow]!=0){
            newFollow =[REMTimeHelper add:1 onPart:REMDateTimePartYear ofDate:newFollow];
        }
        NSTimeInterval interval=[newFollow timeIntervalSinceDate:newBase];
        CGFloat m=60*60*24*366;
        int gap= round(interval/m);
        return [REMTimeHelper add:-gap onPart:REMDateTimePartMonth ofDate:origTime];
    }
    else{
        return nil;
    }
    
    return nil;
    
}

- (NSDate *)firstValidDateFromDate:(NSDate *)date forStep:(REMEnergyStep)step{
    NSCalendar *calendar = [REMTimeHelper currentCalendar];
    NSCalendarUnit unit =NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour;
    NSDateComponents *comp ;
    if (step == REMEnergyStepHour) {
        int minute= [REMTimeHelper getMinute:date];
        if (minute == 0) {
            return date;
        }
    }
    else if(step == REMEnergyStepDay){
        int hour = [REMTimeHelper getHour:date];
        if (hour == 0) {
            return date;
        }
        else{
            NSDate *newDate = [REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:date];
            comp = [calendar components:unit fromDate:newDate];
            [comp setHour:0];
            return [calendar dateFromComponents:comp];
            
        }
        
    }
    else if (step == REMEnergyStepWeek){
        comp = [calendar components:unit fromDate:date];
        int hour = [REMTimeHelper getHour:date];
        if(comp.weekday == 1 && hour == 0){
            return date;
        }
        else{
            [comp setDay:([comp day] - [comp weekday] + 2+7)];
            [comp setHour:0];
            return [calendar dateFromComponents:comp];
        }
        
    }
    else if(step == REMEnergyStepMonth){
        int day = [REMTimeHelper getDay:date];
        int hour = [REMTimeHelper getHour:date];
        if (hour == 0 && day == 1) {
            return date;
        }
        else{
            NSDate *newDate = [REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:date];
            comp = [calendar components:unit fromDate:newDate];
            [comp setHour:0];
            [comp setDay:1];
            return [calendar dateFromComponents:comp];
        }
    }
    else if(step == REMEnergyStepYear){
        int day = [REMTimeHelper getDay:date];
        int hour = [REMTimeHelper getHour:date];
        int month = [REMTimeHelper getMonth:date];
        if (hour == 0 && day == 1 && month ==1) {
            return date;
        }
        else{
            NSDate *newDate = [REMTimeHelper add:1 onPart:REMDateTimePartYear ofDate:date];
            comp = [calendar components:unit fromDate:newDate];
            [comp setHour:0];
            [comp setDay:1];
            [comp setMonth:1];
            return [calendar dateFromComponents:comp];
        }
    }
    else{
        return nil;
    }
    
    return nil;
}

- (NSDate *)addDate:(NSDate *)date byStep:(REMEnergyStep)step{
    NSDate *newDate=nil;
    if (step == REMEnergyStepHour) {
        newDate = [REMTimeHelper add:1 onPart:REMDateTimePartHour ofDate:date];
    }
    else if(step == REMEnergyStepDay){
        newDate = [REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:date];
    }
    else if (step == REMEnergyStepWeek){
        newDate = [REMTimeHelper add:7 onPart:REMDateTimePartDay ofDate:date];
    }
    else if(step == REMEnergyStepMonth){
        newDate = [REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:date];
    }
    else if(step == REMEnergyStepYear){
        newDate = [REMTimeHelper add:1 onPart:REMDateTimePartYear ofDate:date];
    }
    return newDate;
}

- (void)makeCompleteEnergyData:(REMEnergyViewData *)data{
    if (data == nil) {
        return ;
    }
    if (data.targetEnergyData == nil || [data.targetEnergyData isEqual:[NSNull null]]==YES) {
        return ;
    }
    REMWidgetTagSearchModel *model=[self tagModel];

    for (int i=0; i<data.targetEnergyData.count; ++i) {
        REMTimeRange *baseTimeRange=model.timeRangeArray[i];
        NSDate *validDate = [self firstValidDateFromDate:baseTimeRange.startTime forStep:model.step];
        REMTargetEnergyData *targetEnergyData=data.targetEnergyData[i];
        NSMutableArray *newEnergyDataArray = [NSMutableArray array];
        
        for (int j=0; j<targetEnergyData.energyData.count;++j) {
            REMEnergyData *energyData = targetEnergyData.energyData[j];
            if (energyData.localTime < validDate) {
                validDate=energyData.localTime;
            }
            if ([energyData.localTime isEqualToDate:validDate]==YES) {
                [newEnergyDataArray addObject:energyData];
            }
            else{
                REMEnergyData *newEnergyData = [[REMEnergyData alloc]init];
                newEnergyData.localTime=[validDate copy];
                newEnergyData.dataValue=nil;
                newEnergyData.quality = REMEnergyDataQualityGood;
                [newEnergyDataArray addObject:energyData];
            }
            validDate= [self addDate:validDate byStep:model.step];
        }
        targetEnergyData.energyData=newEnergyDataArray;
    }
}

- (REMEnergyViewData *)processHourData:(REMEnergyViewData *)data{
    if (data == nil) {
        return nil;
    }
    if (data.targetEnergyData == nil || [data.targetEnergyData isEqual:[NSNull null]]==YES) {
        return data;
    }
    REMWidgetTagSearchModel *model=[self tagModel];
    
    REMTargetEnergyData *baseTargetData= data.targetEnergyData[0];
    
    REMTimeRange *baseTimeRange=model.timeRangeArray[0];
    
    NSDate *minStart = baseTimeRange.startTime;
    NSDate *maxEnd= baseTimeRange.endTime;
    
    for (int i=1; i<data.targetEnergyData.count; ++i) {
        REMTargetEnergyData *targetEnergyData=data.targetEnergyData[i];
        for (int j=0; j<targetEnergyData.energyData.count;++j) {
            REMEnergyData *energyData = targetEnergyData.energyData[j];
            REMEnergyData *baseData=baseTargetData.energyData[j];
            energyData.offset = [energyData.localTime timeIntervalSinceDate:baseData.localTime];
            energyData.localTime=baseData.localTime;
        }
    }
    
    data.globalTimeRange.startTime=minStart;
    data.globalTimeRange.endTime=maxEnd;

    return data;
}

- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    
    REMEnergyViewData *data=[super processEnergyData:rawData];
    
    if (self.widgetInfo.diagramType == REMDiagramTypePie) {
        return data;
    }
    
    [self makeCompleteEnergyData:data];
    
    REMWidgetTagSearchModel *model=[self tagModel];
    
    if(model.step == REMEnergyStepHour){
        return [self processHourData:data];
    }
    
    REMTargetEnergyData *baseData= data.targetEnergyData[0];
    
    
    
    REMTimeRange *baseTimeRange=model.timeRangeArray[0];
   
    NSDate *minStart = [NSDate date];
    NSDate *maxEnd= [NSDate dateWithTimeIntervalSince1970:0];

    for (int i=1; i<data.targetEnergyData.count; ++i) {
        REMTargetEnergyData *followData=data.targetEnergyData[i];
        NSMutableArray *energyDataArray=[[NSMutableArray alloc]initWithCapacity:baseData.energyData.count];
        REMTimeRange *followTimeRange=model.timeRangeArray[i];

        for (int j=0; j<baseData.energyData.count; ++j) {
            REMEnergyData *energyData=[[REMEnergyData alloc]init];
            REMEnergyData *origData=baseData.energyData[j];
            NSDate *newDate = [self deltaTimeIntervalFromBaseTime:baseTimeRange.startTime ToSecondTime:followTimeRange.startTime origTime:origData.localTime];
            energyData.offset = [newDate timeIntervalSinceDate:origData.localTime];
            energyData.localTime=newDate;
            energyData.dataValue=[origData.dataValue copy];
            energyData.quality=origData.quality;
            [energyDataArray addObject:energyData];
            
        }
        followData.energyData=energyDataArray;
    }
    
    for (REMTargetEnergyData *energyData in data.targetEnergyData) {
        REMEnergyData *startData = energyData.energyData[0];
        REMEnergyData *endData=energyData.energyData[energyData.energyData.count-1];
        if ([startData.localTime compare:minStart] == NSOrderedAscending) {
            minStart=[startData.localTime copy];
        }
        if ([endData.localTime compare:maxEnd] == NSOrderedDescending) {
            maxEnd=[endData.localTime copy];
        }
    }
    
    data.globalTimeRange.startTime=minStart;
    data.globalTimeRange.endTime=maxEnd;
    
    
    return data;
}

@end
