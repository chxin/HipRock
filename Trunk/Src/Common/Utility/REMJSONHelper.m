//
//  REMJSONHelper.m
//  Blues
//
//  Created by TanTan on 7/3/13.
//
//

#import "REMJSONHelper.h"

@implementation REMJSONHelper

+ (NSDictionary *)dictionaryByJSONString:(NSString *)jsonString
{
    if(jsonString == nil || [jsonString isEqualToString:@""])
    {
        return nil;
    }
        
    NSData *data= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* dic= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(dic == nil)
    {
        REMLogError(@"json parse error:%@,with json:%@",error.localizedFailureReason,jsonString);
    }
    
    return dic;
}


+ (NSString *)stringByDictionary:(NSDictionary *)dictionary
{
    if(dictionary == nil || [dictionary isEqual:[NSNull null]])
    {
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error || data==nil)
    {
        REMLogError(@"json serialize error: %@", error.localizedFailureReason);
    }
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

@end
