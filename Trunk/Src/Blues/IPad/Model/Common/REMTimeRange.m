/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTimeRange.m
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMTimeRange.h"
#import "REMCommonHeaders.h"

@interface REMTimeRange()

@property (nonatomic) long long longStartTime;
@property (nonatomic) long long longEndTime;

@end

@implementation REMTimeRange

#pragma mark - Properties


#pragma mark - Methods

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

- (id)initWithDictionary:(NSDictionary *)dictionary andBaseTime:(REMTimeRange *)baseTime
{
    self.relativeTimeType = REMRelativeTimeRangeTypeNone;// REMIsNilOrNull(dictionary[@"relativeDate"]) ? REMRelativeTimeRangeTypeNone : [REMTimeHelper relativeTimeTypeByName: dictionary[@"relativeDate"]];
    
    if(!REMIsNilOrNull(dictionary[@"StartTime"]) && !REMIsNilOrNull(dictionary[@"EndTime"])){
        self.longStartTime=[REMTimeHelper longLongFromJSONString:dictionary[@"StartTime"]];
        self.longEndTime=[REMTimeHelper longLongFromJSONString:dictionary[@"EndTime"]];
        
        self.startTime = [[NSDate alloc]initWithTimeIntervalSince1970:self.longStartTime/1000];
        self.endTime=[[NSDate alloc]initWithTimeIntervalSince1970:self.longEndTime/1000];
    }
    if(!REMIsNilOrNull(dictionary[@"timeType"]) && !REMIsNilOrNull(dictionary[@"offset"]) && baseTime != nil){
        self.timeType = (NSNumber *)dictionary[@"timeType"];
        self.offset = (NSNumber *)dictionary[@"offset"];
        
        if([self.timeType intValue] == 0){
            self.startTime = [[NSDate alloc]initWithTimeIntervalSince1970:[baseTime.startTime timeIntervalSince1970] - [self.offset longLongValue]];
            self.endTime=[[NSDate alloc]initWithTimeIntervalSince1970:[baseTime.endTime timeIntervalSince1970] - [self.offset longLongValue]];
        }
        if([self.timeType intValue] == 1){
            self.startTime = [REMTimeHelper addMonthToDate:baseTime.startTime month:0-[self.offset longLongValue]];
            self.endTime = [REMTimeHelper addMonthToDate:baseTime.endTime month:0-[self.offset longLongValue]];
        }
    }
    if(!REMIsNilOrNull(dictionary[@"relativeDate"])){
        self.relativeTimeType = [REMTimeHelper relativeTimeTypeByName: dictionary[@"relativeDate"]];
        
        self = [REMTimeHelper relativeDateFromType:self.relativeTimeType];
    }
    
    return self;
}

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.relativeTimeType = REMIsNilOrNull(dictionary[@"relativeDate"]) ? REMRelativeTimeRangeTypeNone : [REMTimeHelper relativeTimeTypeByName: dictionary[@"relativeDate"]];
    
    if(self.relativeTimeType == REMRelativeTimeRangeTypeNone){
        NSString *startTime=dictionary[@"StartTime"];
        NSString *endTime=dictionary[@"EndTime"];
        self.longStartTime=[REMTimeHelper longLongFromJSONString:startTime];
        self.longEndTime=[REMTimeHelper longLongFromJSONString:endTime];
        
        self.startTime = [[NSDate alloc]initWithTimeIntervalSince1970:self.longStartTime/1000];
        self.endTime=[[NSDate alloc]initWithTimeIntervalSince1970:self.longEndTime/1000];
    }
    else{
        REMTimeRange *temp = [REMTimeHelper relativeDateFromType:self.relativeTimeType];
        self.startTime = temp.startTime;
        self.endTime=temp.endTime;
    }
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

- (id)copyWithZone:(NSZone *)zone{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"{%f,%f}", [self.startTime timeIntervalSince1970], [self.endTime timeIntervalSince1970] ];
}

@end
