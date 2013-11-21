/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCarbonLegendFormator.m
 * Date Created : 张 锋 on 11/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLegendFormatorBase.h"

@implementation REMCarbonLegendFormator


-(NSString *)format:(int)index
{
    //if target.type == 
    if(self.data!=nil && self.data.targetEnergyData!=nil && self.data.targetEnergyData.count>0 && index>=0 && index < self.data.targetEnergyData.count){
        REMEnergyTargetModel *target = [self.data.targetEnergyData[index] target];
        
        if(target!=nil){
            return target.name;
        }
    }
    
    return nil;
}

@end
