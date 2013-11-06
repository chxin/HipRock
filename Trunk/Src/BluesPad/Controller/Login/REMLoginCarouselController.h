/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPrefaceViewController.h
 * Created      : 张 锋 on 7/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
