//
//  REMViewHelper.m
//  Blues
//
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

@end
