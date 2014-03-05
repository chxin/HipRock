//
//  REMManagedPinnedWidgetModel.h
//  Blues
//
//  Created by tantan on 2/25/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingCommodityUsageModel;

@interface REMManagedPinnedWidgetModel : NSManagedObject

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * widgetId;
@property (nonatomic, retain) NSNumber * dashboardId;
@property (nonatomic, retain) REMManagedBuildingCommodityUsageModel *commodity;
@end


