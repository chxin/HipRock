/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMapGallerySegue.m
 * Created      : 张 锋 on 10/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMMapGallerySegue.h"
#import "REMMapViewController.h"
#import "REMGalleryViewController.h"

@implementation REMMapGallerySegue

- (void)perform
{
    if([self.sourceViewController class] == [REMMapViewController class]){
        //NSLog(@"source is map");
        [UIView transitionFromView:[self.sourceViewController view] toView:[self.destinationViewController view] duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
            [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:NO];
        }];
    }
    else{
        //NSLog(@"source is gallery");
        [UIView transitionFromView:[self.sourceViewController view] toView:[self.destinationViewController view] duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished){
            [[self.sourceViewController navigationController] popViewControllerAnimated:NO];
        }];
    }
}

@end
