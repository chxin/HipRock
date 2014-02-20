/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTextIndicatorFormator.h
 * Date Created : 张 锋 on 11/21/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMWidgetObject.h"
#import "REMWidgetTagSearchModel.h"
#import "REMEnergyViewData.h"

@interface REMTextIndicatorFormator : NSObject
+(NSString *)formatTargetName:(REMEnergyTargetModel *)target inEnergyData:(REMEnergyViewData *)data withWidget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters;
@end