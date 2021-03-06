/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingEntranceSegue.m
 * Created      : 张 锋 on 10/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingEntranceSegue.h"
#import "REMMapKitViewController.h"
#import "REMGalleryViewController.h"
#import "REMBuildingViewController.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"
#import "REMManagedBuildingModel.h"
#import "REMManagedBuildingPictureModel.h"
@interface REMBuildingEntranceSegue ()

@property (nonatomic) CGFloat segueTime;

@end

@implementation REMBuildingEntranceSegue

#define kSequeTime 0.4f
#define kFirstSugueTime kSequeTime



-(void)prepareSegueWithParameter:(REMBuildingSegueZoomParamter)parameter
{
    self.parameter = parameter;
    
    self.segueTime = [self.sourceViewController isKindOfClass:[REMMapKitViewController class]] == YES && ((REMMapKitViewController *)self.sourceViewController).isInitialPresenting == YES ? kFirstSugueTime : kSequeTime;
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
    
    transitionView.frame = CGRectMake(sourceView.frame.origin.x, sourceView.frame.origin.y, sourceView.frame.size.width, sourceView.frame.size.height);
    transitionView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.parameter.initialZoomFrame andFinalFrame:self.parameter.finalZoomFrame];
    transitionView.center = [REMViewHelper getCenterOfRect:self.parameter.initialZoomFrame];
    
    [sourceView addSubview:transitionView];
    
    [UIView animateWithDuration:self.segueTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        transitionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        transitionView.center = [REMViewHelper getCenterOfRect:self.parameter.finalZoomFrame];
    } completion:^(BOOL finished){
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
        
        [buildingView setUserInteractionEnabled:YES];
        [buildingController.navigationController popViewControllerAnimated:NO];
    }];
}

-(UIImageView *)getBuildingTransitionView
{
    //if no image at all, use default
    REMManagedBuildingModel *building =[self.sourceViewController buildingInfoArray][self.parameter.currentBuildingIndex];
    NSArray *imageIds=building.pictures.array;
    
    if(imageIds == nil || imageIds.count <= 0){
        UIImageView *imageView =[[UIImageView alloc] initWithImage:REMIMG_DefaultBuilding];
        imageView.contentMode = UIViewContentModeTop;

        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height * kDMCommon_ImageScale);
        return imageView;
    }
    REMManagedBuildingPictureModel *picModel = imageIds[0];

    //if there is large image, use large
    NSString *normalImagePath = [REMImageHelper buildingImagePathWithId:picModel.id andType:REMBuildingImageNormal];
    NSString *smallImagePath = [REMImageHelper buildingImagePathWithId:picModel.id andType:REMBuildingImageSmall];
    
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:normalImagePath]){
        UIImage *scaled = [REMImageHelper imageWithImage:[UIImage imageWithContentsOfFile:normalImagePath] scaledWithFactor:kDMCommon_ImageScale];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:scaled];
        imageView.contentMode = UIViewContentModeTop;
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height * kDMCommon_ImageScale);
        imageView.clipsToBounds = YES;
        
        return imageView;
    }
    //if no large, use small
    else if([[NSFileManager defaultManager] fileExistsAtPath:smallImagePath]){
        UIImage *original = [UIImage imageWithContentsOfFile:smallImagePath];
        
        CGSize size = CGSizeMake(2*original.size.width * kDMCommon_ImageScale, 2*original.size.height * kDMCommon_ImageScale);
        
        //resize image to cell size * factor
        UIImage *resized = [REMImageHelper scaleImage:original toSize:size];
        
        //crop image
        CGRect rect = CGRectMake((size.width - 2*original.size.width)/2, 0,2*original.size.width, 2*original.size.height);
        UIImage *final = [REMImageHelper cropImage:resized toRect:rect];
        
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:final];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height*kDMCommon_ImageScale);
        imageView.clipsToBounds = YES;
        return imageView;
    }
    //if even no small, use default
    else{
        UIImage *scaled = REMIMG_DefaultBuilding;
        UIImageView *imageView =  [[UIImageView alloc] initWithImage:scaled];
        imageView.contentMode = UIViewContentModeTop;
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height * kDMCommon_ImageScale);
        imageView.clipsToBounds = YES;
        return imageView;
    }
}

@end
