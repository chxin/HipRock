//
//  REMAdministratorModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/30/13.
//
//

#import "REMJSONObject.h"

@interface REMAdministratorModel : REMJSONObject

@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSString *realName;

@end
