/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyLabellingLevelData.h
 * Date Created : tantan on 12/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetSearchModelBase.h"

@interface REMEnergyLabellingLevelData : REMJSONObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *maxValue;
@property (nonatomic,strong) NSNumber *minValue;
@property (nonatomic,strong) NSNumber *uomId;
@property (nonatomic,strong) NSString *uom;

@end
