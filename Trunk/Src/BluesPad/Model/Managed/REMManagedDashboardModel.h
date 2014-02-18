//
//  REMManagedDashboardModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMManagedBuildingModel, REMManagedWidgetModel;

@interface REMManagedDashboardModel : REMManagedModel

@property (nonatomic, retain) REMManagedBuildingModel *building;
@property (nonatomic, retain) NSSet *widgets;
@end

@interface REMManagedDashboardModel (CoreDataGeneratedAccessors)

- (void)addWidgetsObject:(REMManagedWidgetModel *)value;
- (void)removeWidgetsObject:(REMManagedWidgetModel *)value;
- (void)addWidgets:(NSSet *)values;
- (void)removeWidgets:(NSSet *)values;

@end
