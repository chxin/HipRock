//
//  REMWidgetMaxView.m
//  Blues
//
//  Created by TanTan on 7/2/13.
//
//

#import "REMWidgetMaxView.h"
#import "REMScreenEdgetGestureRecognizer.h"

@implementation REMWidgetMaxView {
    UIView* contentView;
    REMEnergyViewData *chartData;
    REMWidgetWrapper* widgetWrapper;
    UIButton* backBtn;
    UIView* slideView;
    UIView* overImageView;
    UIImageView*  basicImageView;
}

const int kSlideWidth = 100;
const int kSlideMovementWith = 300;

- (REMModalView*)initWithSuperView:(UIView*)superView widgetCell:(REMDashboardCollectionCellView*)widgetCell
{
    self = [super initWithSuperView:superView];
    if (self) {
        _widgetInfo = widgetCell.widgetInfo;
        chartData = widgetCell.chartData;
        CGRect location = [widgetCell convertRect:widgetCell.bounds toView:nil];
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        CGFloat x, y;
        x = location.origin.y;
        y = location.origin.x;
        if (orientation == UIInterfaceOrientationLandscapeRight) y = 748 - y - widgetCell.frame.size.height;
        _startFrame = CGRectMake(x, y, widgetCell.frame.size.width, widgetCell.frame.size.height);
        
        
        REMScreenEdgetGestureRecognizer *rec = [[REMScreenEdgetGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
        [self addGestureRecognizer:rec];
        rec.delegate = self;
    }
    return self;
}

- (void)close:(BOOL)fadeOut {
    [widgetWrapper destroyView];
    if (fadeOut) {
        [UIView animateWithDuration:0.4f animations:^() {
            self.alpha = 0;
            contentView.frame = self.startFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    } else {
        [super close:fadeOut];
    }
}

- (void)show:(BOOL)fadeIn {
    [super show:NO];
    if (fadeIn) {
        [UIView animateWithDuration:0.4f animations:^() {
            self.alpha = 1;
            contentView.frame = self.bounds;
        } completion:^(BOOL completed) {
            if (completed) {
                [self renderChart];
            }
        }];
    } else {
        contentView.frame = self.bounds;
        [self renderChart];
    }
}

-(void)renderChart {
    
    CGRect widgetRect = CGRectMake(0, 24, 1024, 724);
    NSString* widgetType = self.widgetInfo.contentSyntax.type;
    
    if ([widgetType isEqualToString:@"line"]) {
        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax status:REMWidgetStatusMaximized];
    } else if ([widgetType isEqualToString:@"column"]) {
        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax status:REMWidgetStatusMaximized];
    } else if ([widgetType isEqualToString:@"pie"]) {
        widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax status:REMWidgetStatusMaximized];
    }
    if (widgetWrapper != nil) {
        [contentView addSubview:widgetWrapper.view];
//        [widget destroyView];
    }
}

-(void)renderContentView {
    contentView = [[UIView alloc]initWithFrame:self.startFrame];
    contentView.backgroundColor = [UIColor grayColor];
    [self addSubview:contentView];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 24)];
    backBtn.backgroundColor = [UIColor grayColor];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [contentView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* widgetTitle = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 300, 24)];
    widgetTitle.text = self.widgetInfo.name;
    [widgetTitle setTextColor:[UIColor whiteColor]];
    widgetTitle.backgroundColor = [UIColor clearColor];
    [contentView addSubview:widgetTitle];
    
//    slideView = [[UIView alloc]init];
}

- (void)backButtonPressed:(UIButton *)button {
    [self close:YES];
}

-(void)panthis:(REMScreenEdgetGestureRecognizer*)pan {
    UIGestureRecognizerState gstate = pan.state;
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint startPoint = [self convertPoint:pan.eventStartPoint fromView:[UIApplication sharedApplication].keyWindow];
    CGFloat movementX = currentPoint.x - startPoint.x;
    if (gstate == UIGestureRecognizerStateEnded) {
        contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
        if (slideView) [slideView removeFromSuperview];
        if (abs(movementX) >= kSlideMovementWith) {
            [self close:YES];
        }
    } else if (gstate == UIGestureRecognizerStatePossible || gstate == UIGestureRecognizerStateBegan || gstate == UIGestureRecognizerStateChanged) {
        if (slideView == nil) {
            slideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
            slideView.backgroundColor = [UIColor whiteColor];
            slideView.clipsToBounds = YES;
            NSBundle* mb = [NSBundle mainBundle];
            basicImageView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[mb pathForResource:@"Oil_normal" ofType:@"png"]]];
            overImageView = [[UIView alloc]initWithFrame:CGRectMake(27, 351, 0, 45)];
            overImageView.clipsToBounds = YES;
            UIImageView* overImage = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[mb pathForResource:@"Oil_pressed" ofType:@"png"]]];
            basicImageView.frame = CGRectMake(27, 351, 45, 45);
            overImage.frame = CGRectMake(0, 0, 45, 45);
            [overImageView addSubview:overImage];
            [slideView addSubview:basicImageView];
            [slideView addSubview:overImageView];
        }
        if (slideView.superview == nil) [self addSubview:slideView];
        if (abs(movementX) <= kSlideMovementWith) {
            CGFloat movementOfSlide = movementX / kSlideMovementWith * kSlideWidth;
            slideView.frame = CGRectMake((movementOfSlide < 0) ? (1024 + movementOfSlide) : 0, 0, abs(movementOfSlide), contentView.frame.size.height);
            basicImageView.frame = CGRectMake((slideView.frame.size.width-basicImageView.frame.size.width)/2, basicImageView.frame.origin.y, basicImageView.frame.size.width, basicImageView.frame.size.height);
            contentView.frame = CGRectMake(movementOfSlide, 0, contentView.frame.size.width, contentView.frame.size.height);
            overImageView.frame = CGRectMake(basicImageView.frame.origin.x, basicImageView.frame.origin.y, basicImageView.frame.size.width / kSlideMovementWith * abs(movementX), basicImageView.frame.size.height);
        }
    } else {
        contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
        if (slideView) [slideView removeFromSuperview];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !CGRectContainsPoint(backBtn.frame, [touch locationInView:contentView]);
}

@end
