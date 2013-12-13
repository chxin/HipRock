//
//  REMLogTests.m
//  Blues
//
//  Created by TanTan on 6/27/13.
//
//

#import "REMLogTests.h"
#import "REMLog.h"




@implementation REMLogTests

- (void)setUp
{
    [super setUp];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger= [[DDFileLogger alloc]init];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [DDLog addLogger:fileLogger];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)test_fail{
    //STFail(@"failed");
}

- (void)test_console_log
{
    REMLogError(@"REMLogConsole_Success");
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString * logPath = [docPath stringByAppendingPathComponent:@"Caches"];
    logPath = [logPath stringByAppendingPathComponent:@"Logs"];
    
    
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * fileList = [[NSArray alloc]init];
    fileList = [fileManger contentsOfDirectoryAtPath:logPath error:&error];
    NSMutableArray * listArray = [[NSMutableArray alloc]init];
    for (NSString * oneLogPath in fileList)
    {
        if([oneLogPath characterAtIndex:0 ] == 'l')
        {
            NSString * truePath = [logPath stringByAppendingPathComponent:oneLogPath];
            [listArray addObject:truePath];
            NSData *reader = [NSData dataWithContentsOfFile:truePath];
            int length=reader.length;
            //NSLog(@"length:%d",length);
            NSString *str= [[NSString alloc]initWithContentsOfFile:truePath encoding:NSUTF8StringEncoding error:nil];
            
            //NSLog(@"string:%@",str);
            
        }
    }
    
    
    
    //NSLog(@"%@",fileList);
}

@end
