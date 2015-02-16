/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyError.h
 * Created      : 谭 坦 on 7/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMJSONObject.h"

@interface REMEnergyError : REMJSONObject

@property (nonatomic,strong) NSString *errorCode;

@property (nonatomic,strong) NSArray *params;

@end
