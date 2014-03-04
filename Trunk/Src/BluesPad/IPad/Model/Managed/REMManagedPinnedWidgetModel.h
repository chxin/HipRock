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
@property (nonatomic, retain) NSSet *commodities;
@end

@interface REMManagedPinnedWidgetModel (CoreDataGeneratedAccessors)

- (void)addCommoditiesObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)removeCommoditiesObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)addCommodities:(NSSet *)values;
- (void)removeCommodities:(NSSet *)values;

@end
