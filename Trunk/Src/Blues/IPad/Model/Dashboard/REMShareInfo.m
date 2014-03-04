/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMShareInfo.m
 * Created      : tantan on 9/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMShareInfo.h"
#import "REMTimeHelper.h"

@implementation REMShareInfo

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary{
    self.userRealName=dictionary[@"UserRealName"];
    
    self.userTelephone=dictionary[@"UserTelephone"];
    NSString *time = dictionary[@"ShareTime"];
    long long longTime=[REMTimeHelper longLongFromJSONString:time];
    if (longTime==0) {
        self.shareTime=nil;
    }
    else{
        self.shareTime=[NSDate dateWithTimeIntervalSince1970:longTime/1000];
    }
    
    NSNumber *userTitle=dictionary[@"UserTitle"];
    self.userTitle = (REMUserTitleType)[userTitle integerValue];
    
    NSString *title;
    /*
     REMUserTitleEEConsultant = 0,
     REMUserTitleTechnician = 1,
     REMUserTitleCustomerAdmin = 2,
     REMUserTitlePlatformAdmin=3,
     REMUserTitleEnergyManager=4,
     REMUserTitleEnergyEngineer=5,
     REMUserTitleDepartmentManager=6,
     REMUserTitleCEO=7,
     REMUserTitleBusinessPersonnel=8,
     REMUserTitleSaleman=9,
     REMUserTitleServiceProviderAdmin=10
     */
    
    if (self.userTitle == REMUserTitleEEConsultant) {
        title=REMIPadLocalizedString(@"Admin_UserTitleEEConsultant");
    }
    else if(self.userTitle == REMUserTitleTechnician){
        title=REMIPadLocalizedString(@"Admin_UserTitleTechnician");
    }
    else if(self.userTitle == REMUserTitleCustomerAdmin){
        title=REMIPadLocalizedString(@"Admin_UserTitleCustomerAdmin");
    }
    else if(self.userTitle == REMUserTitlePlatformAdmin){
        title=REMIPadLocalizedString(@"Admin_UserTitlePlatformAdmin");
    }
    else if(self.userTitle == REMUserTitleEnergyManager){
        title=REMIPadLocalizedString(@"Admin_UserTitleEnergyManager");
    }
    else if(self.userTitle == REMUserTitleEnergyEngineer){
        title=REMIPadLocalizedString(@"Admin_UserTitleEnergyEngineer");
    }
    else if(self.userTitle == REMUserTitleDepartmentManager){
        title=REMIPadLocalizedString(@"Admin_UserTitleDepartmentManager");
    }
    else if(self.userTitle == REMUserTitleCEO){
        title=REMIPadLocalizedString(@"Admin_UserTitleCEO");
    }
    else if(self.userTitle == REMUserTitleBusinessPersonnel){
        title=REMIPadLocalizedString(@"Admin_UserTitleBusinessPersonnel");
    }
    else if(self.userTitle == REMUserTitleSaleman){
        title=REMIPadLocalizedString(@"Admin_UserTitleSaleman");
    }
    else if(self.userTitle == REMUserTitleServiceProviderAdmin){
        title=REMIPadLocalizedString(@"Admin_UserTitleServiceProviderAdmin");
    }
    self.userTitleComponent=title;
}

@end