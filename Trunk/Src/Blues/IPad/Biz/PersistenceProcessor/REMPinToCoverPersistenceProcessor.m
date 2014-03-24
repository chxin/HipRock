/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToCoverPersistenceProcessor.m
 * Date Created : tantan on 3/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPinToCoverPersistenceProcessor.h"

@implementation REMPinToCoverPersistenceProcessor

#pragma mark - Data persistence processor

- (id)persist:(NSArray *)data{
    
    NSArray *oldData = [self fetch];
    
    for (REMManagedPinnedWidgetModel *model  in oldData) {
        [self delete:model];
    }
    
    if (data!=nil) {
        for (int i=0; i<data.count; ++i) {
            NSDictionary *dictionary = data[i];
            REMManagedPinnedWidgetModel *pinnedModel = [self new:[REMManagedPinnedWidgetModel class]];
            NSNumber *commodityId = dictionary[@"CommodityId"];
            for (REMManagedBuildingCommodityUsageModel *commodityInfo in [self.buildingInfo.commodities allObjects]) {
                if ([commodityInfo.id isEqualToNumber:commodityId] == YES) {
                    pinnedModel.commodity = commodityInfo;
                    pinnedModel.widgetId = dictionary[@"WidgetId"];
                    pinnedModel.dashboardId = dictionary[@"DashboardId"];
                    pinnedModel.position =dictionary[@"Position"];
                    [commodityInfo addPinnedWidgetsObject:pinnedModel];
                }
            }
        }
    }
    [self save];
    return [self fetch];
}

- (id)fetch{
    NSMutableArray *array = [NSMutableArray array];
    for (REMManagedBuildingCommodityUsageModel *commodityInfo in [self.buildingInfo.commodities allObjects]) {
        [array arrayByAddingObjectsFromArray:[commodityInfo.pinnedWidgets allObjects]];
    }
    
    
    return array;
}


@end
