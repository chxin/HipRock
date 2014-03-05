//
//  REMManagedBuildingModel.h
//  Blues
//
//  Created by tantan on 3/4/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManageBuildingAirQualityModel, REMManagedBuildingCommodityUsageModel, REMManagedBuildingPictureModel, REMManagedDashboardModel;

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
@property (nonatomic, retain) NSNumber * timezoneId;
@property (nonatomic, retain) REMManageBuildingAirQualityModel *airQuality;
@property (nonatomic, retain) NSSet *commodities;
@property (nonatomic, retain) NSSet *dashboards;
@property (nonatomic, retain) NSSet *pictures;
@property (nonatomic, retain) REMManagedBuildingCommodityUsageModel *electricityUsageThisMonth;
@end

@interface REMManagedBuildingModel (CoreDataGeneratedAccessors)

- (void)addCommoditiesObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)removeCommoditiesObject:(REMManagedBuildingCommodityUsageModel *)value;
- (void)addCommodities:(NSSet *)values;
- (void)removeCommodities:(NSSet *)values;

- (void)addDashboardsObject:(REMManagedDashboardModel *)value;
- (void)removeDashboardsObject:(REMManagedDashboardModel *)value;
- (void)addDashboards:(NSSet *)values;
- (void)removeDashboards:(NSSet *)values;

- (void)addPicturesObject:(REMManagedBuildingPictureModel *)value;
- (void)removePicturesObject:(REMManagedBuildingPictureModel *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
