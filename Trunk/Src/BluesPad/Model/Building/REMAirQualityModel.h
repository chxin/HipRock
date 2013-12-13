/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAirQualityModel.h
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMCommodityModel.h"
#import "REMEnergyUsageDataModel.h"

@interface REMAirQualityModel : REMJSONObject

@property (nonatomic,strong) REMCommodityModel *commodity;
@property (nonatomic,strong) REMEnergyUsageDataModel *outdoor;
@property (nonatomic,strong) REMEnergyUsageDataModel *honeywell;
@property (nonatomic,strong) REMEnergyUsageDataModel *mayair;


@end
