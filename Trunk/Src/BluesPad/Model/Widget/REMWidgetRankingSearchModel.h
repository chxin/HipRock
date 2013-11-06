//
//  REMWidgetRankingSearchModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

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
