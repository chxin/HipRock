//
//  REMBuildingViewController.h
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import "REMImageView.h"
#import "REMBuildingOverallModel.h"
#import "REMBuildingConstants.h"
#import "REMBuildingSettingViewController.h"

@interface REMBuildingViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSArray *buildingOverallArray;

@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

@property (nonatomic) CGFloat currentScrollOffset;
- (void)notifyCustomImageLoaded:(NSNumber *)buildingId;
@end
