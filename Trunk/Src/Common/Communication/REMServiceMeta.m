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

#if defined(DEBUG)
const static NSString *BUILDOPTION = @"Debug";
#elif defined(DailyBuild)
const static NSString *BUILDOPTION = @"DailyBuild";
#elif defined(InternalRelease)
const static NSString *BUILDOPTION = @"InternalRelease";
#else
const static NSString *BUILDOPTION = @"Release";
#endif


+ (NSString *)absoluteUrl:(NSString *)relativeUrl
{
    NSString *dataSourceName = REMAppConfig.currentDataSource[BUILDOPTION];
    NSDictionary *serviceInfo = REMAppConfig.dataSources[dataSourceName];
    NSString *serviceBaseUrl = [NSString stringWithFormat:@"%@://%@%@",serviceInfo[@"schema"],serviceInfo[@"host"],serviceInfo[@"path"]];
    
    //NSLog(@"BUILDOPTION:%@\nSVCBASE:%@", BUILDOPTION, serviceBaseUrl);
    
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
