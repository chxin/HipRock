/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPrefaceViewController.h
 * Created      : 张 锋 on 7/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
@class REMLoginCardController;
@class REMTrialCardController;
#import "REMLoginCustomerTableViewController.h"

@interface REMLoginCarouselController : UIViewController<UIScrollViewDelegate,REMLoginCustomerSelectionDelegate>

@property (nonatomic) BOOL showAnimation;
@property (nonatomic,weak) REMSplashScreenController *splashScreenController;
@property (nonatomic,weak) REMLoginCardController *loginCardController;
@property (nonatomic,weak) REMTrialCardController *trialCardController;

//- (IBAction)pageChanged:(id)sender;
//- (IBAction)jumpLoginButtonTouchDown:(id)sender;

-(void)showLoginCard;
-(void)playCarousel:(BOOL)isAnimated;
-(void)presentCustomerSelectionView;



@end
