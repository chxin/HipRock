//
//  REMBuildingEntranceSegue.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/23/13.
//
//

#import "REMBuildingEntranceSegue.h"
#import "REMMapViewController.h"
#import "REMGalleryViewController.h"
#import "REMBuildingViewController.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"

@implementation REMBuildingEntranceSegue

- (void)perform
{
    if(self.isInitialPresenting){
        [self slideIn];
        
        return;
    }
    
    if(self.isNoAnimation == YES){
        [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
        
        return;
    }
    
    if([self.sourceViewController class] == [REMBuildingViewController class]){
        [self exit];
    }
    else{
        [self enter];
    }
}

-(void)slideIn
{
    REMBuildingViewController *buildingController = self.destinationViewController;
    REMMapViewController *mapController = self.sourceViewController;
    
    [mapController.view setUserInteractionEnabled:NO];
    
    //push building view into map view
    UIImageView *transitionView = [self getBuildingTransitionView];
    
    transitionView.frame = CGRectMake(kDMScreenWidth, 0, mapController.view.bounds.size.width, mapController.view.bounds.size.height);
    
    [mapController.view addSubview:transitionView];
    
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        transitionView.frame = CGRectMake(0, 0, mapController.view.bounds.size.width, mapController.view.bounds.size.height);;
    } completion:^(BOOL finished) {
        [transitionView removeFromSuperview];
        [mapController.view setUserInteractionEnabled:YES];
        [mapController.navigationController pushViewController:buildingController animated:NO];
    }];
}

//building enter
-(void)enter
{
    NSLog(@"begin %@", [NSDate date]);
    REMBuildingViewController *buildingController = self.destinationViewController;
    
    UIView *sourceView = [self.sourceViewController view];//, *buildingView = buildingController.view;
    [sourceView setUserInteractionEnabled:NO];
    
    //add building view as subview into map view
    UIImageView *transitionView = [self getBuildingTransitionView];
    
    transitionView.frame = sourceView.bounds;
    transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.initialZoomRect andFinalFrame:self.finalZoomRect];
    transitionView.center = [REMViewHelper getCenterOfRect:self.initialZoomRect];
    
    [sourceView addSubview:transitionView];
    
    NSLog(@"animation %@", [NSDate date]);
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        transitionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        transitionView.center = [REMViewHelper getCenterOfRect:self.finalZoomRect];
    } completion:^(BOOL finished){
        NSLog(@"end %@", [NSDate date]);
        [transitionView removeFromSuperview];
        [sourceView setUserInteractionEnabled:YES];
        [[self.sourceViewController navigationController] pushViewController:buildingController animated:NO];
    }];
}

//building exit
-(void)exit
{
    REMBuildingViewController *buildingController = self.sourceViewController;
    
    UIView *buildingView = buildingController.view;
    [buildingView setUserInteractionEnabled:NO];
    UIImageView *snapshot = [((id)buildingController.fromController) snapshot];
    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingController.view]];
    
    transitionView.frame = buildingView.bounds;
    snapshot.frame = buildingView.bounds;
    
    [buildingView addSubview:snapshot];
    [buildingView addSubview:transitionView];
    
    CGRect initialZoomRect = [((id)buildingController.fromController) getCurrentZoomRect:buildingController.currentBuildingId];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:initialZoomRect andFinalFrame:self.finalZoomRect];
        transitionView.center = [REMViewHelper getCenterOfRect:initialZoomRect];
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        [buildingView setUserInteractionEnabled:YES];
        [buildingController.navigationController popViewControllerAnimated:NO];
    }];
}

-(UIImageView *)getBuildingTransitionView
{
    //if no image at all, use default
    NSArray *imageIds = self.currentBuilding.pictureIds;
    if(imageIds == nil || imageIds.count <= 0)
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultBuilding.png"]];
    
    //if there is large image, use large
    NSString *normalImagePath = [REMImageHelper buildingImagePathWithId:imageIds[0] andType:REMBuildingImageNormal];
    NSString *smallImagePath = [REMImageHelper buildingImagePathWithId:imageIds[0] andType:REMBuildingImageSmall];
    if([[NSFileManager defaultManager] fileExistsAtPath:normalImagePath])
        return [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:normalImagePath]];
    //if no large, use small
    else if([[NSFileManager defaultManager] fileExistsAtPath:smallImagePath])
        return [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:smallImagePath]];
    //if even no small, use default
    else
        return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultBuilding.png"]];
}

@end
