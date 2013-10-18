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
    REMMapViewController *mapViewController = self.isUnWinding == YES ? self.destinationViewController : self.sourceViewController;
    REMBuildingViewController *buildingViewController = self.isUnWinding == YES ? self.sourceViewController : self.destinationViewController;
    
    
    if(self.isInitialPresenting){
        [self pushBuildingController:buildingViewController intoMapController:mapViewController];
        return;
    }
    
    if(self.isUnWinding == NO){
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
//    CGPoint originalPoint = buildingController.mapViewController.originalPoint;
    UIView *mapView = mapController.view, *buildingView = buildingController.view;
    
    //add building view as subview into map view
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
    
//    CGRect initialFrame = CGRectMake(originalPoint.x, originalPoint.y, 0, 0);
//    CGRect finalFrame = CGRectMake(0, 0, mapView.bounds.size.width, mapView.bounds.size.height);
//    
    transitionView.frame = mapView.bounds;
    transitionView.transform = [self getTransformFromOriginalFrame:mapController.initialRect andFinalFrame:mapView.frame];
    transitionView.center = [self getCenterOfRect:mapController.initialRect];
    
    [mapView addSubview:transitionView];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        transitionView.frame = finalFrame;
        transitionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        transitionView.center = [self getCenterOfRect:mapView.frame];
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        [mapController.navigationController pushViewController:buildingController animated:NO];
    }];
}

-(void)zoomOutMapController:(REMMapViewController *)mapController fromBuildingController:(REMBuildingViewController *)buildingController
{
//    CGPoint originalPoint = buildingController.mapViewController.originalPoint;
    UIView *buildingView = buildingController.view;
    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingView]];
    
//    CGRect initialFrame = CGRectMake(0, 0, buildingView.bounds.size.width, buildingView.bounds.size.height);
//    CGRect finalFrame = CGRectMake(originalPoint.x, originalPoint.y, 0, 0);
    
    transitionView.frame = buildingView.bounds;
    buildingController.mapViewController.snapshot.frame = buildingView.bounds;
    
    [buildingView addSubview:buildingController.mapViewController.snapshot];
    [buildingView addSubview:transitionView];
    
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        transitionView.frame = finalFrame;
        
        transitionView.transform = [self getTransformFromOriginalFrame:buildingController.mapViewController.initialRect andFinalFrame:buildingView.frame];;
        transitionView.center = [self getCenterOfRect:buildingController.mapViewController.initialRect];
        
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        [buildingController.navigationController popViewControllerAnimated:NO];
    }];
}


-(CGAffineTransform)getTransformFromOriginalFrame:(CGRect)originalFrame andFinalFrame:(CGRect)finalFrame
{
    CGFloat ratio = originalFrame.size.width/finalFrame.size.width;
    
    return CGAffineTransformMakeScale(ratio, ratio);
}

-(CGPoint)getCenterOfRect:(CGRect)rect
{
    CGFloat x = rect.origin.x + rect.size.width/2;
    CGFloat y = rect.origin.y + rect.size.height/2;
    return CGPointMake(x, y);
}

@end
