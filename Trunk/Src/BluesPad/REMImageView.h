//
//  REMImageView.h
//  TestImage
//
//  Created by 谭 坦 on 7/23/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMBuildingDataView.h"
#import "REMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import "REMImageHelper.h"


@interface REMImageView : UIView <UIGestureRecognizerDelegate>

- (id) initWithFrame:(CGRect)frame WithImageName:(NSString *)name;

- (void)scrollUp;

- (void)scrollDown;

- (void)move:(CGFloat)y;

- (void)moveEnd;

- (void)moveEndByVelocity:(CGFloat)y;

- (void)tapthis;

@end
