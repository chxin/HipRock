/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSeriesKeyFormattor.h
 * Date Created : 张 锋 on 5/29/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"
#import "REMDataStore.h"
#import "REMEnergyViewData.h"
#import "REMWidgetContentSyntax.h"
#import "DWrapperConfig.h"

@interface REMSeriesKeyFormattor : NSObject

+(NSString *)seriesKeyWithEnergyTarget:(REMEnergyTargetModel *)target energyData:(REMEnergyViewData *)energyData andWidgetContentSyntax:(REMWidgetContentSyntax *)syntax;

@end
