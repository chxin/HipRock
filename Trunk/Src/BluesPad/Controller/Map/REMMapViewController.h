//
//  REMMapViewController.h
//  Blues
//
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMControllerBase.h"
@class REMGallaryViewController;
@class REMBuildingViewController;

@interface REMMapViewController : REMControllerBase<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *gallarySwitchButton;

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) REMSplashScreenController *splashScreenController;
@property (nonatomic,strong) REMGallaryViewController *gallaryViewController;
@property (nonatomic,strong) REMBuildingViewController *buildingViewController;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic) CGPoint originalPoint;

- (IBAction)gallarySwitchButtonPressed:(id)sender;


@end
