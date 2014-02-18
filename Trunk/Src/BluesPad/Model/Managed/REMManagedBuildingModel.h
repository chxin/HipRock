//
//  REMManagedBuildingModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "REMManagedModel.h"

@class REMBuildingEnergyUsageModel, REMManagedBuildingPictureModel, REMManagedCommodityModel, REMManagedDashboardModel;

@interface REMManagedBuildingModel : REMManagedModel

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * hasDataPrivilege;
@property (nonatomic, retain) NSNumber * pathLevel;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSNumber * isQualified;
@property (nonatomic, retain) NSSet *commodities;
@property (nonatomic, retain) NSSet *dashboards;
@property (nonatomic, retain) NSSet *pictures;
@property (nonatomic, retain) REMBuildingEnergyUsageModel *electricityUsageThisMonth;
@end

@interface REMManagedBuildingModel (CoreDataGeneratedAccessors)

- (void)addCommoditiesObject:(REMManagedCommodityModel *)value;
- (void)removeCommoditiesObject:(REMManagedCommodityModel *)value;
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
