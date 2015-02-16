//
//  REMManagedBuildingModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingAirQualityModel, REMManagedBuildingCommodityUsageModel, REMManagedBuildingPictureModel, REMManagedDashboardModel;

@interface REMManagedBuildingModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * hasDataPrivilege;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * isQualified;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * parentId;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * pathLevel;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSNumber * test;
@property (nonatomic, retain) NSNumber * timezoneId;
@property (nonatomic, retain) REMManagedBuildingAirQualityModel *airQuality;
@property (nonatomic, retain) NSOrderedSet *commodities;
@property (nonatomic, retain) NSOrderedSet *dashboards;
@property (nonatomic, retain) REMManagedBuildingCommodityUsageModel *electricityUsageThisMonth;
@property (nonatomic, retain) NSOrderedSet *pictures;
@end

@interface REMManagedBuildingModel (CoreDataGeneratedAccessors)

- (void)insertObject:(REMManagedBuildingCommodityUsageModel *)value inCommoditiesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCommoditiesAtIndex:(NSUInteger)idx;
- (void)insertCommodities:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCommoditiesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCommoditiesAtIndex:(NSUInteger)idx withObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)replaceCommoditiesAtIndexes:(NSIndexSet *)indexes withCommodities:(NSArray *)values;
- (void)addCommoditiesObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)removeCommoditiesObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)addCommodities:(NSOrderedSet *)values;
- (void)removeCommodities:(NSOrderedSet *)values;
- (void)insertObject:(REMManagedDashboardModel *)value inDashboardsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDashboardsAtIndex:(NSUInteger)idx;
- (void)insertDashboards:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDashboardsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDashboardsAtIndex:(NSUInteger)idx withObject:(REMManagedDashboardModel *)value;
- (void)replaceDashboardsAtIndexes:(NSIndexSet *)indexes withDashboards:(NSArray *)values;
- (void)addDashboardsObject:(REMManagedDashboardModel *)value;
- (void)removeDashboardsObject:(REMManagedDashboardModel *)value;
- (void)addDashboards:(NSOrderedSet *)values;
- (void)removeDashboards:(NSOrderedSet *)values;
- (void)insertObject:(REMManagedBuildingPictureModel *)value inPicturesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPicturesAtIndex:(NSUInteger)idx;
- (void)insertPictures:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePicturesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPicturesAtIndex:(NSUInteger)idx withObject:(REMManagedBuildingPictureModel *)value;
- (void)replacePicturesAtIndexes:(NSIndexSet *)indexes withPictures:(NSArray *)values;
- (void)addPicturesObject:(REMManagedBuildingPictureModel *)value;
- (void)removePicturesObject:(REMManagedBuildingPictureModel *)value;
- (void)addPictures:(NSOrderedSet *)values;
- (void)removePictures:(NSOrderedSet *)values;
@end
