/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetContentSyntax.h
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMTimeRange.h"
#import "REMEnum.h"
#import "REMCommonHeaders.h"

// 对应于能源管理下，保存widget时，默认的序列类型，
typedef enum _REMWidgetContentSyntaxWidgetType {
    REMWidgetContentSyntaxWidgetTypeNone = 0,   // Labeling时没有默认类型
    REMWidgetContentSyntaxWidgetTypeLine = 1,
    REMWidgetContentSyntaxWidgetTypeColumn = 2,
    REMWidgetContentSyntaxWidgetTypeStack = 3,
    REMWidgetContentSyntaxWidgetTypePie = 4,
    REMWidgetContentSyntaxWidgetTypeGrid = 5,
    REMWidgetContentSyntaxWidgetTypeOriginal = 6
}REMWidgetContentSyntaxWidgetType;

@interface REMWidgetContentSyntax : REMJSONObject

@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,strong) NSString *calendar;
//@property (nonatomic,strong) NSString *relativeDate;
@property (nonatomic,strong) NSString *relativeDateComponent;
@property (nonatomic) REMRelativeTimeRangeType relativeDateType;
@property (nonatomic) REMCalendarType  calendarType;
@property (nonatomic) REMEnergyStep stepType;
@property (nonatomic) REMDataStoreType dataStoreType;
@property (nonatomic,strong) NSString *storeType;
@property (nonatomic,strong) NSArray *timeRanges;
@property (nonatomic,strong) NSNumber *step;
@property (nonatomic, assign) NSComparisonResult rankingSortOrder;
@property (nonatomic) NSNumber* rankingMinPosition;
@property (nonatomic, assign) REMRankingRange rankingRangeCode;
@property (nonatomic,strong) NSArray *seriesStates;

@property (nonatomic,assign) REMWidgetContentSyntaxWidgetType contentSyntaxWidgetType;


-(BOOL)isHourSupported;

@end
