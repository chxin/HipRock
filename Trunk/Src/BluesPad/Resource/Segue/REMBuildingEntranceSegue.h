//
//  REMBuildingEntranceSegue.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
