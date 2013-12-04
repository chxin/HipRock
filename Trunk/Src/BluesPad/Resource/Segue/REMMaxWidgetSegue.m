/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMaxWidgetSegue.m
 * Created      : tantan on 10/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMMaxWidgetSegue.h"
#import "REMBuildingViewController.h"
#import "REMWidgetMaxViewController.h"
#import "REMWidgetDetailViewController.h"
#import "REMWidgetCellViewController.h"
#import "REMDashboardController.h"
#import "REMWidgetCollectionViewController.h"
#import "REMDimensions.h"
#import "UIView+FlipTransition.h"
#import <QuartzCore/QuartzCore.h>

@interface REMMaxWidgetSegue()

@property (nonatomic,weak) UIView *readyMoveView;
@property (nonatomic,weak) UIView *preMoveView;
@property (nonatomic,weak) REMWidgetCellViewController *cellController;
@end

@implementation REMMaxWidgetSegue


- (void)max{
    REMWidgetMaxViewController *destController=self.destinationViewController;
    REMBuildingViewController *srcController= self.sourceViewController;

    
    REMDashboardController *dashboardController=srcController.maxDashbaordController;
    
    REMWidgetCollectionViewController *collectionController= dashboardController.childViewControllers[dashboardController.currentMaxDashboardIndex];
    
    REMWidgetCellViewController *cellController=collectionController.childViewControllers[collectionController.currentMaxWidgetIndex];

    UIImage *image=[REMImageHelper imageWithLayer:cellController.view.layer];
    
    UIImageView *cloneView=[[UIImageView alloc]initWithImage:image];
    destController.currentWidgetIndex=collectionController.currentMaxWidgetIndex;
    
    [cellController.view setHidden:YES];
    self.cellController = cellController;
    CGRect frame=[cellController.view convertRect:cellController.view.frame fromView:srcController.view];
    CGRect newFrame= CGRectMake(frame.origin.x*-1, frame.origin.y*-1, frame.size.width, frame.size.height);
    
    [cloneView setFrame:newFrame];
    [srcController.view addSubview:cloneView];
    
    UIView *destImageView=destController.view;
    
    [srcController.view addSubview:destImageView];
    //[srcController.view setUserInteractionEnabled:NO];

    
    
    CGRect retFrame= CGRectMake(0, 0, kDMScreenWidth, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight));
    
    [destImageView setFrame:retFrame];
    [destImageView setHidden:YES];
    
    self.preMoveView=cloneView;
    self.readyMoveView=destImageView;
    
    
    NSTimer *timer =[NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(flipToMax) userInfo:nil repeats:NO];
    NSRunLoop *loop=[NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];

}

- (void)flipToMax{
    [UIView flipTransitionFromView:self.preMoveView toView:self.readyMoveView duration:0.6 completion:^(BOOL finished){
        [self.readyMoveView removeFromSuperview];
        [self.preMoveView removeFromSuperview];
        UIViewController *vc=self.sourceViewController;
        [vc.view setUserInteractionEnabled:YES];
        [self.cellController.view setHidden:NO];
        [vc.navigationController pushViewController:self.destinationViewController animated:NO];
    }];
    
}


- (void)min{
    REMBuildingViewController *destController=self.destinationViewController;
    REMWidgetMaxViewController *srcController=self.sourceViewController;
    REMWidgetDetailViewController *currentDetailController= srcController.childViewControllers[srcController.currentWidgetIndex];
    
    UIImage *image=[REMImageHelper imageWithView:currentDetailController.view];
    
    UIImageView *destImageView=[[UIImageView alloc]initWithImage:image];

    [destImageView setFrame:CGRectMake(srcController.lastPageXPosition, destImageView.frame.origin.y, destImageView.frame.size.width, destImageView.frame.size.height)];
    
    [destController.view addSubview:destImageView];
    REMDashboardController *dashboardController= destController.maxDashbaordController;
    
    REMWidgetCollectionViewController *collectionController= dashboardController.childViewControllers[dashboardController.currentMaxDashboardIndex];
    
    REMWidgetCellViewController *cellController=collectionController.childViewControllers[srcController.currentWidgetIndex];
    self.cellController=cellController;
    CGRect frame=[cellController.view convertRect:cellController.view.frame fromView:destController.view];
    CGRect newFrame= CGRectMake(frame.origin.x*-1, frame.origin.y*-1, frame.size.width, frame.size.height);
    
    UIImage *cloneImage=[REMImageHelper imageWithView:cellController.view];
    UIImageView *cloneView=[[UIImageView alloc]initWithImage:cloneImage];
    [cloneView setFrame:newFrame];
    [cloneView setHidden:YES];
    [destController.view addSubview:cloneView];
    [cellController.view setHidden:YES];
    self.readyMoveView=destImageView;
    self.preMoveView=cloneView;
    [srcController.navigationController popViewControllerAnimated:NO];
    NSTimer *timer =[NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(flipToSmall) userInfo:nil repeats:NO];
    NSRunLoop *loop=[NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)flipToSmall{
    [UIView flipTransitionFromView:self.readyMoveView toView:self.preMoveView duration:0.6 completion:^(BOOL finished){
        [self.readyMoveView removeFromSuperview];
        [self.preMoveView removeFromSuperview];
        [self.cellController.view setHidden:NO];
    }];
    
}

- (void)perform
{
    if([self.destinationViewController isKindOfClass:[REMWidgetMaxViewController class]]== YES){
        [self max];
    }
    else{
        [self min];
    }

}

@end
