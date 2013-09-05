//
//  REMBuildingTrendChart.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingTrendChart.h"
#import "REMToggleButtonGroup.h"

@implementation REMBuildingTrendChart

static NSString *kNoDataText = @"暂无数据";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    const int buttonHeight = 30;
    const int buttonWidth = 70;
    const int buttonMargin = 5;
    const int buttonFirstMargin = -20;
    if (self) {
        self.toggleGroup = [[REMToggleButtonGroup alloc]init];
        self.todayButton = [self makeButton:@"今天" rect:CGRectMake(buttonFirstMargin, 0, buttonWidth,buttonHeight)];
        self.yestodayButton = [self makeButton:@"昨天" rect:CGRectMake(buttonMargin + buttonWidth+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.thisMonthButton = [self makeButton:@"本月" rect:CGRectMake((buttonMargin + buttonWidth)*2+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.lastMonthButton = [self makeButton:@"上月" rect:CGRectMake((buttonMargin + buttonWidth)*3+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.thisYearButton = [self makeButton:@"今年" rect:CGRectMake((buttonMargin + buttonWidth)*4+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.lastYearButton = [self makeButton:@"去年" rect:CGRectMake((buttonMargin + buttonWidth)*5+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        
        CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight - 20)];
//        hostView.backgroundColor = [UIColor redColor];
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:frame];
        hostView.hostedGraph=graph;
//        graph.backgroundColor = [UIColor greenColor].CGColor;
        self.hostView = hostView;
        self.hostView.hidden = YES;
        
        [self addSubview:self.hostView];
        
        
        CGFloat fontSize = 36;
        CGSize labelSize = [kNoDataText sizeWithFont:[UIFont systemFontOfSize:fontSize]];
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, labelSize.width, labelSize.height)];
        self.noDataLabel.text = (NSString *)kNoDataText;
        self.noDataLabel.textColor = [UIColor whiteColor];
        self.noDataLabel.textAlignment = NSTextAlignmentLeft;
        self.noDataLabel.backgroundColor = [UIColor clearColor];
        self.noDataLabel.hidden = YES;
        [self addSubview:self.noDataLabel];
    }
    return self;
}

- (REMToggleButton*) makeButton:(NSString*)buttonText rect:(CGRect)rect{
    REMToggleButton* btn = [REMToggleButton buttonWithType: UIButtonTypeCustom];
    [btn setFrame:rect];
    btn.showsTouchWhenHighlighted = YES;
    btn.adjustsImageWhenHighlighted = YES;
    [btn setTitle:buttonText forState:UIControlStateNormal];
    //btn.backgroundColor = [UIColor redColor];
    [self addSubview:btn];
    [self.toggleGroup registerButton:btn];
    return btn;
}


@end
