//
//  REMApplicationInfo.m
//  Blues
//
//  Created by 徐 子龙 on 13-7-3.
//
//

#import "REMApplicationInfo.h"

@implementation REMApplicationInfo

static NSString *APPLICATION_VERSION;
//static NSString *APPLICATION_BUILD;

+(void) initApplicationInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //NSArray* versionArray = [[NSArray alloc] init];
    APPLICATION_VERSION = [self formatVersion:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
}
+(NSString*)formatVersion:(NSString*)versionString
{
    NSString* formated = @"";
    NSArray* version = [versionString componentsSeparatedByString:@"."];
        for (NSString *s in version) {
        NSString* format = nil;
        if ([s length] == 1)
        {
            format = @"00%@";
        }
        else if ([s length] == 2)
        {
            format = @"0%@";
        }
        else
        {
            format = @"%@";
        }
        formated = [NSString stringWithFormat:@"%@%@", formated, [NSString stringWithFormat:format, s]];
    }
    return formated;
}
+(const char*)getVersion
{
    const char* s = [APPLICATION_VERSION UTF8String];
    return s;
}
@end
