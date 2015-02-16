/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLogManager.m
 * Created      : TanTan on 7/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
