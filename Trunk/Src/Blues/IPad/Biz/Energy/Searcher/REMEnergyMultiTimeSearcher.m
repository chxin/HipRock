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

- (REMBusinessErrorInfo *)beforeSendRequest
{
//    REMWidgetTagSearchModel *model=[self tagModel];
//    
//    NSTimeInterval distance = [[model.timeRangeArray[0] endTime] timeIntervalSinceDate:[model.timeRangeArray[0] startTime]];
//    
//    for (int i=0; i<model.timeRangeArray.count; i++){
//        REMTimeRange *range = model.timeRangeArray[i];
//        NSTimeInterval temp = [range.endTime timeIntervalSinceDate:range.startTime];
//        
//        if (distance < temp) {
//            distance = temp;
//        }
//    }
//    
//    for (int i=0; i<model.timeRangeArray.count; i++){
//        REMTimeRange *range = model.timeRangeArray[i];
//        range.endTime = [range.startTime dateByAddingTimeInterval:distance];
//    }
    
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
        if(comp.weekday == 2 && hour == 0){
            return date;
        }
        if(comp.weekday == 1){
            [comp setDay:([comp day] - [comp weekday] + 2)];
            [comp setHour:0];
            return [calendar dateFromComponents:comp];
        }
        
        [comp setDay:([comp day] - [comp weekday] + 2+7)];
        [comp setHour:0];
        return [calendar dateFromComponents:comp];
    }
    else if(step == REMEnergyStepMonth){
        int day = [REMTimeHelper getDay:date];
        int hour = [REMTimeHelper getHour:date];
        if (hour == 0 && day == 1) {
            return [REMTimeHelper addMonthToDate:date month:-1];
        }
        else{
            NSDate *newDate = [REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:date];
            comp = [calendar components:unit fromDate:newDate];
            [comp setHour:0];
            [comp setDay:1];
            return [REMTimeHelper addMonthToDate:[calendar dateFromComponents:comp] month:-1];
        }
    }
    else if(step == REMEnergyStepYear){
        int day = [REMTimeHelper getDay:date];
        int hour = [REMTimeHelper getHour:date];
        int month = [REMTimeHelper getMonth:date];
        if (hour == 0 && day == 1 && month ==1) {
            return [REMTimeHelper addMonthToDate:date month:-12];
        }
        else{
            NSDate *newDate = [REMTimeHelper add:1 onPart:REMDateTimePartYear ofDate:date];
            comp = [calendar components:unit fromDate:newDate];
            [comp setHour:0];
            [comp setDay:1];
            [comp setMonth:1];
            return [REMTimeHelper addMonthToDate:[calendar dateFromComponents:comp] month:-12];
        }
    }
    else{
        return nil;
    }
    
    return nil;
}


- (void)makeCompleteEnergyData:(REMEnergyViewData *)data{
    if (data == nil) {
        return ;
    }
    if (data.targetEnergyData == nil || [data.targetEnergyData isEqual:[NSNull null]]==YES) {
        return ;
    }
    REMWidgetTagSearchModel *model=[self tagModel];
    REMEnergyStep step = model.step;
    BOOL isFixedDifferenceTime = (step == REMEnergyStepHour || step == REMEnergyStepDay || step == REMEnergyStepWeek || step == REMEnergyStepRaw);
    NSDate* baseDate1stSeries = [self firstValidDateFromDate:[model.timeRangeArray[0] startTime] forStep:model.step];
    for (int i = 1; i < data.targetEnergyData.count; i++) {
        NSDate* baseDateSeries = [self firstValidDateFromDate:[model.timeRangeArray[i] startTime] forStep:model.step];
        NSMutableArray* seriesData = [[NSMutableArray alloc]initWithCapacity:[data.targetEnergyData[0] energyData].count];
        NSTimeInterval interval;
        int monthInterval = 0;
        
        if (isFixedDifferenceTime) {
            interval = [baseDate1stSeries timeIntervalSinceDate:baseDateSeries];
        } else {
            double year = ((double)[REMTimeHelper getYear:baseDateSeries] - (double)[REMTimeHelper getYear:baseDate1stSeries]);
            double month =(double)[REMTimeHelper getMonth:baseDateSeries] - (double)[REMTimeHelper getMonth:baseDate1stSeries];
            monthInterval = year * 12.0 + month;
        }
        
        for (int j = 0; j < [data.targetEnergyData[0] energyData].count; j++) {
            REMEnergyData* oldEnergyData = [data.targetEnergyData[0] energyData][j];
            REMEnergyData *newEnergyData = [[REMEnergyData alloc]init];
            if (isFixedDifferenceTime) {
                newEnergyData.localTime=[oldEnergyData.localTime dateByAddingTimeInterval:interval];
                newEnergyData.offset = -interval;
            } else {
                newEnergyData.localTime=[REMTimeHelper addMonthToDate:oldEnergyData.localTime month:-monthInterval];
                newEnergyData.offset=[oldEnergyData.localTime timeIntervalSinceDate:newEnergyData.localTime];
            }
            newEnergyData.dataValue=oldEnergyData.dataValue;
            newEnergyData.quality = oldEnergyData.quality;
            [seriesData addObject:newEnergyData];
        }
        [data.targetEnergyData[i] setEnergyData:seriesData];
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
    
    REMTimeRange *baseTimeRange=model.timeRangeArray[0];
    data.globalTimeRange.startTime=baseTimeRange.startTime;
    data.globalTimeRange.endTime=baseTimeRange.endTime;
    
    //
    //REMTargetEnergyData *baseTargetData= data.targetEnergyData[0];
    
    for (int i=0; i<data.targetEnergyData.count; ++i) {
        REMTargetEnergyData *targetEnergyData=data.targetEnergyData[i];
        REMTimeRange *targetTimeRange = model.timeRangeArray[i];
        
        if(targetEnergyData.energyData.count > 0){
            NSTimeInterval offset = [targetTimeRange.startTime timeIntervalSinceDate:baseTimeRange.startTime];
            for (REMEnergyData *point in targetEnergyData.energyData) {
                point.localTime = [point.localTime dateByAddingTimeInterval:-offset];
                point.offset = offset;
            }
        }
    }
    
//    for (int i=1; i<data.targetEnergyData.count; ++i) {
//        REMTargetEnergyData *targetEnergyData=data.targetEnergyData[i];
//        for (int j=0; j<targetEnergyData.energyData.count;++j) {
//            REMEnergyData *baseData=baseTargetData.energyData[j];
//            
//            REMEnergyData *energyData = targetEnergyData.energyData[j];
//            energyData.offset = [energyData.localTime timeIntervalSinceDate:baseData.localTime];
//            energyData.localTime=baseData.localTime;
//        }
//    }

    return data;
}

- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    
    REMEnergyViewData *data=[super processEnergyData:rawData];
    
    if (self.contentSyntax.contentSyntaxWidgetType == REMWidgetContentSyntaxWidgetTypePie) {
        return data;
    }
    
    REMWidgetTagSearchModel *model=[self tagModel];
    
    if(model.step == REMEnergyStepHour || model.step == REMEnergyStepRaw){
        data = [self processHourData:data];
    }
    else{
        [self makeCompleteEnergyData:data];
    }
    
    [self parseGlobalTimeRange:data];
    
    return data;
}

- (void) parseGlobalTimeRange:(REMEnergyViewData *)data
{
    NSDate *start = [[data.targetEnergyData[0] target] visiableTimeRange].startTime;
    NSDate *end = [[data.targetEnergyData[0] target] visiableTimeRange].endTime;
    
    NSTimeInterval distance = [end timeIntervalSinceDate:start];
    
    for (int i=1; i<data.targetEnergyData.count; i++){
        REMTimeRange *range = [[data.targetEnergyData[i] target] globalTimeRange];
        NSTimeInterval temp = [range.endTime timeIntervalSinceDate:range.startTime];
        
        if (distance < temp) {
            distance = temp;
        }
    }
    
    data.visibleTimeRange.endTime = [data.visibleTimeRange.startTime dateByAddingTimeInterval:distance];
}

@end
