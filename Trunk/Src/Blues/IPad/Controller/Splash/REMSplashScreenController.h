/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSplashScreenController.h
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "DCChartEnum.h"
@class REMLoginCarouselController;

@interface REMSplashScreenController : UIViewController

@property (nonatomic,weak) REMLoginCarouselController *carouselController;

- (void)showLoginView:(BOOL)isAnimated;
- (void)showMapView;

@end
