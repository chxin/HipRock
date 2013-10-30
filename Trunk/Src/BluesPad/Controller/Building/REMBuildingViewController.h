//
//  REMBuildingViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/26/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import "REMImageView.h"
#import "REMBuildingOverallModel.h"
#import "REMBuildingConstants.h"
#import "REMSettingViewController.h"
#import "REMMapViewController.h"

typedef enum _BuildingSourceType{
    BuildingSourceTypeFromMap,
    BuildingSourceTypeFromGallery
} BuildingSourceType;

@interface REMBuildingViewController : REMControllerBase<UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray *buildingOverallArray;

@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

@property (nonatomic) CGFloat currentScrollOffset;

@property (nonatomic) BuildingSourceType buildingSourceType;

@property (nonatomic,copy) NSNumber *currentBuildingId;

@property (nonatomic,strong) UIImage *logoImage;

@property (nonatomic,weak) UIViewController *fromController;

- (void)switchToDashboard;

- (void)switchToBuildingInfo;

@end
