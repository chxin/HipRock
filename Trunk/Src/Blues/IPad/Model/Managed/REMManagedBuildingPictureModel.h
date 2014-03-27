//
//  REMManagedBuildingPictureModel.h
//  Blues
//
//  Created by tantan on 2/25/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class REMManagedBuildingModel;

@interface REMManagedBuildingPictureModel : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) UIImage * normalImage;
@property (nonatomic, retain) UIImage * bluredImage;

@property (nonatomic, retain) REMManagedBuildingModel *building;

@end
