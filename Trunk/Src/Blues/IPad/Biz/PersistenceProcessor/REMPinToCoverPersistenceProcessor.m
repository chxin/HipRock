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
        [self remove:model];
    }
    
    if (data!=nil) {
        for (int i=0; i<data.count; ++i) {
            NSDictionary *dictionary = data[i];
            REMManagedPinnedWidgetModel *pinnedModel = [self create:[REMManagedPinnedWidgetModel class]];
            NSNumber *commodityId = dictionary[@"CommodityId"];
            for (REMManagedBuildingCommodityUsageModel *commodityInfo in self.buildingInfo.commodities) {
                if ([commodityInfo.id isEqualToNumber:commodityId] == YES) {
                    pinnedModel.commodity = commodityInfo;
                    pinnedModel.widgetId = dictionary[@"WidgetId"];
                    pinnedModel.dashboardId = dictionary[@"DashboardId"];
                    pinnedModel.position =dictionary[@"Position"];
//                    [commodityInfo addPinnedWidgetsObject:pinnedModel];
                    [pinnedModel setCommodity:commodityInfo];
                }
            }
        }
    }
    [self save];
    return [self fetch];
}

- (id)fetch{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *commodityArray = [[NSArray alloc] init];
//    commodityArray = [self.buildingInfo.commodities.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [((REMManagedBuildingCommodityUsageModel *)obj1).id compare:( (REMManagedBuildingCommodityUsageModel *)obj2).id];
//    }];
    commodityArray = [NSArray arrayWithArray:self.buildingInfo.commodities.array];
    
    for (REMManagedBuildingCommodityUsageModel *commodityInfo in commodityArray) {
        //array = [NSMutableArray arrayWithArray:[array arrayByAddingObjectsFromArray:[commodityInfo.pinnedWidgets allObjects]]];
        array =[NSMutableArray arrayWithArray:[array arrayByAddingObjectsFromArray:commodityInfo.pinnedWidgets.array]];
    }
    
    
    return array;
}


@end
