//
//  REMEnergyViewData.m
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMEnergyViewData.h"

@implementation REMEnergyViewData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *globalDataDict = dictionary[@"TargetGlobalData"];
    if([globalDataDict isEqual:[NSNull null]] == NO)
    {
        self.targetGlobalData = [[REMTargetEnergyData alloc]initWithDictionary:globalDataDict];
    }
    
    if([dictionary[@"TargetEnergyData"] isEqual:[NSNull null]] == NO){
        NSArray *targetArray= dictionary[@"TargetEnergyData"];
        
        NSMutableArray *targetMArray = [[NSMutableArray alloc]initWithCapacity:targetArray.count];
        
        for(NSDictionary *targetDic in targetArray)
        {
            [targetMArray addObject:[[REMTargetEnergyData alloc]initWithDictionary:targetDic]];
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
    
}

@end
