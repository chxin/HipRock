//
//  REMSplashScreenController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/26/13.
//
//

#import <UIKit/UIKit.h>

@interface REMSplashScreenController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIImageView *flashLogo;
@property (weak, nonatomic) IBOutlet UIImageView *normalLogo;

@property (nonatomic,strong) NSMutableArray *buildingInfoArray;

- (void)showMapView:(void (^)(void))loadCompleted;
- (void)showLoginView:(BOOL)isAnimated;



@end
