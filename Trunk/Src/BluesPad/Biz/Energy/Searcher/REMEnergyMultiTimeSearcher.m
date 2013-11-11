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



- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    REMEnergyViewData *data=[super processEnergyData:rawData];
    
    REMWidgetTagSearchModel *model=[self tagModel];
    
    if(model.step == REMEnergyStepHour) return data;
    
    REMTargetEnergyData *baseData= data.targetEnergyData[0];
    
    
    
    REMTimeRange *baseTimeRange=model.timeRangeArray[0];
   
    

    for (int i=1; i<data.targetEnergyData.count; ++i) {
        REMTargetEnergyData *followData=data.targetEnergyData[i];
        NSMutableArray *energyDataArray=[[NSMutableArray alloc]initWithCapacity:baseData.energyData.count];
        REMTimeRange *followTimeRange=model.timeRangeArray[i];

        for (int j=0; j<baseData.energyData.count; ++j) {
            REMEnergyData *energyData=[[REMEnergyData alloc]init];
            REMEnergyData *origData=baseData.energyData[j];
            energyData.localTime=[self deltaTimeIntervalFromBaseTime:baseTimeRange.startTime ToSecondTime:followTimeRange.startTime origTime:origData.localTime];
            energyData.dataValue=[origData.dataValue copy];
            energyData.quality=origData.quality;
            [energyDataArray addObject:energyData];
            
        }
        followData.energyData=energyDataArray;
    }
    
    return data;
}

@end
