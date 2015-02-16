/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTimeHelperTests.m
 * Date Created : 张 锋 on 2/20/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <XCTest/XCTest.h>
#import "REMCommonHeaders.h"
#import "REMEnergyMultiTimeSearcher.h"

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
//    NSDictionary *dic=@{
//                        @"StartTime":@"/Date(1356998400000)/",
//                        @"EndTime":@"/Date(1356998400000)/"
//                        };
//    REMTimeRange *range = [[REMTimeRange alloc]initWithDictionary:dic];
//    
//    NSAssert(1356998400000L==range.longStartTime,@"ok");
//    NSAssert(1356998400000L==range.longEndTime,@"ok");
//    
//    NSAssert(1356998400==range.startTime.timeIntervalSince1970,@"ok");
//    NSAssert(1356998400==range.endTime.timeIntervalSince1970,@"ok");
    
    
}

- (void)test_relativedate
{
    //REMTimeRange *last30days = [REMTimeHelper relativeDateFromType:REMRelativeTimeRangeTypeLast30Day];
    
    
    
    REMTimeRange *last12months = [REMTimeHelper relativeDateFromType:REMRelativeTimeRangeTypeLast12Month];
    
    NSAssert((([REMTimeHelper getMonth:last12months.endTime] + [REMTimeHelper getYear:last12months.endTime]*12) -
              ([REMTimeHelper getMonth:last12months.startTime] + [REMTimeHelper getYear:last12months.startTime]*12)) == 12 , @"last12months is wrong");
}

-(void)test_monthticks
{
    int monthTicks = 2010*12+1;
    
    NSDate *date = [REMTimeHelper getDateFromMonthTicks:[NSNumber numberWithInt: monthTicks]];
    
    int year =  [REMTimeHelper getYear:date];
    
//    NSAssert(year == 2010, @"go");
}

-(void)test_REMEnergyMultiTimeSearcher
{
    REMEnergyMultiTimeSearcher *searcher = [[REMEnergyMultiTimeSearcher alloc] init];
    
    NSDate *date1 = [REMTimeHelper dateFromYear:2014 Month:8 Day:10];
    NSDate *date2 = [REMTimeHelper dateFromYear:2014 Month:8 Day:11];
    NSDate *date3 = [REMTimeHelper dateFromYear:2014 Month:8 Day:12];
    NSDate *date4 = [REMTimeHelper dateFromYear:2014 Month:8 Day:13];
    NSDate *date5 = [REMTimeHelper dateFromYear:2014 Month:8 Day:14];
    NSDate *date6 = [REMTimeHelper dateFromYear:2014 Month:8 Day:15];
    NSDate *date7 = [REMTimeHelper dateFromYear:2014 Month:8 Day:16];
    NSDate *date8 = [REMTimeHelper dateFromYear:2014 Month:8 Day:17];


    
    NSDate *result1 = [searcher firstValidDateFromDate:date1 forStep:REMEnergyStepWeek];
    NSDate *result2 = [searcher firstValidDateFromDate:date2 forStep:REMEnergyStepWeek];
        NSDate *result3 = [searcher firstValidDateFromDate:date3 forStep:REMEnergyStepWeek];
        NSDate *result4 = [searcher firstValidDateFromDate:date4 forStep:REMEnergyStepWeek];
        NSDate *result5 = [searcher firstValidDateFromDate:date5 forStep:REMEnergyStepWeek];
        NSDate *result6 = [searcher firstValidDateFromDate:date6 forStep:REMEnergyStepWeek];
        NSDate *result7 = [searcher firstValidDateFromDate:date7 forStep:REMEnergyStepWeek];
        NSDate *result8 = [searcher firstValidDateFromDate:date8 forStep:REMEnergyStepWeek];
    
}

@end
