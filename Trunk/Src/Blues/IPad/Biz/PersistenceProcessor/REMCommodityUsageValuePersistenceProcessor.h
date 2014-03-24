/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCommodityUsageValuePersistenceProcessor.h
 * Date Created : tantan on 3/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMDataPersistenceProcessor.h"
#import "REMManagedBuildingCommodityUsageModel.h"
@interface REMCommodityUsageValuePersistenceProcessor : REMDataPersistenceProcessor

@property (nonatomic,weak) REMManagedBuildingCommodityUsageModel *commodityInfo;

@end
