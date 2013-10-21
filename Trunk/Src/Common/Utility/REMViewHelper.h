//
//  REMViewHelper.h
//  Blues
//
//  Created by 张 锋 on 10/18/13.
//
//

#import <Foundation/Foundation.h>

@interface REMViewHelper : NSObject

+(CGAffineTransform)getScaleTransformFromOriginalFrame:(CGRect)originalFrame andFinalFrame:(CGRect)finalFrame;

+(CGPoint)getCenterOfRect:(CGRect)rect;

@end
