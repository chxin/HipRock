//
//  REMTimeRange.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeHelper.h"
#import "REMEnum.h"




@interface REMTimeRange : REMJSONObject

- (id)initWithArray:(NSArray *)array;

@property (nonatomic,strong) NSDate *startTime;

@property (nonatomic) long long longStartTime;
@property (nonatomic) long long longEndTime;

@property (nonatomic,strong) NSDate *endTime;

- (id) initWithStartTime:(NSDate *)start EndTime:(NSDate *)end;

- (NSDictionary *)toJsonDictionary;

@end
