//
//  REMWidgetSearchModelBase.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetSearchModelBase.h"

@implementation REMWidgetSearchModelBase

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType
{
    
}

- (REMEnergyStep)stepTypeByNumber:(NSNumber *)stepNumber
{
    
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
