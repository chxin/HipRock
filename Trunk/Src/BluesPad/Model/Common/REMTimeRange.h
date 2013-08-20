//
//  REMTimeRange.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeHelper.h"


typedef enum _REMRelativeTimeRangeType : NSInteger
{
    Last7Days = 1,
    Today = 2,
    Yesterday = 3,
    ThisWeek = 4,
    LastWeek = 5,
    ThisMonth = 6,
    LastMonth = 7,
    ThisYear = 8,
    LastYear = 9,
} REMRelativeTimeRangeType;


@interface REMTimeRange : REMJSONObject

- (id)initWithArray:(NSArray *)array;

@property (nonatomic,strong) NSDate *startTime;

@property (nonatomic) long long longStartTime;
@property (nonatomic) long long longEndTime;

@property (nonatomic,strong) NSDate *endTime;

- (id) initWithStartTime:(NSDate *)start EndTime:(NSDate *)end;

- (NSDictionary *)toJsonDictionary;

@end
