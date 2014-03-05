/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToCoverPersistenceProcessor.m
 * Date Created : tantan on 3/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPinToCoverPersistenceProcessor.h"

@implementation REMPinToCoverPersistenceProcessor

- (id)fetchData{
    return self.commodityInfo.pinnedWidgets;
}

- (id)persistData:(NSArray *)data{
    
    NSArray *oldData = [self fetchData];
    
    for (REMManagedPinnedWidgetModel *model  in oldData) {
        [self.dataStore deleteManageObject:model];
    }
    
    if (data!=nil) {
        for (int i=0; i<data.count; ++i) {
            NSDictionary *dictionary = data[i];
            REMManagedPinnedWidgetModel *pinnedModel = [self.dataStore newManagedObject:@"REMManagedPinnedWidgetModel"];
            
            pinnedModel.commodity = self.commodityInfo;
            pinnedModel.widgetId = dictionary[@"WidgetId"];
            pinnedModel.dashboardId = dictionary[@"DashboardId"];
            pinnedModel.position =dictionary[@"Position"];
            [self.commodityInfo addPinnedWidgetsObject:pinnedModel];
        }
        
        
    }
    [self.dataStore persistManageObject];
    return self.commodityInfo.pinnedWidgets;
}

@end
