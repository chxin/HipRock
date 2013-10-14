//
//  REMWidgetMaxView.m
//  Blues
//
//  Created by TanTan on 7/2/13.
//
//

#import "REMWidgetMaxView.h"

@implementation REMWidgetMaxView {
    UIView* contentView;
    REMEnergyViewData *chartData;
}

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
    }
    return self;
}

- (void)close:(BOOL)fadeOut {
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
    REMWidgetWrapper* widget = nil;
    
    if ([widgetType isEqualToString:@"line"]) {
        widget = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax status:REMWidgetStatusMaximized];
    } else if ([widgetType isEqualToString:@"column"]) {
        widget = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax status:REMWidgetStatusMaximized];
    } else if ([widgetType isEqualToString:@"pie"]) {
        widget = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:chartData widgetContext:self.widgetInfo.contentSyntax status:REMWidgetStatusMaximized];
    }
    if (widget != nil) {
        [contentView addSubview:widget.view];
        [widget destroyView];
    }
}

-(void)renderContentView {
    contentView = [[UIView alloc]initWithFrame:self.startFrame];
    contentView.backgroundColor = [UIColor grayColor];
    [self addSubview:contentView];
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 24)];
    backBtn.backgroundColor = [UIColor grayColor];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [contentView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonPressed:(UIButton *)button {
    [self close:YES];
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
