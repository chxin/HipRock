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

@interface REMBuildingViewController : UIViewController

@property (nonatomic,strong) NSArray *buildingOverallArray;

@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

- (IBAction)dashboardButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;

@end
