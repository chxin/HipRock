//
//  REMWidgetStepEnergyModel.m
//  Blues
//
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetStepEnergyModel.h"

@implementation REMWidgetStepEnergyModel




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

- (id)copyWithZone:(NSZone *)zone{
    REMWidgetStepEnergyModel *base=[super copyWithZone:zone];
    base.step=self.step;
    base.zoneId=[self.zoneId copyWithZone:zone];
    base.industryId=[self.industryId copyWithZone:zone];
    base.relativeDateComponent=[self.relativeDateComponent copyWithZone:zone];
    base.relativeDateType=self.relativeDateType;
    return base;
}


@end
