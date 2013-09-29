//
//  REMMapViewController.h
//  Blues
//
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
@interface REMMapViewController : UIViewController

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

- (IBAction)jumpToBuildingViewButtonPressed:(id)sender;
@end
