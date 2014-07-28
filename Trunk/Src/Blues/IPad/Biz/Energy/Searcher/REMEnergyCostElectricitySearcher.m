/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyCostElectricitySearcher.m
 * Date Created : tantan on 11/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMEnergyCostElectricitySearcher.h"
#import "REMClientErrorInfo.h"
#import "REMWidgetStepEnergyModel.h"


@implementation REMEnergyCostElectricitySearcher

- (REMBusinessErrorInfo *)beforeSendRequest{
    if(self.contentSyntax.dataStoreType == REMDSEnergyCostElectricity || self.contentSyntax.dataStoreType == REMDSEnergyCostDistributeElectricity){
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        if(stepModel.step == REMEnergyStepHour){
            REMClientErrorInfo *bizError=[[REMClientErrorInfo alloc] init];
            bizError.code=@"";
            bizError.messageInfo=REMIPadLocalizedString(@"Chart_TouNotSupportHourly");
            
            return bizError;
        }
        if(stepModel.step == REMEnergyStepRaw){
            REMClientErrorInfo *bizError=[[REMClientErrorInfo alloc] init];
            bizError.code=@"";
            bizError.messageInfo=REMIPadLocalizedString(@"Chart_TouNotSupportRaw");
            
            return bizError;
        }
    }
    return nil;
}

@end
