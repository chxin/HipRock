/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingEntranceSegue.m
 * Created      : 张 锋 on 10/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingEntranceSegue.h"
#import "REMMapViewController.h"
#import "REMGalleryViewController.h"
#import "REMBuildingViewController.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"

@interface REMBuildingEntranceSegue ()

@property (nonatomic) CGFloat segueTime;

@end

@implementation REMBuildingEntranceSegue

#define kSequeTime 0.4f
#define kFirstSugueTime kSequeTime



-(void)prepareSegueWithParameter:(REMBuildingSegueZoomParamter)parameter
{
    self.parameter = parameter;
    
    self.segueTime = [self.sourceViewController isKindOfClass:[REMMapViewController class]] == YES && ((REMMapViewController *)self.sourceViewController).isInitialPresenting == YES ? kFirstSugueTime : kSequeTime;
}

- (void)perform
{
    if([self.sourceViewController class] == [REMBuildingViewController class]){
        if(self.parameter.isNoAnimation == YES){
            [[self.sourceViewController navigationController] popViewControllerAnimated:NO];
        }
        else{
            [self exit];
        }
    }
    else{
        if(self.parameter.isNoAnimation == YES){
            [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
        }
        else{
            [self enter];
        }
    }
}

//building enter
-(void)enter
{
    REMBuildingViewController *buildingController = self.destinationViewController;
    
    UIView *sourceView = [self.sourceViewController view];//, *buildingView = buildingController.view;
    //[sourceView setUserInteractionEnabled:NO];
    
    //add building view as subview into map view
    UIImageView *transitionView = [self getBuildingTransitionView];
    
    transitionView.frame = sourceView.bounds;
    transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.parameter.initialZoomFrame andFinalFrame:self.parameter.finalZoomFrame];
    transitionView.center = [REMViewHelper getCenterOfRect:self.parameter.initialZoomFrame];
    
    [sourceView addSubview:transitionView];
    
    [UIView animateWithDuration:self.segueTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        transitionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        transitionView.center = [REMViewHelper getCenterOfRect:self.parameter.finalZoomFrame];
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        //[sourceView setUserInteractionEnabled:YES];
        [[self.sourceViewController navigationController] pushViewController:buildingController animated:NO];
    }];
}

//building exit
-(void)exit
{
    REMBuildingViewController *buildingController = self.sourceViewController;
    
    UIView *buildingView = buildingController.view;
    //[buildingView setUserInteractionEnabled:NO];
    UIImageView *snapshot = [((id)buildingController.fromController) snapshot];
    
    UIImageView *transitionView = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:buildingController.view]];
    
    transitionView.frame = buildingView.bounds;
    snapshot.frame = buildingView.bounds;
    
    [buildingView addSubview:snapshot];
    [buildingView addSubview:transitionView];
    
    CGRect initialZoomRect = [((id)buildingController.fromController) getDestinationZoomRect:buildingController.currentBuildingIndex];
    
    [UIView animateWithDuration:self.segueTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:initialZoomRect andFinalFrame:self.parameter.finalZoomFrame];
        transitionView.center = [REMViewHelper getCenterOfRect:initialZoomRect];
    } completion:^(BOOL finished){
        [transitionView removeFromSuperview];
        [snapshot removeFromSuperview];
        
        //[buildingView setUserInteractionEnabled:YES];
        [buildingController.navigationController popViewControllerAnimated:NO];
    }];
}

-(UIImageView *)getBuildingTransitionView
{
    //if no image at all, use default
    NSArray *imageIds = [[self.sourceViewController buildingInfoArray][self.parameter.currentBuildingIndex] building].pictureIds;
    if(imageIds == nil || imageIds.count <= 0)
        return [[UIImageView alloc] initWithImage:REMIMG_DefaultBuilding];
    
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
        return [[UIImageView alloc] initWithImage:REMIMG_DefaultBuilding];
}

@end
