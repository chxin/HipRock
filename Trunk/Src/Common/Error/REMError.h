/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMError.h
 * Created      : 张 锋 on 9/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMBusinessErrorInfo.h"

@interface REMError : NSError

-(REMError *)initWithErrorInfo:(REMBusinessErrorInfo *)errorInfo;

@property (nonatomic,strong) REMBusinessErrorInfo *errorInfo;

@end
