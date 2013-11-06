/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMViewHelper.h
 * Created      : 张 锋 on 10/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

@interface REMViewHelper : NSObject

+(CGAffineTransform)getScaleTransformFromOriginalFrame:(CGRect)originalFrame andFinalFrame:(CGRect)finalFrame;

+(CGPoint)getCenterOfRect:(CGRect)rect;

+(CGRect)getFrame:(CGRect)frame ofView:(UIView *)view inAncestorView:(UIView *)ancestorView;

@end
