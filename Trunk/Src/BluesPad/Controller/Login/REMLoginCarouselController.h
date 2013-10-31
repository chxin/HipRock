//
//  REMPrefaceViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"

@interface REMLoginCarouselController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *jumpLoginButton;
@property (nonatomic) BOOL showAnimation;

@property (nonatomic,strong) REMSplashScreenController *splashScreenController;

- (IBAction)pageChanged:(id)sender;
- (IBAction)jumpLoginButtonTouchDown:(id)sender;
-(void)showLoginPage;
- (void)initializationCarousel;

@end
