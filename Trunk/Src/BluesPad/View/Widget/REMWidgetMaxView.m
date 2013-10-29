//
//  REMWidgetMaxView.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/2/13.
//
//

#import "REMWidgetMaxView.h"
#import "REMScreenEdgetGestureRecognizer.h"

@implementation REMWidgetMaxView {
    UIView* contentView;
    REMEnergyViewData *chartData;
    REMAbstractChartWrapper* widgetWrapper;
    UIButton* backBtn;
    UIView* slideView;
    UIView* overImageView;
    UIImageView*  basicImageView;
}

const int kSlideWidth = 100;
const int kSlideMovementWith = 300;
const int kStatusBarHeight = 20;

- (REMModalView*)initWithSuperView:(UIView*)superView widgetCell:(REMDashboardCollectionCellView*)widgetCell
{
    self = [super initWithSuperView:superView];
    if (self) {
        _widgetInfo = widgetCell.widgetInfo;
        chartData = widgetCell.chartData;
        self.currentWidgetCell = widgetCell;
        
        REMScreenEdgetGestureRecognizer *rec = [[REMScreenEdgetGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
        [self addGestureRecognizer:rec];
        rec.delegate = self;
    }
    return self;
}

- (void)close:(BOOL)fadeOut {
    [widgetWrapper destroyView];
    if (fadeOut) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        CGFloat contentViewX = contentView.frame.origin.x;
        UIViewAnimationOptions option = UIViewAnimationOptionTransitionFlipFromLeft;
        if (contentViewX == 0) {
            option = UIViewAnimationOptionTransitionNone;
        } else if ((orientation == UIInterfaceOrientationLandscapeLeft && contentViewX < 0) || (orientation == UIInterfaceOrientationLandscapeRight && contentViewX > 0)) {
            option = UIViewAnimationOptionTransitionFlipFromRight;
        } else {
            option = UIViewAnimationOptionTransitionFlipFromLeft;
        }
        [UIView transitionWithView:contentView duration:0.4f options:option animations:^() {
            self.alpha = 0;
            contentView.frame = [self.currentWidgetCell convertRect:self.currentWidgetCell.bounds toView:self];
        }completion:^(BOOL finished) {
            if (finished) [self removeFromSuperview];
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
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    NSMutableDictionary* style = [[NSMutableDictionary alloc]init];
//    self.userInteraction = ([dictionary[@"userInteraction"] isEqualToString:@"YES"]) ? YES : NO;
    //    self.series = dictionary[@"series"];
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    [style setObject:@"YES" forKey:@"userInteraction"];
    [style setObject:@(0.05) forKey:@"animationDuration"];
    [style setObject:gridlineStyle forKey:@"xLineStyle"];
    [style setObject:textStyle forKey:@"xTextStyle"];
//    [style setObject:nil forKey:@"xGridlineStyle"];
//    [style setObject:nil forKey:@"yLineStyle"];
    [style setObject:textStyle forKey:@"yTextStyle"];
    [style setObject:gridlineStyle forKey:@"yGridlineStyle"];
    [style setObject:@(6) forKey:@"horizentalGridLineAmount"];
    
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[REMStackColumnWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    }
    if (widgetWrapper != nil) {
        [contentView addSubview:widgetWrapper.view];
    }
}

-(void)renderContentView {
    
    CGRect fff =[self.currentWidgetCell convertRect:self.currentWidgetCell.bounds toView:[UIApplication sharedApplication].keyWindow];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat x, y;
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        x = fff.origin.y;
        y = 768 - fff.origin.x - kStatusBarHeight - self.currentWidgetCell.frame.size.height;
    } else {
        x = (1024-fff.origin.y-self.currentWidgetCell.frame.size.width);
        y = fff.origin.x - kStatusBarHeight;
    }
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(x, y, self.currentWidgetCell.frame.size.width, self.currentWidgetCell.frame.size.height)];
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
}

- (void)backButtonPressed:(UIButton *)button {
    [self close:YES];
}

-(void)panthis:(REMScreenEdgetGestureRecognizer*)pan {
    UIGestureRecognizerState gstate = pan.state;
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint startPoint = [self convertPoint:pan.eventStartPoint fromView:[UIApplication sharedApplication].keyWindow];
    CGFloat movementX = currentPoint.x - startPoint.x;
    CGFloat movementOfSlide = movementX / kSlideMovementWith * kSlideWidth;
    if (gstate == UIGestureRecognizerStatePossible || gstate == UIGestureRecognizerStateBegan || gstate == UIGestureRecognizerStateChanged) {
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
            contentView.frame = CGRectMake(movementOfSlide, 0, contentView.frame.size.width, contentView.frame.size.height);
            slideView.frame = CGRectMake((movementOfSlide < 0) ? (1024 + movementOfSlide) : 0, 0, abs(movementOfSlide), contentView.frame.size.height);
            basicImageView.frame = CGRectMake((slideView.frame.size.width-basicImageView.frame.size.width)/2, basicImageView.frame.origin.y, basicImageView.frame.size.width, basicImageView.frame.size.height);
            overImageView.frame = CGRectMake(basicImageView.frame.origin.x, basicImageView.frame.origin.y, basicImageView.frame.size.width / kSlideMovementWith * abs(movementX), basicImageView.frame.size.height);
        }
        return;
    } else if (gstate == UIGestureRecognizerStateEnded && abs(movementX) >= kSlideMovementWith) {
        [slideView removeFromSuperview];
        [self close:YES];
        return;
    } else {
        [UIView animateWithDuration:0.4f animations:^() {
            contentView.frame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
            if (slideView && slideView.superview == self) {
                slideView.frame = CGRectMake((movementOfSlide < 0) ? 1024 : 0, 0, 0, contentView.frame.size.height);
                basicImageView.frame = CGRectMake(-basicImageView.frame.size.width/2, basicImageView.frame.origin.y, basicImageView.frame.size.width, basicImageView.frame.size.height);
                overImageView.frame = CGRectMake(-basicImageView.frame.size.width/2, basicImageView.frame.origin.y, 0, basicImageView.frame.size.height);
            }
        } completion:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !CGRectContainsPoint(backBtn.frame, [touch locationInView:contentView]);
}

@end
