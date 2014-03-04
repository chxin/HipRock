/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMUomModel.h
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"

@interface REMUomModel : REMJSONObject

@property (nonatomic,strong) NSNumber *uomId;
@property (nonatomic,strong) NSString *name,*code,*comment;


@end