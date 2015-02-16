//
//  REMManagedBuildingCommodityUsageModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingModel, REMManagedPinnedWidgetModel;

@interface REMManagedBuildingCommodityUsageModel : NSManagedObject

@property (nonatomic, retain) NSString * carbonUom;
@property (nonatomic, retain) NSNumber * carbonValue;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isTargetAchieved;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rankingDenominator;
@property (nonatomic, retain) NSNumber * rankingNumerator;
@property (nonatomic, retain) NSString * targetUom;
@property (nonatomic, retain) NSNumber * targetValue;
@property (nonatomic, retain) NSString * totalUom;
@property (nonatomic, retain) NSNumber * totalValue;
@property (nonatomic, retain) NSNumber * annualUsage;
@property (nonatomic, retain) NSString * annualUsageUom;
@property (nonatomic, retain) NSNumber * annualBaseline;
@property (nonatomic, retain) NSString * annualBaselineUom;
@property (nonatomic, retain) NSNumber * annualEfficiency;
@property (nonatomic, retain) REMManagedBuildingModel *building;
@property (nonatomic, retain) NSOrderedSet *pinnedWidgets;
@end

@interface REMManagedBuildingCommodityUsageModel (CoreDataGeneratedAccessors)

- (void)insertObject:(REMManagedPinnedWidgetModel *)value inPinnedWidgetsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPinnedWidgetsAtIndex:(NSUInteger)idx;
- (void)insertPinnedWidgets:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePinnedWidgetsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPinnedWidgetsAtIndex:(NSUInteger)idx withObject:(REMManagedPinnedWidgetModel *)value;
- (void)replacePinnedWidgetsAtIndexes:(NSIndexSet *)indexes withPinnedWidgets:(NSArray *)values;
- (void)addPinnedWidgetsObject:(REMManagedPinnedWidgetModel *)value;
- (void)removePinnedWidgetsObject:(REMManagedPinnedWidgetModel *)value;
- (void)addPinnedWidgets:(NSOrderedSet *)values;
- (void)removePinnedWidgets:(NSOrderedSet *)values;
@end
