//
//  REMSplashMapSegue.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/16/13.
//
//

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
