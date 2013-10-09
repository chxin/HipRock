//
//  REMMapToBuildingSegue.m
//  Blues
//
//  Created by 张 锋 on 10/8/13.
//
//

#import "REMMapBuildingSegue.h"
#import "REMSegues.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingViewController.h"
#import "REMMapViewController.h"

@implementation REMMapBuildingSegue

- (id) initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
	if (self) {
		self.isUnWinding = [identifier isEqualToString:kBuildingToMapSegue];
	}
    
	return self;
}


- (void)perform
{
    REMMapViewController *mapViewController = self.isUnWinding == YES ? self.destinationViewController : self.sourceViewController;
    REMBuildingViewController *buildingViewController = self.isUnWinding == YES ? self.sourceViewController : self.destinationViewController;
    
    UIView *mapView = mapViewController.view, *buildingView = buildingViewController.view;
    
    
    if(self.isUnWinding == NO){
        //add building view as subview into map view
        __block UIImageView *transitionView = [[UIImageView alloc] initWithImage: [self imageWithView:buildingView]];
        
        [mapView addSubview:transitionView];
        [transitionView setTransform:CGAffineTransformMakeScale(0.1,0.1)];
        [transitionView setCenter:self.originalPoint];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [transitionView setTransform:CGAffineTransformMakeScale(1.0,1.0)];
            [transitionView setCenter:CGPointMake(mapView.bounds.size.width/2, mapView.bounds.size.height/2)];
        } completion:^(BOOL finished){
            [transitionView removeFromSuperview];
            transitionView = nil;
            [mapViewController.navigationController pushViewController:buildingViewController animated:NO];
        }];
    }
    else{
        
        NSLog(@"map view subview count segue1: %d", mapView.subviews.count);
        //buildingView
        
        [buildingViewController.navigationController popViewControllerAnimated:NO];
        NSLog(@"map view subview count segue2: %d", mapView.subviews.count);
        //[destinationViewController.view addSubview:tempView];
        
//        [destinationViewController.view addSubview:sourceViewController.view];
//        [sourceViewController.view setFrame:destinationViewController.view.bounds];
//        [sourceViewController.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
//        [sourceViewController.view setCenter:CGPointMake(destinationViewController.view.bounds.size.width/2, destinationViewController.view.bounds.size.height/2)];
        
        
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//            [sourceViewController.view setTransform:CGAffineTransformMakeScale(0.1,0.1)];
//            [sourceViewController.view setCenter:self.originalPoint];
//        } completion:^(BOOL finished){
//            [sourceViewController.view removeFromSuperview];
//        }];
    }
    
//    [src presentViewController:dst animated:NO completion:nil];
//    [src.navigationController pushViewController:dst animated:NO];
//    [src.navigationController presentViewController:dst animated:NO completion:nil];
    
//    if(self.isUnWinding)
//        [src.navigationController popViewControllerAnimated:NO];
//    else
//        [src.navigationController pushViewController:dst animated:NO];
//    [src presentViewController:dst animated:NO completion:nil];
    
    
}


- (CGAffineTransform)translatedAndScaledTransformUsingViewRect:(CGRect)viewRect fromRect:(CGRect)fromRect {
    CGSize scales = CGSizeMake(viewRect.size.width/fromRect.size.width, viewRect.size.height/fromRect.size.height);
    CGPoint offset = CGPointMake(CGRectGetMidX(viewRect) - CGRectGetMidX(fromRect), CGRectGetMidY(viewRect) - CGRectGetMidY(fromRect));
    
    return CGAffineTransformMake(scales.width, 0, 0, scales.height, offset.x, offset.y);
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
