//
//  REMLog.m
//  Blues
//
//  Created by TanTan on 6/27/13.
//
//

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
    [DDLog addLogger:fileLogger];
#endif
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
}

@end
