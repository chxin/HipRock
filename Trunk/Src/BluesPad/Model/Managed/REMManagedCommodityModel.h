//
//  REMManagedCommodityModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMBuildingEnergyUsageModel, REMManagedBuildingModel, REMManagedBuildingRankingModel, REMManagedPinnedWidgetModel;

@interface REMManagedCommodityModel : REMManagedModel

@property (nonatomic, retain) REMManagedBuildingModel *building;
@property (nonatomic, retain) NSSet *pinnedWidgets;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *commodityUsage;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *carbonUsage;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *targetValue;
@property (nonatomic, retain) REMManagedBuildingRankingModel *ranking;
@end

@interface REMManagedCommodityModel (CoreDataGeneratedAccessors)

- (void)addPinnedWidgetsObject:(REMManagedPinnedWidgetModel *)value;
- (void)removePinnedWidgetsObject:(REMManagedPinnedWidgetModel *)value;
- (void)addPinnedWidgets:(NSSet *)values;
- (void)removePinnedWidgets:(NSSet *)values;

@end
