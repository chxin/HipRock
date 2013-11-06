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


#import <QuartzCore/QuartzCore.h>

@interface REMMaxWidgetSegue()

@property (nonatomic) CGRect readyMoveFrame;
@property (nonatomic,weak) UIView *readyMoveView;
@property (nonatomic) BOOL isMax;
@property (nonatomic,weak) UIView *preMoveView;
@end

@implementation REMMaxWidgetSegue


- (void)max{
    REMWidgetMaxViewController *destController=self.destinationViewController;
    
    //UIView *destView = destController.view;
    
    
    //UIImage *image=[REMImageHelper imageWithView:destView];
    
    //UIImageView *destImageView=[[UIImageView alloc]initWithImage:image];
    
    
    REMBuildingViewController *srcController= self.sourceViewController;
    
    UIView *destImageView=[[UIView alloc]initWithFrame:srcController.view.frame];
    
    [destImageView setBackgroundColor:[UIColor grayColor]];

    
    REMDashboardController *dashboardController=srcController.maxDashbaordController;
    
    REMWidgetCollectionViewController *collectionController= dashboardController.childViewControllers[dashboardController.currentMaxDashboardIndex];
    
    REMWidgetCellViewController *cellController=collectionController.childViewControllers[collectionController.currentMaxWidgetIndex];
    UIButton *button=cellController.view.subviews[0];
    UIImageView *cloneView=[[UIImageView alloc]initWithImage:[REMImageHelper imageWithView:button]];
    destController.currentWidgetIndex=collectionController.currentMaxWidgetIndex;
    
    CGRect frame=[cellController.view convertRect:cellController.view.frame fromView:srcController.view];
    CGRect newFrame= CGRectMake(frame.origin.x*-1, frame.origin.y*-1, frame.size.width, frame.size.height);
    
    [cloneView setFrame:newFrame];
    [srcController.view addSubview:cloneView];
    
    //NSLog(@"max frame:%@",NSStringFromCGRect(newFrame));
    
    
    [srcController.view addSubview:destImageView];
    [srcController.view setUserInteractionEnabled:NO];

    
    
    CGRect retFrame= CGRectMake(0, 0, 1024, 748);
    
    [destImageView setFrame:retFrame];
    destImageView.alpha=0;
    
    self.preMoveView=cloneView;
    self.readyMoveFrame=retFrame;
    self.readyMoveView=destImageView;
 
    
    NSTimer *timer =[NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(flipToMax) userInfo:nil repeats:NO];
    NSRunLoop *loop=[NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];

}

- (void)flipToMax{
    [UIView transitionWithView:self.preMoveView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void){
        self.readyMoveView.alpha=1;
        self.preMoveView.alpha=0;
        [self.preMoveView setFrame:self.readyMoveFrame];
        //[self.readyMoveView setFrame:self.readyMoveFrame];
    } completion:^(BOOL finished){
        [self.preMoveView removeFromSuperview];
        [self.readyMoveView removeFromSuperview];
        UIViewController *vc=self.sourceViewController;
        [vc.view setUserInteractionEnabled:YES];
        [vc.navigationController pushViewController:self.destinationViewController animated:NO];
    }];
}


- (void)min{
    REMBuildingViewController *destController=self.destinationViewController;
    REMWidgetMaxViewController *srcController=self.sourceViewController;
    REMWidgetDetailViewController *currentDetailController= srcController.childViewControllers[0];
    
    UIImage *image=[REMImageHelper imageWithView:currentDetailController.view];
    
    UIImageView *destImageView=[[UIImageView alloc]initWithImage:image];

    
    [destController.view addSubview:destImageView];
    REMDashboardController *dashboardController= destController.maxDashbaordController;
    
    REMWidgetCollectionViewController *collectionController= dashboardController.childViewControllers[dashboardController.currentMaxDashboardIndex];
    
    REMWidgetCellViewController *cellController=collectionController.childViewControllers[collectionController.currentMaxWidgetIndex];
    
    
    CGRect frame=[cellController.view convertRect:cellController.view.frame fromView:destController.view];
    CGRect newFrame= CGRectMake(frame.origin.x*-1, frame.origin.y*-1, frame.size.width, frame.size.height);
    
    self.readyMoveFrame=newFrame;
    self.readyMoveView=destImageView;
    [srcController.navigationController popViewControllerAnimated:NO];
    NSTimer *timer =[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(flipToSmall) userInfo:nil repeats:NO];
    NSRunLoop *loop=[NSRunLoop currentRunLoop];
    [loop addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)flipToSmall{
    [UIView transitionWithView:self.readyMoveView duration:0.4 options:  UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^(void){
                        
                        self.readyMoveView.alpha=0;
                        
                        [self.readyMoveView setFrame:self.readyMoveFrame];
                        
                    } completion:^(BOOL finished){
                        
                        [self.readyMoveView removeFromSuperview];
                        
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
