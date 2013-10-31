//
//  REMWidgetContentSyntax.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeRange.h"
#import "REMEnum.h"


@interface REMWidgetContentSyntax : REMJSONObject

@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,strong) NSString *calendar;
@property (nonatomic,strong) NSString *relativeDate;
@property (nonatomic,strong) NSString *relativeDateComponent;
@property (nonatomic) REMRelativeTimeRangeType relativeDateType;
@property (nonatomic) REMCalendarType  calendarType;
@property (nonatomic) REMEnergyStep stepType;
@property (nonatomic) REMDataStoreType dataStoreType;
@property (nonatomic,strong) NSString *storeType;
@property (nonatomic,strong) NSString *xtype;
@property (nonatomic,strong) NSArray *timeRanges;
@property (nonatomic,strong) NSNumber *step;
@property (nonatomic, assign) NSComparisonResult rankingSortOrder;
@property (nonatomic) NSNumber* rankingMinPosition;
@property (nonatomic, assign) REMRankingRange rankingRangeCode;
@end
