/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLog.m
 * Created      : TanTan on 6/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMLog.h"


void uncaughtExceptionHandler(NSException *exception)
{
    
    NSArray *arr = [exception callStackSymbols];
    
    NSString *reason = [exception reason];
    
    NSString *name = [exception name];
    
    
    
    NSString *content = [NSString stringWithFormat:
                         @"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                         
                         name,reason,[arr componentsJoinedByString:@"\n"]];
    
    [REMLog logErrorContent:content];
    
    
}


@implementation REMLog

+ (void)logErrorContent:(NSString *)content
{
    REMLogError(@"%@",content);
}

+ (void)bind
{
    //Add log config
#ifdef DEBUG
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
#else
    REMLogManager *manager = [[REMLogManager alloc]init];
    DDFileLogger *fileLogger=[[DDFileLogger alloc]initWithLogFileManager:manager];
    [fileLogger setRollingFrequency:60 * 60 * 24];   // roll every day
    [fileLogger setMaximumFileSize:1024 * 1024 * 2]; // max 2mb file size
    [fileLogger.logFileManager setMaximumNumberOfLogFiles:7];
    [DDLog addLogger:fileLogger];
#endif
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
}

@end
