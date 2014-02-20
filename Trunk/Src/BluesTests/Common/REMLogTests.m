/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLogTests.m
 * Date Created : 张 锋 on 2/20/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <XCTest/XCTest.h>
#import "REMCommonHeaders.h"

@interface REMLogTests : XCTestCase

@end

@implementation REMLogTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger *fileLogger= [[DDFileLogger alloc]init];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [DDLog addLogger:fileLogger];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
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
