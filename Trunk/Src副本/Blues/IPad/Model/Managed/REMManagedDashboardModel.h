//
//  REMManagedDashboardModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingModel, REMManagedSharedModel, REMManagedWidgetModel;

@interface REMManagedDashboardModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) REMManagedBuildingModel *building;
@property (nonatomic, retain) REMManagedSharedModel *sharedInfo;
@property (nonatomic, retain) NSOrderedSet *widgets;
@end

@interface REMManagedDashboardModel (CoreDataGeneratedAccessors)

- (void)insertObject:(REMManagedWidgetModel *)value inWidgetsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWidgetsAtIndex:(NSUInteger)idx;
- (void)insertWidgets:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWidgetsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWidgetsAtIndex:(NSUInteger)idx withObject:(REMManagedWidgetModel *)value;
- (void)replaceWidgetsAtIndexes:(NSIndexSet *)indexes withWidgets:(NSArray *)values;
- (void)addWidgetsObject:(REMManagedWidgetModel *)value;
- (void)removeWidgetsObject:(REMManagedWidgetModel *)value;
- (void)addWidgets:(NSOrderedSet *)values;
- (void)removeWidgets:(NSOrderedSet *)values;
@end
