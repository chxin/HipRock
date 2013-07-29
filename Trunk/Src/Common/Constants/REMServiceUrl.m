//
//  REMServiceUrl.m
//  Blues
//
//  Created by zhangfeng on 7/1/13.
//
//

#import "REMServiceUrl.h"


@interface REMServiceUrl()

@end

@implementation REMServiceUrl

const static NSString *SVC_BASE_HOST = @"10.177.206.79";
const static NSString *SVC_BASE_SCHEMA = @"http";
const static NSString *SVC_BASE_SUFFIX = @"/Mobile/";

+ (NSString *)absoluteUrl: (NSString *)relativeUrl
{
    NSString *absoluteUrl = [NSString stringWithFormat:@"%@://%@%@%@",SVC_BASE_SCHEMA,SVC_BASE_HOST,SVC_BASE_SUFFIX,relativeUrl];
    
    return absoluteUrl;
}

@end
