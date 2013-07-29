//
//  REMTimeHelperTests.m
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMTimeHelperTests.h"

@implementation REMTimeHelperTests

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
    REMTimeRange *range=    [REMTimeHelper relativeDateFromString:@"Today"];
    
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLog(@"time:%@",[f stringFromDate:range.startTime]);
    NSLog(@"time:%@",[f stringFromDate:range.endTime]);
    
}


@end
