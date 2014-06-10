//
//  REMManagedBuildingCommodityUsageModel.h
//  Blues
//
//  Created by 张 锋 on 6/10/14.
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
@property (nonatomic, retain) NSSet *pinnedWidgets;
@end

@interface REMManagedBuildingCommodityUsageModel (CoreDataGeneratedAccessors)

- (void)addPinnedWidgetsObject:(REMManagedPinnedWidgetModel *)value;
- (void)removePinnedWidgetsObject:(REMManagedPinnedWidgetModel *)value;
- (void)addPinnedWidgets:(NSSet *)values;
- (void)removePinnedWidgets:(NSSet *)values;

@end
