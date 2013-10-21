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
		self.isUnwinding = [identifier isEqualToString:kSegue_BuildingToMap];
	}
    
	return self;
}


- (void)perform
{
    REMMapViewController *mapViewController = self.isUnwinding == YES ? self.destinationViewController : self.sourceViewController;
    REMBuildingViewController *buildingViewController = self.isUnwinding == YES ? self.sourceViewController : self.destinationViewController;
    
    
    if(self.isInitialPresenting){
        [self pushBuildingController:buildingViewController intoMapController:mapViewController];
        return;
    }
    
    if(self.isUnwinding == NO){
        [self zoomInBuildingController:buildingViewController fromMapController:mapViewController];
        return;
    }
    else{
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
    UIView *mapView = mapController.view, *buildingView = buildingController.view;
    
    //add building view as subview into map view
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
    
    transitionView.frame = mapView.bounds;
    transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.initialZoomRect andFinalFrame:self.finalZoomRect];
    transitionView.center = [REMViewHelper getCenterOfRect:self.initialZoomRect];
    
    [mapView addSubview:transitionView];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        transitionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        transitionView.center = [REMViewHelper getCenterOfRect:self.finalZoomRect];
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        [mapController.navigationController pushViewController:buildingController animated:NO];
    }];
}

-(void)zoomOutMapController:(REMMapViewController *)mapController fromBuildingController:(REMBuildingViewController *)buildingController
{
    UIView *buildingView = buildingController.view;
    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
    
    transitionView.frame = buildingView.bounds;
    buildingController.mapViewController.snapshot.frame = buildingView.bounds;
    
    [buildingView addSubview:buildingController.mapViewController.snapshot];
    [buildingView addSubview:transitionView];
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.initialZoomRect andFinalFrame:self.finalZoomRect];;
        transitionView.center = [REMViewHelper getCenterOfRect:buildingController.mapViewController.initialZoomRect];
        
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        [buildingController.navigationController popViewControllerAnimated:NO];
    }];
}

@end
