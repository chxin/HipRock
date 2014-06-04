/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTimeRange.h
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMTimeHelper.h"
#import "REMEnum.h"




@interface REMTimeRange : REMJSONObject<NSCoding,NSCopying>

- (id)initWithArray:(NSArray *)array;

@property (nonatomic,strong) NSDate *startTime;

@property (nonatomic) long long longStartTime;
@property (nonatomic) long long longEndTime;

@property (nonatomic,strong) NSDate *endTime;

@property (nonatomic) REMRelativeTimeRangeType timeType;
@property (nonatomic) long long baseTime;
@property (nonatomic) long long offset;

- (id) initWithStartTime:(NSDate *)start EndTime:(NSDate *)end;

- (NSDictionary *)toJsonDictionary;

@end
