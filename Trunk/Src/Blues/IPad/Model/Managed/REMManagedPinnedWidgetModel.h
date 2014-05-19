//
//  REMManagedPinnedWidgetModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingCommodityUsageModel;

@interface REMManagedPinnedWidgetModel : NSManagedObject

@property (nonatomic, retain) NSNumber * dashboardId;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * widgetId;
@property (nonatomic, retain) REMManagedBuildingCommodityUsageModel *commodity;

@end
