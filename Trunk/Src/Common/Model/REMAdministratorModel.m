//
//  REMAdministratorModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/30/13.
//
//

#import "REMAdministratorModel.h"

@implementation REMAdministratorModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.userId=dictionary[@"UserId"];
    self.realName=dictionary[@"RealName"];
}

- (NSDictionary *)updateInnerDictionary{
    NSMutableDictionary *dic= [[NSMutableDictionary alloc]initWithCapacity:2];
    
    dic[@"UserId"]=self.userId;
    dic[@"RealName"]=self.realName;
    
    self.innerDictionary=dic;
    
    return self.innerDictionary;
}

@end
