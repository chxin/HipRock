//
//  REMViewHelper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/18/13.
//
//

#import <Foundation/Foundation.h>

@interface REMViewHelper : NSObject

+(CGAffineTransform)getScaleTransformFromOriginalFrame:(CGRect)originalFrame andFinalFrame:(CGRect)finalFrame;

+(CGPoint)getCenterOfRect:(CGRect)rect;

+(CGRect)getFrame:(CGRect)frame ofView:(UIView *)view inAncestorView:(UIView *)ancestorView;

@end
