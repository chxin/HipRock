//
//  REMViewHelper.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/18/13.
//
//

#import "REMViewHelper.h"

@implementation REMViewHelper

+(CGAffineTransform)getScaleTransformFromOriginalFrame:(CGRect)originalFrame andFinalFrame:(CGRect)finalFrame
{
    CGFloat ratio = originalFrame.size.width/finalFrame.size.width;
    //CGFloat heightRatio = originalFrame.size.height/finalFrame.size.height;
    
    return CGAffineTransformMakeScale(ratio, ratio);
}

+(CGPoint)getCenterOfRect:(CGRect)rect
{
    CGFloat x = rect.origin.x + rect.size.width/2;
    CGFloat y = rect.origin.y + rect.size.height/2;
    return CGPointMake(x, y);
}

+(CGRect)getFrame:(CGRect)frame ofView:(UIView *)view inAncestorView:(UIView *)ancestorView
{
    //NSLog(@"view:%@ frame:%@ ancestor: %@\n", [view class], NSStringFromCGRect(frame), [ancestorView class]);
    
    if ([view isEqual:ancestorView]) {
        return frame;
    }
    
    UIView *currentView = view.superview;
    CGRect frameInParentView = [currentView convertRect:frame toView:currentView.superview];
    if([currentView.superview isEqual:ancestorView])
        return frameInParentView;
    else{
        currentView = currentView.superview;
        return [REMViewHelper getFrame:frameInParentView ofView:currentView inAncestorView:ancestorView];
    }
}

@end
