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
        self.shareTime=[NSDate dateWithTimeIntervalSince1970:longTime];
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
        title=@"";
    }
    else if(self.userTitle == REMUserTitleTechnician){
        
    }
    else if(self.userTitle == REMUserTitleCustomerAdmin){
        
    }
    else if(self.userTitle == REMUserTitlePlatformAdmin){
        
    }
    else if(self.userTitle == REMUserTitleEnergyManager){
        
    }
    else if(self.userTitle == REMUserTitleEnergyEngineer){
        
    }
    else if(self.userTitle == REMUserTitleDepartmentManager){
        
    }
    else if(self.userTitle == REMUserTitleCEO){
        
    }
    else if(self.userTitle == REMUserTitleBusinessPersonnel){
        
    }
    else if(self.userTitle == REMUserTitleSaleman){
        
    }
    else if(self.userTitle == REMUserTitleServiceProviderAdmin){
        
    }
    self.userTitleComponent=title;
}

@end
