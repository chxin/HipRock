//
//  REMAirQualityModel.h
//  Blues
//
//  Created by tantan on 8/22/13.
//
//

#import "REMJSONObject.h"
#import "REMCommodityModel.h"
#import "REMEnergyUsageDataModel.h"

@interface REMAirQualityModel : REMJSONObject

@property (nonatomic,strong) REMCommodityModel *commodity;
@property (nonatomic,strong) REMEnergyUsageDataModel *outdoor;
@property (nonatomic,strong) REMEnergyUsageDataModel *honeywell;
@property (nonatomic,strong) REMEnergyUsageDataModel *mayair;


@end
