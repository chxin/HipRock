//
//  REMServiceMeta.m
//  Blues
//
//  Created by 张 锋 on 8/13/13.
//
//

#import "REMServiceMeta.h"

@implementation REMServiceMeta

const static NSString *SVC_BASE_HOST = @"10.177.206.79";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";

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

@end
