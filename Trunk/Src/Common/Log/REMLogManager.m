//
//  REMLogManager.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/3/13.
//
//

#import "REMLogManager.h"



@implementation REMLogManager



- (void)didRollAndArchiveLogFile:(NSString *)logFilePath
{

    
    NSData *reader = [NSData dataWithContentsOfFile:logFilePath];
    NSUInteger length=reader.length;
    
    REMLogInfo(@"length:%u",length);
    
    
    NSString *str= [[NSString alloc]initWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
    
    REMLogInfo(@"string:%@",str);
    
    //send to server
    
    

}

@end
