/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyViewData.m
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyViewData.h"

@implementation REMEnergyViewData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    if([dictionary[@"TargetEnergyData"] isEqual:[NSNull null]] == NO){
        NSArray *targetArray= dictionary[@"TargetEnergyData"];
        
        NSMutableArray *targetMArray = [[NSMutableArray alloc]initWithCapacity:targetArray.count];
        
        for(NSDictionary *targetDic in targetArray)
        {
            REMTargetEnergyData *energyData = [[REMTargetEnergyData alloc]initWithDictionary:targetDic];
//            if (!energyData.dataError) {
                [targetMArray addObject:energyData];
//            }
            
        }
        self.targetEnergyData=targetMArray;
    }
    
    
    NSArray *calendarArray= dictionary[@"Calendars"];
    
    if([calendarArray isEqual: [NSNull null]] == NO)
    {
        NSMutableArray *calendarMArray=[[NSMutableArray alloc]initWithCapacity:calendarArray.count];
        
        for(NSDictionary *calcDic in calendarArray)
        {
            [calendarMArray addObject:[[REMEnergyCalendarData alloc]initWithDictionary:calcDic]];
        }
        self.calendarData=calendarMArray;
    }
    
    
    
    
    NSArray *error= dictionary[@"Errors"];
    
    if([error isEqual:[NSNull null]] ==NO )
    {
        NSMutableArray *errorMArray=[[NSMutableArray alloc]initWithCapacity:error.count];
        
        
        
        for(NSDictionary *errorDic in error)
        {
            [errorMArray addObject:[[REMEnergyError alloc]initWithDictionary:errorDic]];
        }
        self.error=errorMArray;
        
    }
    
    if((NSNull *)dictionary[@"VisibleTimeRange"] != [NSNull null] && dictionary[@"VisibleTimeRange"]!= nil)
    {
        self.visibleTimeRange = [[REMTimeRange alloc] initWithDictionary:(NSDictionary *)dictionary[@"VisibleTimeRange"]];
    }
    
    if((NSNull *)dictionary[@"GlobalTimeRange"] != [NSNull null] && dictionary[@"GlobalTimeRange"]!= nil)
    {
        self.globalTimeRange = [[REMTimeRange alloc] initWithDictionary:(NSDictionary *)dictionary[@"GlobalTimeRange"]];
    }
    
    NSArray *labellingArray=dictionary[@"LabellingLevels"];
    if ([labellingArray isEqual:[NSNull null]]==NO) {
        NSMutableArray *labellings=[[NSMutableArray alloc]initWithCapacity:labellingArray.count];
        for (int i=0; i<labellingArray.count; ++i) {
            [labellings addObject:[[REMEnergyLabellingLevelData alloc]initWithDictionary:labellingArray[i]]];
        }
        self.labellingLevelArray=labellings;
    }
}

@end
