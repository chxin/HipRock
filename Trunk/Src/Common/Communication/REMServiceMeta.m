/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMServiceMeta.m
 * Created      : 张 锋 on 8/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMServiceMeta.h"
#import "REMApplicationContext.h"

@implementation REMServiceMeta

//Change CurrentDataSource value in configuration.plist in Resource folder
//to change service url for different build options



+ (NSString *)absoluteUrl:(NSString *)relativeUrl
{
    NSString *serviceBaseUrl = REMAppConfig.currentDataSource[@"url"];
    
    NSLog(@"SVCBASE:%@", serviceBaseUrl);
    
    NSString *absoluteUrl = [serviceBaseUrl stringByAppendingString:relativeUrl];;
    
    return absoluteUrl;
}

-(REMServiceMeta *)initWithRelativeUrl:(NSString *)relativeUrl andResponseType:(REMServiceResponseType)responseType
{
    self = [super init];
    if(self){
        self.url = [REMServiceMeta absoluteUrl:relativeUrl];
        self.responseType = responseType;
    }
    return self;
}

-(REMServiceMeta *)initWithJsonResultRelativeUrl:(NSString *)relativeUrl
{
    self = [super init];
    if(self){
        self.url = [REMServiceMeta absoluteUrl:relativeUrl];
        self.responseType = REMServiceResponseJson;
    }
    return self;
}

-(REMServiceMeta *)initWithDataResultRelativeUrl:(NSString *)relativeUrl
{
    self = [super init];
    if(self){
        self.url = [REMServiceMeta absoluteUrl:relativeUrl];
        self.responseType = REMServiceResponseImage;
    }
    return self;
}

@end
