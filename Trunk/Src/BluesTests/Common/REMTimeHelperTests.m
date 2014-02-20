/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTimeHelperTests.m
 * Date Created : 张 锋 on 2/20/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <XCTest/XCTest.h>
#import "REMCommonHeaders.h"

@interface REMTimeHelperTests : XCTestCase

@end

@implementation REMTimeHelperTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


- (void)test_parse_json
{
    long long int1= [REMTimeHelper longLongFromJSONString:@"/Date(1356998400000)/"];
    NSLog(@"value:%llu",int1);
    NSAssert(1356998400000L==int1,@"ok");
}

- (void)test_timerange
{
    NSDictionary *dic=@{
                        @"StartTime":@"/Date(1356998400000)/",
                        @"EndTime":@"/Date(1356998400000)/"
                        };
    REMTimeRange *range = [[REMTimeRange alloc]initWithDictionary:dic];
    
    NSAssert(1356998400000L==range.longStartTime,@"ok");
    NSAssert(1356998400000L==range.longEndTime,@"ok");
    
    NSAssert(1356998400==range.startTime.timeIntervalSince1970,@"ok");
    NSAssert(1356998400==range.endTime.timeIntervalSince1970,@"ok");
    
    
}

- (void)test_relativedate
{
    //    REMTimeRange *range=    [REMTimeHelper relativeDateFromString:@"Today"];
    //
    //    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    //    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
    //    NSLog(@"time:%@",[f stringFromDate:range.startTime]);
    //    NSLog(@"time:%@",[f stringFromDate:range.endTime]);
    
}

-(void)test_monthticks
{
    int monthTicks = 2010*12+1;
    
    NSDate *date = [REMTimeHelper getDateFromMonthTicks:[NSNumber numberWithInt: monthTicks]];
    
    NSAssert([REMTimeHelper getYear:date] == 2010, @"go");
}

@end