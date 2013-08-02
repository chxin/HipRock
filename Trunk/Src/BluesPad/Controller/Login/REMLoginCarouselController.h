//
//  REMPrefaceViewController.h
//  Blues
//
//  Created by 张 锋 on 7/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"

@interface REMLoginCarouselController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *gotoLoginButton;

@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

- (IBAction)pageChanged:(id)sender;
- (IBAction)gotoLoginButtonTouchDown:(id)sender;

@end
