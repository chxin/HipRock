/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTrendChart.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingTrendChart.h"
#import "REMToggleButtonGroup.h"
#import "REMChartHeader.h"
#import "REMLocalizeKeys.h"
#import "REMBuildingTrendWrapper.h"

const int buttonHeight = 30;
const int buttonWidth = 70;
const int buttonMargin = 5;
const int buttonFirstMargin = -20;

@interface REMBuildingTrendChart()
@property (nonatomic, strong) REMBuildingTrendWrapper* wrapper;
@end

@implementation REMBuildingTrendChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.toggleGroup = [[REMToggleButtonGroup alloc]init];
        self.todayButton = [self makeButton:REMLocalizedString(@"Common_Today") rect:CGRectMake(buttonFirstMargin, 0, buttonWidth,buttonHeight)];
        self.yestodayButton = [self makeButton:REMLocalizedString(@"Common_Yesterday") rect:CGRectMake(buttonMargin + buttonWidth+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.thisMonthButton = [self makeButton:REMLocalizedString(@"Common_ThisMonth") rect:CGRectMake((buttonMargin + buttonWidth)*2+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.lastMonthButton = [self makeButton:REMLocalizedString(@"Common_LastMonth") rect:CGRectMake((buttonMargin + buttonWidth)*3+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.thisYearButton = [self makeButton:REMLocalizedString(@"Common_ThisYear") rect:CGRectMake((buttonMargin + buttonWidth)*4+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        self.lastYearButton = [self makeButton:REMLocalizedString(@"Common_LastYear") rect:CGRectMake((buttonMargin + buttonWidth)*5+buttonFirstMargin,0,buttonWidth,buttonHeight)];
        
        NSString *noDataText = REMLocalizedString(kLNBuildingChart_NoData);
        CGFloat fontSize = 36;
        CGSize labelSize = [noDataText sizeWithFont:[UIFont systemFontOfSize:fontSize]];
        self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, labelSize.width, labelSize.height)];
        self.noDataLabel.text = (NSString *)noDataText;
        self.noDataLabel.textColor = [UIColor whiteColor];
        self.noDataLabel.textAlignment = NSTextAlignmentLeft;
        self.noDataLabel.backgroundColor = [UIColor clearColor];
        self.noDataLabel.hidden = YES;
        [self addSubview:self.noDataLabel];
    }
    
    self.legendView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - kBuildingTrendChartLegendHeight + 10, frame.size.width, kBuildingTrendChartLegendHeight)];
    [self addSubview: self.legendView];
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

-(void)redrawWith:(REMBuildingTimeRangeDataModel*)buildData step:(REMEnergyStep)step timeRangeType:(REMRelativeTimeRangeType)timeRangeType {
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.relativeDateType = timeRangeType;
    syntax.step = @((int)step);
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    if (self.wrapper == nil) {
        self.wrapper = [[REMBuildingTrendWrapper alloc]initWithFrame:CGRectMake(0, buttonHeight, self.frame.size.width + 22, self.frame.size.height - buttonHeight - 20 - kBuildingTrendChartLegendHeight) data:buildData.timeRangeData widgetContext:syntax style:style];
        [self addSubview:self.wrapper.view];
    } else {
        self.wrapper.timeRangeType = timeRangeType;
        [self.wrapper redraw:buildData.timeRangeData step:step];
    }
    self.chartView = self.wrapper.view;
}


@end
