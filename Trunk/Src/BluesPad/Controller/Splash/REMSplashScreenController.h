//
//  REMSplashScreenController.h
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import <UIKit/UIKit.h>

@interface REMSplashScreenController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *logoView;

- (void)showBuildingView;
- (void)showLoginView;

@end
