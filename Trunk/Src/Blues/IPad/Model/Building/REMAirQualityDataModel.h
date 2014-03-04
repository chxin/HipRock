/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAirQualityDataModel.h
 * Created      : 张 锋 on 8/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"
#import "REMEnergyViewData.h"

@interface REMAirQualityDataModel : REMJSONObject

@property (nonatomic,strong) REMEnergyViewData *airQualityData;
@property (nonatomic,strong) NSArray *standards;

@end

@interface REMAirQualityStandardModel : REMJSONObject

@property (nonatomic,strong) NSString *standardName;
@property (nonatomic,strong) NSNumber *standardValue;
@property (nonatomic,strong) NSString *uom;

@end
