//
//  REMError.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/5/13.
//
//

#import <Foundation/Foundation.h>
#import "REMBusinessErrorInfo.h"

@interface REMError : NSError

-(REMError *)initWithErrorInfo:(REMBusinessErrorInfo *)errorInfo;

@property (nonatomic,strong) REMBusinessErrorInfo *errorInfo;

@end
