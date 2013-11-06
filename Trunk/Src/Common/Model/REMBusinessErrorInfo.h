/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBusinessError.h
 * Created      : 张 锋 on 9/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"

@interface REMBusinessErrorInfo : REMJSONObject

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSArray *messages;

@end
