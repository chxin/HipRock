//
//  REMBuildingTrendChart.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingTrendChart.h"

@implementation REMBuildingTrendChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    const int buttonHeight = 30;
    const int buttonWidth = 70;
    const int buttonMargin = 5;
    if (self) {
        self.todayButton = [self makeButton:@"今天" rect:CGRectMake(0, 0, buttonWidth,buttonHeight)];
        self.yestodayButton = [self makeButton:@"昨天" rect:CGRectMake(buttonMargin + buttonWidth,0,buttonWidth,buttonHeight)];
        self.thisMonthButton = [self makeButton:@"本月" rect:CGRectMake((buttonMargin + buttonWidth)*2,0,buttonWidth,buttonHeight)];
        self.lastMonthButton = [self makeButton:@"上月" rect:CGRectMake((buttonMargin + buttonWidth)*3,0,buttonWidth,buttonHeight)];
        self.thisYearButton = [self makeButton:@"今年" rect:CGRectMake((buttonMargin + buttonWidth)*4,0,buttonWidth,buttonHeight)];
        self.lastYearButton = [self makeButton:@"去年" rect:CGRectMake((buttonMargin + buttonWidth)*5,0,buttonWidth,buttonHeight)];
        
        CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight)];
        
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:frame];
        hostView.hostedGraph=graph;
        self.hostView = hostView;
        
        [self addSubview:self.hostView];
    }
    return self;
}

- (REMToggleButton*) makeButton:(NSString*)buttonText rect:(CGRect)rect{
    REMToggleButton* btn = [REMToggleButton buttonWithType: UIButtonTypeCustom];
    [btn setFrame:rect];
    [btn setTitle:buttonText forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}


@end
