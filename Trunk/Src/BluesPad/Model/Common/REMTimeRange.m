//
//  REMTimeRange.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/11/13.
//
//

#import "REMTimeRange.h"

@implementation REMTimeRange

- (NSDictionary *)toJsonDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:[NSString stringWithFormat:@"/Date(%llu)/",self.longStartTime] forKey:@"StartTime"];
    [dic setObject:[NSString stringWithFormat:@"/Date(%llu)/",self.longEndTime] forKey:@"EndTime"];
    
    return dic;
}

- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self){
        NSNumber *startTime=array[0];
        NSNumber *endTime=array[1];
        self.longStartTime=[startTime longLongValue];
        self.longEndTime=[endTime longLongValue];
        
        self.startTime = [[NSDate alloc]initWithTimeIntervalSince1970:self.longStartTime];
        self.endTime=[[NSDate alloc]initWithTimeIntervalSince1970:self.longEndTime];
    }
    
    return self;
}

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSString *startTime=dictionary[@"StartTime"];
    NSString *endTime=dictionary[@"EndTime"];
    self.longStartTime=[REMTimeHelper longLongFromJSONString:startTime];
    self.longEndTime=[REMTimeHelper longLongFromJSONString:endTime];
    
    self.startTime = [[NSDate alloc]initWithTimeIntervalSince1970:self.longStartTime/1000];
    self.endTime=[[NSDate alloc]initWithTimeIntervalSince1970:self.longEndTime/1000];
}

- (id)initWithStartTime:(NSDate *)start EndTime:(NSDate *)end
{
    if((self = [super init])){
        self.startTime=start;
        self.endTime=end;
        self.longStartTime= [start timeIntervalSince1970]*1000;
        self.longEndTime = [end timeIntervalSince1970]*1000;
    
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.startTime forKey:@"StartTime"];
    [aCoder encodeObject:self.endTime forKey:@"EndTime"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSDate *start=[aDecoder decodeObjectForKey:@"StartTime"];
    NSDate *end=[aDecoder decodeObjectForKey:@"EndTime"];
    return [self initWithStartTime:start EndTime:end];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"{%f,%f}", [self.startTime timeIntervalSince1970], [self.endTime timeIntervalSince1970] ];
}

@end
