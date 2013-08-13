//
//  REMJSONHelper.m
//  Blues
//
//  Created by TanTan on 7/3/13.
//
//

#import "REMJSONHelper.h"

@implementation REMJSONHelper

+ (id)objectByString:(NSString *)json
{
    if(json == nil || [json isEqualToString:@""])
    {
        return nil;
    }
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    return [REMJSONHelper objectWithData:data];
}


+ (NSString *)stringByObject:(id)object
{
    if(object == nil || [object isEqual:[NSNull null]])
    {
        return nil;
    }
    
    NSData *data = [REMJSONHelper dataWithObject:object];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSData *)dataWithObject:(id)object
{
    if(object == nil)
        return nil;
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    
    if(error || data==nil)
    {
        REMLogError(@"json serialize error: %@", error.localizedFailureReason);
    }
    
    return data;
}

+(id)objectWithData:(NSData *)data
{
    if(data == nil)
        return nil;
    
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(error)
    {
        REMLogError(@"json parse error:%@,with data:%@",error.localizedFailureReason,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    
    return object;
}

@end
