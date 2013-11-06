/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCommoditySearchModel.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetStepEnergyModel.h"

@interface REMWidgetCommoditySearchModel : REMWidgetStepEnergyModel

@property (nonatomic,strong) NSArray *commodityIdArray;

@property (nonatomic,strong) NSNumber *hierarchyId;
@property (nonatomic,strong) NSNumber *systemDimensionTemplateItemId;
@property (nonatomic,strong) NSNumber *areaDimensionId;

@end
