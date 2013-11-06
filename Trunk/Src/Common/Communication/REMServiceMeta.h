/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMServiceMeta.h
 * Created      : 张 锋 on 8/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

typedef enum _REMServiceResponseType
{
    REMServiceResponseJson,
    REMServiceResponseImage,
} REMServiceResponseType;

@interface REMServiceMeta : NSObject

-(REMServiceMeta *)initWithRelativeUrl:(NSString *)relativeUrl andResponseType:(REMServiceResponseType)responseType;
-(REMServiceMeta *)initWithJsonResultRelativeUrl:(NSString *)relativeUrl;
-(REMServiceMeta *)initWithDataResultRelativeUrl:(NSString *)relativeUrl;

@property (nonatomic) REMServiceResponseType responseType;
@property (nonatomic,strong) NSString* url;

@end
