//
//  REMAdministratorModel.m
//  Blues
//
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
