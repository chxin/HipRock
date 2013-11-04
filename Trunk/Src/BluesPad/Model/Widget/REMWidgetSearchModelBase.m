//
//  REMWidgetSearchModelBase.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetTagSearchModel.h"
#import "REMWidgetCommoditySearchModel.h"


@implementation REMWidgetSearchModelBase

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType withParam:(NSDictionary *)param
{
    REMWidgetSearchModelBase *model=nil;
    if(dataStoreType == REMDSEnergyTagsTrend ||
       dataStoreType == REMDSEnergyTagsTrendUnit ||
       dataStoreType == REMDSEnergyTagsDistribute ||
       dataStoreType ==REMDSEnergyMultiTimeTrend ||
       dataStoreType == REMDSEnergyMultiTimeDistribute){
        model = [[REMWidgetTagSearchModel alloc]init];
    }
    else if(dataStoreType ==REMDSEnergyCarbon ||
            dataStoreType ==REMDSEnergyCarbonDistribute ||
            dataStoreType == REMDSEnergyCarbonUnit ||
            dataStoreType == REMDSEnergyCost ||
            dataStoreType ==REMDSEnergyCostDistribute ||
            dataStoreType == REMDSEnergyCostElectricity ||
            dataStoreType == REMDSEnergyCostUnit)
    {
        model = [[REMWidgetCommoditySearchModel alloc]init];
    }
    [model setModelBySearchParam:param];
    
    return model;
}

- (REMEnergyStep)stepTypeByNumber:(NSNumber *)stepNumber
{
    if ([stepNumber isEqualToNumber:@(1)]== YES) {
        return REMEnergyStepHour;
    }
    else if([stepNumber isEqualToNumber:@(2)]==YES){
        return REMEnergyStepDay;
    }
    else if([stepNumber isEqualToNumber:@(3)]==YES){
        return REMEnergyStepMonth;
    }
    else if([stepNumber isEqualToNumber:@(4)]==YES){
        return REMEnergyStepYear;
    }
    else if([stepNumber isEqualToNumber:@(5)]==YES){
        return REMEnergyStepWeek;
    }
    
    return REMEnergyStepNone;
}

- (NSNumber *)stepNumberByStep:(REMEnergyStep)stepType{
    NSNumber *step;
    if(stepType == REMEnergyStepHour){
        step=@(1);
    }
    else if(stepType== REMEnergyStepDay){
        step=@(2);
    }
    else if(stepType == REMEnergyStepWeek){
        step=@(5);
    }
    else if(stepType == REMEnergyStepMonth){
        step=@(3);
    }
    else if(stepType == REMEnergyStepYear){
        step=@(4);
    }
    
    return step;

}

@end
