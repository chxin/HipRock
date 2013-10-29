//
//  REMBuildingEntranceSegue.h
//  Blues
//
//  Created by 张 锋 on 10/23/13.
//
//

#import <UIKit/UIKit.h>
#import "REMGalleryViewController.h"
#import "REMMapViewController.h"

@interface REMBuildingEntranceSegue : UIStoryboardSegue

@property (nonatomic) BOOL isInitialPresenting;
@property (nonatomic) BOOL isNoAnimation;
@property (nonatomic) CGRect initialZoomRect;
@property (nonatomic) CGRect finalZoomRect;
@property (nonatomic,weak) REMBuildingModel *currentBuilding;


@end
