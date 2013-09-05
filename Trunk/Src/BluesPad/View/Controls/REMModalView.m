//
//  REMModalView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/5/13.
//
//

#import "REMModalView.h"

@interface REMModalView ()
@property (nonatomic) BOOL rendered;
@property (nonatomic) UIView* parentView;
@end

@implementation REMModalView
- (REMModalView*)initWithSuperView:(UIView*)superView {
    self = [super initWithFrame:[self getRect]];
    if (self) {
        self.parentView = superView;
        // Initialization code
    }
    return self;
}

- (CGRect)getRect {
    return CGRectMake(0, 20, 1024, 748);
//    CGRect shareBarRect = [UIApplication sharedApplication].statusBarFrame;
//    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
//    CGFloat screen
//    float rotate = 0;
//    if (currentOrientation == UIInterfaceOrientationLandscapeLeft)
//        rotate = -90;
//    else if (currentOrientation == UIInterfaceOrientationLandscapeRight)
//        rotate = 90;
//    for (int i = 0; i < 2; i++) {
//        [labels[i] setTransform:CGAffineTransformMakeRotation(M_PI * (rotate) / 180.0)];
//    }
//    CGRect tempRect = topRect;
//    topRect = bottomRect;
//    bottomRect = tempRect;
}

-(void)show:(BOOL)fadeIn {
    if (self.rendered) {
        [self setHidden:NO];
//        [self didShow];
    } else {
        UIView* rootView = self.parentView;
        UIWindow* rootWindow = [UIApplication sharedApplication].keyWindow;
        while (rootView.superview != rootWindow) {
            rootView = rootView.superview;
        }
        UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        maskView.alpha = 0.4;
        maskView.backgroundColor = [UIColor blackColor];
        [self addSubview:maskView];
        [self renderContentView];
        self.alpha = fadeIn ? 0 : 1;
        [rootView addSubview:self];
        
        if (fadeIn) {
            [UIView animateWithDuration:0.4f animations:^() {
                self.alpha = 1;
            } completion:nil];
        } else {
            self.alpha = 1;
        }
        self.rendered = YES;
    }
}

-(void)renderContentView {
    
}

-(void)close:(BOOL)fadeOut {
    if (self.rendered) {
        if (fadeOut) {
            [UIView animateWithDuration:0.4f animations:^() {
                self.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                }
            }];
        } else {
            [self removeFromSuperview];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
