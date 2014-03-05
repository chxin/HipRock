//
//  REMManageBuildingAirQualityModel.h
//  Blues
//
//  Created by tantan on 2/25/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingModel;

@interface REMManageBuildingAirQualityModel : NSManagedObject

@property (nonatomic, retain) NSString * commodityCode;
@property (nonatomic, retain) NSNumber * commodityId;
@property (nonatomic, retain) NSString * commodityName;
@property (nonatomic, retain) NSString * honeywellUom;
@property (nonatomic, retain) NSNumber * honeywellValue;
@property (nonatomic, retain) NSString * mayairUom;
@property (nonatomic, retain) NSNumber * mayairValue;
@property (nonatomic, retain) NSString * outdoorUom;
@property (nonatomic, retain) NSNumber * outdoorValue;
@property (nonatomic, retain) REMManagedBuildingModel *building;

@end
