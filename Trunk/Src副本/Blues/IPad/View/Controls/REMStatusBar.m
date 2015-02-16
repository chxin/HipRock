/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMStatusBar.m
 * Created      : Zilong-Oscar.Xu on 8/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMStatusBar.h"
#import "REMCommonHeaders.h"


//#define kFontSC "STHeitiSC-Medium"

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
            l.font = [REMFont defaultFontOfSize:15];  // [UIFont fontWithName:@(kFontSC) size:15];
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
    [REMStatusBar showStatusMessage:message autoHide:YES];
}
+ (void)showStatusMessage:(NSString *)message autoHide:(BOOL)autoHide{
    REMStatusBar* instance = [REMStatusBar getInstance];
    
    instance.hidden = NO;
    [instance changeMessge:message autoHide:autoHide];
}

-(void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (self.hidden) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
}

- (void)screenDidRotate:(NSNotification *)notification {
    BOOL caTransationState = CATransaction.disableActions;
    [CATransaction setDisableActions:YES];
    [self resetOrientation];
    [CATransaction setDisableActions:caTransationState];
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
        UILabel *label=labels[i];
        [label setTransform:CGAffineTransformMakeRotation(M_PI * (rotate) / 180.0)];
    }
    CGRect tempRect = topRect;
    topRect = bottomRect;
    bottomRect = tempRect;
}

- (void)changeMessge:(NSString *)message autoHide:(BOOL)autoHide{
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
            if (autoHide) {
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    self.hidden = YES;
                    [willHide setText:@""];
                    [willShow setText:@""];
                });
            }
        }
    }];
}
@end
