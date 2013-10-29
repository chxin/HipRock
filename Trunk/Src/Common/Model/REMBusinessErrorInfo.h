//
//  REMBusinessError.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/5/13.
//
//

#import "REMJSONObject.h"

@interface REMBusinessErrorInfo : REMJSONObject

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSArray *messages;

@end
