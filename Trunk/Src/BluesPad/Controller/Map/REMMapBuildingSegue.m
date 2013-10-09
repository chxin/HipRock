//
//  REMMapToBuildingSegue.m
//  Blues
//
//  Created by 张 锋 on 10/8/13.
//
//

#import "REMMapBuildingSegue.h"
#import "REMSegues.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingViewController.h"
#import "REMMapViewController.h"
#import "REMCommonHeaders.h"



@implementation REMMapBuildingSegue

- (id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
		self.isUnWinding = [identifier isEqualToString:kBuildingToMapSegue];
	}
    
	return self;
}


- (void)perform
{
    REMMapViewController *mapViewController = self.isUnWinding == YES ? self.destinationViewController : self.sourceViewController;
    REMBuildingViewController *buildingViewController = self.isUnWinding == YES ? self.sourceViewController : self.destinationViewController;
    
    UIView *mapView = mapViewController.view, *buildingView = buildingViewController.view;
    
    CGPoint originalPoint = buildingViewController.mapViewController.originalPoint;
    
    
    if(self.isUnWinding == NO){
        //add building view as subview into map view
        __block UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
        
        CGRect initialFrame = CGRectMake(originalPoint.x, originalPoint.y, 0, 0);
        CGRect finalFrame = CGRectMake(0, 0, mapView.bounds.size.width, mapView.bounds.size.height);
        
        transitionView.frame = initialFrame;
        
        [mapView addSubview:transitionView];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            transitionView.frame = finalFrame;
        } completion:^(BOOL finished){
            [transitionView removeFromSuperview];
            transitionView = nil;
            [mapViewController.navigationController pushViewController:buildingViewController animated:NO];
        }];
    }
    else{
        __block UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
        
        CGRect initialFrame = CGRectMake(0, 0, buildingView.bounds.size.width, buildingView.bounds.size.height);
        CGRect finalFrame = CGRectMake(originalPoint.x, originalPoint.y, 0, 0);
        
        transitionView.frame = initialFrame;
        buildingViewController.mapViewController.snapshot.frame = initialFrame;
        
        [buildingView addSubview:buildingViewController.mapViewController.snapshot];
        [buildingView addSubview:transitionView];
        
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            transitionView.frame = finalFrame;
        } completion:^(BOOL finished){
            [transitionView removeFromSuperview];
            transitionView = nil;
            [buildingViewController.navigationController popViewControllerAnimated:NO];
        }];
    }
}

@end
