//
//  REMBuildingTrendView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/8/13.
//
//

#import "REMBuildingTrendView.h"

#import <Foundation/Foundation.h>
#import "REMWidgetCellViewController.h"
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetAxisHelper.h"
#import "REMBuildingTrendChartController.h"

@implementation REMBuildingTrendView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    const int buttonHeight = 30;
    const int buttonWidth = 50;
    const int buttonMargin = 5;
    if (self) {
        self.todayButton = [self makeButton:@"今天" rect:CGRectMake(0, 0, buttonWidth,buttonHeight)];
        self.yestodayButton = [self makeButton:@"昨天" rect:CGRectMake(buttonMargin + buttonWidth,0,buttonWidth,buttonHeight)];
        self.thisMonthButton = [self makeButton:@"本月" rect:CGRectMake((buttonMargin + buttonWidth)*2,0,buttonWidth,buttonHeight)];
        self.lastMonthButton = [self makeButton:@"上月" rect:CGRectMake((buttonMargin + buttonWidth)*3,0,buttonWidth,buttonHeight)];
        self.thisYearButton = [self makeButton:@"今年" rect:CGRectMake((buttonMargin + buttonWidth)*4,0,buttonWidth,buttonHeight)];
        self.lastYearButton = [self makeButton:@"去年" rect:CGRectMake((buttonMargin + buttonWidth)*5,0,buttonWidth,buttonHeight)];
        
        self.chartController = [[REMBuildingTrendChartController alloc]init];
        self.chartController.view = self;
        [self.chartController initLineChart:CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight)];
        
        [self addSubview:self.chartController.hostView];
    }
    return self;
}

- (UIButton*) makeButton:(NSString*)buttonText rect:(CGRect)rect{
    UIButton* btn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [btn setFrame:rect];
    [btn setTitle:buttonText forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    return btn;
}

- (void)intervalChanged:(UIButton *)button {
    REMRelativeTimeRangeType t = Today;
    if (button == self.todayButton) {
        t = Today;
    } else if (button == self.yestodayButton) {
        t = Yesterday;
    } else if (button == self.thisMonthButton) {
        t = ThisMonth;
    } else if (button == self.lastMonthButton) {
        t = LastMonth;
    } else if (button == self.thisYearButton) {
        t = ThisYear;
    } else if (button == self.lastYearButton) {
        t = LastYear;
    }
    [self retrieveEnergyData:t];
}

- (void) retrieveEnergyData:(REMRelativeTimeRangeType)type
{
    NSMutableDictionary *buildingCommodityInfo = [[NSMutableDictionary alloc] init];
//    self.buildingInfo.building.buildingId
    [buildingCommodityInfo setValue:self.buildingInfo.building.buildingId forKey:@"buildingId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:2] forKey:@"commodityId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:type] forKey:@"relativeType"];
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSEnergyBuildingTimeRange parameter:buildingCommodityInfo];
    store.isAccessLocal = YES;
    store.isStoreLocal = YES;
    store.maskContainer = self.chartController.hostView;
    store.groupName = nil;
    
    void (^retrieveSuccess)(id data)=^(id data) {
        [self.chartController changeData:[[REMEnergyViewData alloc] initWithDictionary:(NSDictionary *)data]];
    };
    void (^retrieveError)(NSError *error, id response) = ^(NSError *error, id response) {
        //self.widgetTitle.text = [NSString stringWithFormat:@"Error: %@",error.description];
    };
    
    
    [REMDataAccessor access:store success:retrieveSuccess error:retrieveError];
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
