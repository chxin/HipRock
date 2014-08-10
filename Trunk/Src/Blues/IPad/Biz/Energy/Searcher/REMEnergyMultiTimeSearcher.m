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


- (void)makeCompleteEnergyData:(REMEnergyViewData *)data{
    if (data == nil) {
        return ;
    }
    if (data.targetEnergyData == nil || [data.targetEnergyData isEqual:[NSNull null]]==YES) {
        return ;
    }
    REMWidgetTagSearchModel *model=[self tagModel];
    
    NSDate* baseDate1stSeries = [self firstValidDateFromDate:[model.timeRangeArray[0] startTime] forStep:model.step];
    for (int i = 1; i < data.targetEnergyData.count; i++) {
        NSDate* baseDateSeries = [self firstValidDateFromDate:[model.timeRangeArray[i] startTime] forStep:model.step];
        NSTimeInterval interval = [baseDate1stSeries timeIntervalSinceDate:baseDateSeries];
        NSMutableArray* seriesData = [[NSMutableArray alloc]initWithCapacity:[data.targetEnergyData[0] energyData].count];
        for (int j = 0; j < [data.targetEnergyData[0] energyData].count; j++) {
            REMEnergyData* oldEnergyData = [data.targetEnergyData[0] energyData][j];
            REMEnergyData *newEnergyData = [[REMEnergyData alloc]init];
            newEnergyData.localTime=[oldEnergyData.localTime dateByAddingTimeInterval:interval];
            newEnergyData.dataValue=oldEnergyData.dataValue;
            newEnergyData.quality = oldEnergyData.quality;
            [seriesData addObject:newEnergyData];
            newEnergyData.offset = -interval;
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
    
    if (self.contentSyntax.contentSyntaxWidgetType == REMWidgetContentSyntaxWidgetTypePie) {
        return data;
    }
    
    REMWidgetTagSearchModel *model=[self tagModel];
    
    if(model.step == REMEnergyStepHour || model.step == REMEnergyStepRaw){
        return [self processHourData:data];
    }
    else{
        [self makeCompleteEnergyData:data];
    }
    
    
    
    return data;
}

@end
