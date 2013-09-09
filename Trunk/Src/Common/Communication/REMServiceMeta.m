//
//  REMServiceMeta.m
//  Blues
//
//  Created by 张 锋 on 8/13/13.
//
//

#import "REMServiceMeta.h"

@implementation REMServiceMeta

//const static NSString *SVC_BASE_HOST = @"223.4.20.20";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/v1.3.0.8/MobileApiHost/";
//const static NSString *SVC_BASE_HOST = @"10.177.206.79";
//const static NSString *SVC_BASE_SCHEMA = @"http";
//const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";
//const static NSString *SVC_BASE_SUFFIX = @"/v1.3/MobileApiHost/";
#ifdef DEBUG
const static NSString *SVC_BASE_HOST = @"10.177.206.79";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";
#elif InternalRelease
const static NSString *SVC_BASE_HOST = @"223.4.20.20";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/v1.3/MobileApiHost/";
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
