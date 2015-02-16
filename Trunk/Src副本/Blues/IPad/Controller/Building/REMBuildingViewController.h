/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingViewController.h
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import "REMBuildingConstants.h"
#import "REMSettingViewController.h"
#import "REMMapKitViewController.h"
#import "REMDashboardController.h"
#import "REMBuildingImageViewController.h"

@class  REMDashboardController;

typedef enum _BuildingSourceType{
    BuildingSourceTypeFromMap,
    BuildingSourceTypeFromGallery
} BuildingSourceType;

@interface REMBuildingViewController : REMControllerBase<UIGestureRecognizerDelegate,UIPopoverControllerDelegate>

@property (nonatomic,strong) NSArray *buildingInfoArray;

@property (nonatomic) CGFloat currentScrollOffset;

@property (nonatomic) BuildingSourceType buildingSourceType;

@property (nonatomic) int currentBuildingIndex;

@property (nonatomic,strong) UIImage *logoImage;

@property (nonatomic,weak) UIViewController *fromController;

@property (nonatomic,strong) UIPopoverController *sharePopoverController;
@property (nonatomic,strong) NSArray *imageArray;

@property (nonatomic) REMBuildingCoverStatus currentCoverStatus;


- (void)setViewOffset:(CGFloat)offsetY;

- (IBAction)exitMaxWidget:(UIStoryboardSegue *)sender;

- (void)exportImage:(void (^)(UIImage *, NSString*))callback :(BOOL)isMail;

@property (nonatomic,weak) REMDashboardController *maxDashbaordController;

@end
