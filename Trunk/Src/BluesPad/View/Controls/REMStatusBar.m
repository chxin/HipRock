//
//  REMStatusBar.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/26/13.
//
//

#import "REMStatusBar.h"
#import "REMApplicationInfo.h"

@implementation REMStatusBar {
    CGRect topRect;
    CGRect middleRect;
    CGRect bottomRect;
    NSInteger currentLabelIndex;
    UIInterfaceOrientation appOrientation;
}

+(REMStatusBar*)getInstance
{
    static dispatch_once_t pred;
    static REMStatusBar *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[REMStatusBar alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    });
    return shared;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat barWidth = 1024;
        CGFloat barHeight = 20;
        
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        topRect = CGRectMake(barHeight, 0, barHeight, barWidth);
        middleRect = CGRectMake(0, 0, barHeight, barWidth);
        bottomRect = CGRectMake(-1 * barHeight, 0, barHeight, barWidth);
        if (currentOrientation == UIInterfaceOrientationLandscapeLeft) {
            CGRect tempRect = topRect;
            topRect = bottomRect;
            bottomRect = tempRect;
        }
        
        labels = [[NSMutableArray alloc]init];
        [labels addObject:[[UILabel alloc]initWithFrame:middleRect]];
        [labels addObject:[[UILabel alloc]initWithFrame:bottomRect]];
        for (int i = 0; i < 2; i++) {
            UILabel* l = labels[i];
            l.font = [UIFont fontWithName:@(kFontSC) size:15];
            [l setTextColor:[UIColor whiteColor]];
            [l setBackgroundColor:[UIColor clearColor]];
            l.textAlignment = NSTextAlignmentCenter;
            [self addSubview:l];
        }
        currentLabelIndex = 0;
        [self resetOrientation];
    }
    return self;
}
+ (void)showStatusMessage:(NSString *)message{
    REMStatusBar* instance = [REMStatusBar getInstance];

    instance.hidden = NO;
    [instance changeMessge:message];
}

- (void)resetOrientation {
    self.frame = [UIApplication sharedApplication].statusBarFrame;
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    float rotate = 0;
    if (currentOrientation == UIInterfaceOrientationLandscapeLeft)
        rotate = -90;
    else if (currentOrientation == UIInterfaceOrientationLandscapeRight)
        rotate = 90;
    for (int i = 0; i < 2; i++) {
        [labels[i] setTransform:CGAffineTransformMakeRotation(M_PI * (rotate) / 180.0)];
    }
    CGRect tempRect = topRect;
    topRect = bottomRect;
    bottomRect = tempRect;
}

- (void)changeMessge:(NSString *)message{
    if (appOrientation != [UIApplication sharedApplication].statusBarOrientation) {
        appOrientation = [UIApplication sharedApplication].statusBarOrientation;
        [self resetOrientation];
    }
    UILabel* willShow;
    UILabel* willHide;
    if (currentIndex == 0) {
        willHide = [labels objectAtIndex:0];
        willShow = [labels objectAtIndex:1];
        currentIndex = 1;
    } else {
        willHide = [labels objectAtIndex:1];
        willShow = [labels objectAtIndex:0];
        currentIndex = 0;
    }
    [willShow setText:message];
    [willShow setFrame:bottomRect];
    
    [UIView animateWithDuration:0.6f animations:^{
        [willHide setFrame:topRect];
        [willShow setFrame:middleRect];
    } completion:^(BOOL finished){
        if (finished) {
            self.hidden = YES;
            [willHide setText:@""];
            [willShow setText:@""];
        }
    }];
}
@end
