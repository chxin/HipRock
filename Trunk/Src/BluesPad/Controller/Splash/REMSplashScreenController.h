/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSplashScreenController.h
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMChartHeader.h"

@interface REMSplashScreenController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIImageView *flashLogo;
@property (weak, nonatomic) IBOutlet UIImageView *normalLogo;

@property (nonatomic,strong) NSMutableArray *buildingInfoArray;

- (void)showMapView:(void (^)(void))loadCompleted;
- (void)showLoginView:(BOOL)isAnimated;


@end
