//
//  REMStorage.m
//  Blues
//
//  Created by 徐 子龙 on 13-7-4.
//
//

#import "REMStorage.h"
#import "REMSqliteStorage.h"

@implementation REMStorage
+(void)initialize
{    
    REMSqliteStorage* db = [REMSqliteStorage getInstance];
    if ([db checkSourceName:STORAGE_NETWORK_SOURCE_NAME] == NO)
    {
        [db createSource:STORAGE_NETWORK_SOURCE_NAME];
    }
    if ([db checkSourceName:STORAGE_FILE_SOURCE_NAME] == NO)
    {
        [db createFileSource];
    }
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"preface-s0" ofType:@"png"];
//    [self setFile:@"TEST" key:@"TEST_KEY" version:900 image:[NSData dataWithContentsOfFile:filePath]];
//    
//    NSDictionary* dic = [self getFile:@"TEST" key:@"TEST_KEY"];
//    NSData* imageData = [dic objectForKey:STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA];
//    NSNumber* imageVersion = [dic objectForKey:STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION];
}

+(void)set:(NSString*)sourceName key:(NSString*)key value:(NSString*)value expired:(StorageExpirationType)expired
{
    REMSqliteStorage* db = [REMSqliteStorage getInstance];
    [db set:sourceName key:key value:value expired:expired];
}

+(void)clearSessionStorage
{
    [[REMSqliteStorage getInstance] clearSessionStorage];
}



+(NSString*)get:(NSString*)sourceName key:(NSString*)key
{
    NSDictionary* dic = [[REMSqliteStorage getInstance] get:sourceName key:key minVersion:[self getMinVersionOfSource:sourceName]];
    if (dic == nil)
    {
        return nil;
    }
    else
    {
        return [dic objectForKey:STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA];
    }
}
+(NSData *)getFile:(NSString*)sourceName key:(NSString*)key
{
    NSDictionary* dic = [[REMSqliteStorage getInstance] getFile:sourceName key:key];
    return dic[STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA];
}
+(void)setFile:(NSString*)sourceName key:(NSString*)key version:(long)version image:(NSData*)image
{
   [[REMSqliteStorage getInstance] setFile:sourceName params:key version:version imageData:image];
   
}


/*
+(int)getExpiredTime:(StorageExpirationType)expired
{
    NSTimeInterval unixTime = [[NSDate date] timeIntervalSince1970];
    int aMinute = 60;
    if (expired == REMNeverExpired)
    {
        unixTime = NSIntegerMax;
    }
    else if (expired == minutes)
    {
        unixTime += 10 * aMinute;
    }
    else if (expired == hour)
    {
        unixTime += 60 * aMinute;
    }
    else if (expired == day)
    {
        unixTime += 24 * 60 * aMinute;
    }
    else if (expired == week)
    {
        unixTime += 7 * 24 * 60 * aMinute;        
    }
    return unixTime;
}*/

+(NSString*)getMinVersionOfSource:(NSString*)sourceName
{
    return @"0.0.0.0";
}
@end
