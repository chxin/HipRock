//
//  REMTimeRange.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeHelper.h"

@interface REMTimeRange : REMJSONObject

@property (nonatomic,strong) NSDate *startTime;

@property (nonatomic) long long longStartTime;
@property (nonatomic) long long longEndTime;

@property (nonatomic,strong) NSDate *endTime;

- (id) initWithStartTime:(NSDate *)start EndTime:(NSDate *)end;

- (NSDictionary *)toJsonDictionary;

@end
