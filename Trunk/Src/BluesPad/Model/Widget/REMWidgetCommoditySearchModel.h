//
//  REMWidgetCommoditySearchModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetStepEnergyModel.h"

@interface REMWidgetCommoditySearchModel : REMWidgetStepEnergyModel

@property (nonatomic,strong) NSArray *commodityIdArray;

@property (nonatomic,strong) NSNumber *hierarchyId;
@property (nonatomic,strong) NSNumber *systemDimensionTemplateItemId;
@property (nonatomic,strong) NSNumber *areaDimensionId;

@end
