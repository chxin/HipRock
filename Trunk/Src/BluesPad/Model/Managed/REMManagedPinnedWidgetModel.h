//
//  REMManagedPinnedWidgetModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedBuildingModel, REMManagedCommodityModel, REMManagedDashboardModel, REMManagedWidgetModel;

@interface REMManagedPinnedWidgetModel : REMManagedModel

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) REMManagedCommodityModel *commodity;
@property (nonatomic, retain) REMManagedBuildingModel *building;
@property (nonatomic, retain) REMManagedWidgetModel *widget;
@property (nonatomic, retain) REMManagedDashboardModel *dashboard;

@end
