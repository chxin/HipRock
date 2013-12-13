/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMJSONHelper.m
 * Created      : TanTan on 7/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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

+ (id)duplicateObject:(id)object
{
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: object];
    return [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
}

@end
