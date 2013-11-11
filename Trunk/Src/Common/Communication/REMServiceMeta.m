/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMServiceMeta.m
 * Created      : 张 锋 on 8/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMServiceMeta.h"

@implementation REMServiceMeta

//v0.4dev branch checkin

#ifdef DEBUG
const static NSString *SVC_BASE_HOST = @"10.177.206.79";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";

//const static NSString *SVC_BASE_HOST = @"10.177.122.189";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";
//
//const static NSString *SVC_BASE_HOST = @"10.177.0.35";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";

//const static NSString *SVC_BASE_HOST = @"112.124.56.137";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/v1.3.1.1/MobileApiHost/";

//const static NSString *SVC_BASE_HOST = @"admin.energy-here.com";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/MobileApiHost/";
#endif

#ifdef DailyBuild
const static NSString *SVC_BASE_HOST = @"112.124.56.137";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/v1.3.1.1/MobileApiHost/";

//const static NSString *SVC_BASE_HOST = @"10.177.0.35";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";
#endif

#ifdef InternalRelease
//const static NSString *SVC_BASE_HOST = @"admin.energy-here.com";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/MobileApiHost/";
const static NSString *SVC_BASE_HOST = @"112.124.56.137";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/v1.3.1.1/MobileApiHost/";
#endif


+ (NSString *)absoluteUrl:(NSString *)relativeUrl
{
    NSString *absoluteUrl = [NSString stringWithFormat:@"%@://%@%@%@",SVC_BASE_SCHEMA,SVC_BASE_HOST,SVC_BASE_SUFFIX,relativeUrl];
    
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
