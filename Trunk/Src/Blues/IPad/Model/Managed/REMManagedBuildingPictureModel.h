//
//  REMManagedBuildingPictureModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingModel;

@interface REMManagedBuildingPictureModel : NSManagedObject

@property (nonatomic, retain) NSData * bluredImage;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSData * normalImage;
@property (nonatomic, retain) REMManagedBuildingModel *building;

@end
