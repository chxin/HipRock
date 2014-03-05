//
//  REMManagedDashboardModel.h
//  Blues
//
//  Created by tantan on 2/25/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingModel, REMManagedSharedModel, REMManagedWidgetModel;

@interface REMManagedDashboardModel : NSManagedObject

@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) REMManagedBuildingModel *building;
@property (nonatomic, retain) NSSet *widgets;
@property (nonatomic, retain) REMManagedSharedModel *sharedInfo;
@end

@interface REMManagedDashboardModel (CoreDataGeneratedAccessors)

- (void)addWidgetsObject:(REMManagedWidgetModel *)value;
- (void)removeWidgetsObject:(REMManagedWidgetModel *)value;
- (void)addWidgets:(NSSet *)values;
- (void)removeWidgets:(NSSet *)values;

@end
