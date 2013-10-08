//
//  REMMapViewController.h
//  Blues
//
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
@class REMGallaryViewController;

@interface REMMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *gallarySwitchButton;

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) REMSplashScreenController *splashScreenController;
@property (nonatomic,strong) REMGallaryViewController *gallaryViewController;

- (IBAction)jumpToBuildingViewButtonPressed:(id)sender;
- (IBAction)gallarySwitchButtonPressed:(id)sender;


@end
