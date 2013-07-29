//
//  REMLogManager.m
//  Blues
//
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
