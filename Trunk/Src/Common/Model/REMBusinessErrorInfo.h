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

@property (nonatomic,readonly) int errorType;
@property (nonatomic,readonly) int serverId;
@property (nonatomic,readonly) int layer;
@property (nonatomic,readonly) int module;
@property (nonatomic,readonly) int detailCode;

-(BOOL)matchesErrorCode:(NSString *)errorCode;

@end
