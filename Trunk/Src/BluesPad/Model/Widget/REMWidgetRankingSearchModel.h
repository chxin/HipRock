/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetRankingSearchModel.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetSearchModelBase.h"

@interface REMWidgetRankingSearchModel : REMWidgetSearchModelBase

@property (nonatomic,strong) NSArray *hierarchyIdArray;
@property (nonatomic,strong) NSNumber *systemDimensionTemplateItemId;
@property (nonatomic,strong) NSNumber *areaDimensionId;
@property (nonatomic,strong) NSArray *commodityIdArray;


@property (nonatomic,strong) NSNumber *zoneId;
@property (nonatomic,strong) NSNumber *industryId;

@property (nonatomic,strong) NSNumber *rankType;

@property (nonatomic,strong) NSNumber *destination;
@property (nonatomic,strong) NSString *relativeDateComponent;
@property (nonatomic) REMRelativeTimeRangeType relativeDateType;
@end
