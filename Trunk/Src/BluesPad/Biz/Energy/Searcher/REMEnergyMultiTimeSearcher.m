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

@implementation REMEnergyMultiTimeSearcher



- (NSTimeInterval)deltaTimeIntervalFromBaseTime:(NSDate *)baseTime ToSecondTime:(NSDate *)secondTime{
    
    NSDate *newBase;
    NSDate *newFollow;
    REMEnergyStep step=self.widgetInfo.contentSyntax.stepType;
    if(step == REMEnergyStepDay){
        newBase=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:baseTime] Month:[REMTimeHelper getMonth:baseTime] Day:[REMTimeHelper getDay:baseTime] Hour:0];
        if([REMTimeHelper getHour:baseTime]>0){
            newBase =[REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:newBase];
        }
        newFollow=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:secondTime] Month:[REMTimeHelper getMonth:secondTime] Day:[REMTimeHelper getDay:secondTime] Hour:0];
        if([REMTimeHelper getHour:newFollow]>0){
            newFollow =[REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:newFollow];
        }
    }
    else if(step == REMEnergyStepWeek)
    {
        newBase =[REMTimeHelper getNextMondayFromDate:baseTime];
        newFollow=[REMTimeHelper getNextMondayFromDate:secondTime];
    }
    else if(step == REMEnergyStepMonth){
        newBase=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:baseTime] Month:[REMTimeHelper getMonth:baseTime] Day:1 Hour:0];
        if([REMTimeHelper getDay:newBase] !=1 || [REMTimeHelper getHour:newBase]!=0){
            newBase =[REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:newBase];
        }
        newFollow=[REMTimeHelper dateFromYear:[REMTimeHelper getYear:secondTime] Month:[REMTimeHelper getMonth:secondTime] Day:1 Hour:0];
        if([REMTimeHelper getDay:newFollow] !=1 || [REMTimeHelper getHour:newFollow]!=0){
            newFollow =[REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:newFollow];
        }
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
    }
    else{
        return 0;
    }
    
    return [newFollow timeIntervalSinceDate:newBase];
    
}


- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData{
    REMEnergyViewData *data=[super processEnergyData:rawData];
    
    if(self.widgetInfo.contentSyntax.stepType == REMEnergyStepHour) return data;
    
    REMTargetEnergyData *baseData= data.targetEnergyData[0];
    
    
    
    REMTimeRange *baseTimeRange=baseData.target.visiableTimeRange;
   
    

    for (int i=1; i<data.targetEnergyData.count; ++i) {
        REMTargetEnergyData *followData=data.targetEnergyData[i];
        NSMutableArray *energyDataArray=[[NSMutableArray alloc]initWithCapacity:baseData.energyData.count];
        REMTimeRange *followTimeRange=followData.target.visiableTimeRange;
        NSTimeInterval delta = [self deltaTimeIntervalFromBaseTime:baseTimeRange.startTime ToSecondTime:followTimeRange.startTime];
        for (int j=0; j<baseData.energyData.count; ++j) {
            REMEnergyData *energyData=[[REMEnergyData alloc]init];
            REMEnergyData *origData=baseData.energyData[j];
            energyData.localTime=[origData.localTime dateByAddingTimeInterval:delta];
            energyData.dataValue=[origData.dataValue copy];
            energyData.quality=origData.quality;
            [energyDataArray addObject:energyData];
            
        }
        followData.energyData=energyDataArray;
    }
    
    return data;
}

@end
