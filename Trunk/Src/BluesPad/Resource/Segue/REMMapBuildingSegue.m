//
//  REMMapToBuildingSegue.m
//  Blues
//
//  Created by 张 锋 on 10/8/13.
//
//

#import "REMMapBuildingSegue.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingViewController.h"
#import "REMMapViewController.h"
#import "REMCommonHeaders.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"



@implementation REMMapBuildingSegue

- (id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
		self.isUnWinding = [identifier isEqualToString:kSegue_BuildingToMap];
	}
    
	return self;
}


- (void)perform
{
    NSLog(@"is first presenting: %d",self.isInitialPresenting);
    REMMapViewController *mapViewController = self.isUnWinding == YES ? self.destinationViewController : self.sourceViewController;
    REMBuildingViewController *buildingViewController = self.isUnWinding == YES ? self.sourceViewController : self.destinationViewController;
    
    
    if(self.isInitialPresenting){
        [self pushBuildingController:buildingViewController intoMapController:mapViewController];
        return;
    }
    
    if(self.isUnWinding == NO){
        NSLog(@"mb:%@",NSStringFromCGPoint(mapViewController.originalPoint));
        [self zoomInBuildingController:buildingViewController fromMapController:mapViewController];
        return;
    }
    else{
        NSLog(@"bm:%@",NSStringFromCGPoint(buildingViewController.mapViewController.originalPoint));
        [self zoomOutMapController:mapViewController fromBuildingController:buildingViewController];
        return;
    }
}


-(void)pushBuildingController:(REMBuildingViewController *)buildingController intoMapController:(REMMapViewController *)mapController
{
    //push building view into map view
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingController.view]];
    
    transitionView.frame = CGRectMake(kDMScreenWidth, 0, mapController.view.bounds.size.width, mapController.view.bounds.size.height);
    
    [mapController.view addSubview:transitionView];
    
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        transitionView.frame = CGRectMake(0, 0, mapController.view.bounds.size.width, mapController.view.bounds.size.height);;
    } completion:^(BOOL finished) {
        [transitionView removeFromSuperview];
        [mapController.navigationController pushViewController:buildingController animated:NO];
    }];
}

-(void)zoomInBuildingController:(REMBuildingViewController *)buildingController fromMapController:(REMMapViewController *)mapController
{
    CGPoint originalPoint = buildingController.mapViewController.originalPoint;
    UIView *mapView = mapController.view, *buildingView = buildingController.view;
    
    //add building view as subview into map view
    __block UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
    
    CGRect initialFrame = CGRectMake(originalPoint.x, originalPoint.y, 0, 0);
    CGRect finalFrame = CGRectMake(0, 0, mapView.bounds.size.width, mapView.bounds.size.height);
    
    transitionView.frame = initialFrame;
    
    [mapView addSubview:transitionView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        transitionView.frame = finalFrame;
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        transitionView = nil;
        [mapController.navigationController pushViewController:buildingController animated:NO];
    }];
}

-(void)zoomOutMapController:(REMMapViewController *)mapController fromBuildingController:(REMBuildingViewController *)buildingController
{
    CGPoint originalPoint = buildingController.mapViewController.originalPoint;
    UIView *buildingView = buildingController.view;
    
    __block UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
    
    CGRect initialFrame = CGRectMake(0, 0, buildingView.bounds.size.width, buildingView.bounds.size.height);
    CGRect finalFrame = CGRectMake(originalPoint.x, originalPoint.y, 0, 0);
    
    transitionView.frame = initialFrame;
    buildingController.mapViewController.snapshot.frame = initialFrame;
    
    [buildingView addSubview:buildingController.mapViewController.snapshot];
    [buildingView addSubview:transitionView];
    
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        transitionView.frame = finalFrame;
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        transitionView = nil;
        [buildingController.navigationController popViewControllerAnimated:NO];
    }];
}

@end
