/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSplashMapSegue.m
 * Created      : 张 锋 on 10/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMSplashMapSegue.h"
#import "REMSplashScreenController.h"
#import "REMMapViewController.h"
#import "REMCommonHeaders.h"

@implementation REMSplashMapSegue

-(id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
	}
    
	return self;
}

- (void)perform
{
    REMSplashScreenController *splashController = self.sourceViewController;
    REMMapViewController *mapController = self.destinationViewController;
    
    //[splashController.navigationController pushViewController:mapController animated:YES];
    
    UIImageView *splashTransitionView = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:splashController.view]];
    UIImageView *mapTransitionView = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:mapController.view]];
    
    [splashController.view addSubview:mapTransitionView];
    [splashController.view addSubview:splashTransitionView];
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        splashTransitionView.alpha = 0;
    } completion:^(BOOL finished) {
        [splashTransitionView removeFromSuperview];
        [mapTransitionView removeFromSuperview];
        
        [splashController.navigationController pushViewController:mapController animated:NO];
    }];
}


@end
