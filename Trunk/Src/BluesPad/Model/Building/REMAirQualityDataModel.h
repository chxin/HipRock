//
//  REMAirQualityDataModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/23/13.
//
//

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
