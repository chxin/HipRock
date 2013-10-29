//
//  REMMaxWidgetSegue.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 10/28/13.
//
//

#import "REMMaxWidgetSegue.h"
#import "REMBuildingViewController.h"
#import "REMWidgetMaxViewController.h"


@implementation REMMaxWidgetSegue

- (void)perform
{
    REMWidgetMaxViewController *destController=self.destinationViewController;
    
    UIView *destView = destController.view;
    
    UIImage *image=[REMImageHelper imageWithView:destView];

    UIImageView *srcImageView=[[UIImageView alloc]initWithImage:image];
     UIViewController *srcController= self.sourceViewController;
    CGRect frame=[self.origSmallCell convertRect:self.origSmallCell.frame fromView:srcController.view];
     NSLog(@"button frame:%@",NSStringFromCGRect(self.origSmallCell.frame));
    NSLog(@"frame:%@",NSStringFromCGRect(frame));
    [srcImageView setFrame:frame];

   
    [srcController.view setUserInteractionEnabled:NO];
    [srcController.view addSubview:srcImageView];
    //[destView setHidden:YES];
    [UIView transitionWithView:self.origSmallCell duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void){
        [srcImageView setFrame:destView.frame];
        
    } completion:^(BOOL finished){
        [srcImageView removeFromSuperview];
        [srcController.navigationController pushViewController:destController animated:NO];
    }];
}

@end
