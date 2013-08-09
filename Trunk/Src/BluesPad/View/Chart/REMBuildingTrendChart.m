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
    self.backgroundColor = [UIColor redColor];
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
        
        CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, buttonHeight, self.frame.size.width, self.frame.size.height - buttonHeight)];
        hostView.backgroundColor = [UIColor redColor];
        
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:frame];
        hostView.hostedGraph=graph;
        self.hostView = hostView;
        
        self.scatterPlot = [[CPTScatterPlot alloc] initWithFrame:self.hostView.hostedGraph.bounds];
        CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
        labelStyle.color = [REMColor colorByIndex:0];
        
        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
        scatterStyle.lineColor = [REMColor colorByIndex:0];
        scatterStyle.lineWidth = 1;
        self.scatterPlot.labelTextStyle = labelStyle;
        
        CPTPlotSymbol *symbol = [CPTPlotSymbol diamondPlotSymbol];
        symbol.lineStyle=scatterStyle;
        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
        
        symbol.size=CGSizeMake(7.0, 7.0);
        self.scatterPlot.plotSymbol=symbol;
        
        
        self.scatterPlot.dataLineStyle = scatterStyle;
       // [scatterPlot addAnimation:[self.chartController columnAnimation] forKey:@"y"];
        [self.hostView.hostedGraph addPlot:self.scatterPlot];
        
        [self addSubview:self.hostView];
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
    RelativeTimeRangeType t = Today;
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

- (void) retrieveEnergyData:(RelativeTimeRangeType)type
{
    NSMutableDictionary *buildingCommodityInfo = [[NSMutableDictionary alloc] init];
    //    self.buildingInfo.building.buildingId
    [buildingCommodityInfo setValue:self.buildingInfo.building.buildingId forKey:@"buildingId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:2] forKey:@"commodityId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:type] forKey:@"relativeType"];
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSEnergyBuildingTimeRange parameter:buildingCommodityInfo];
    store.isAccessLocal = YES;
    store.isStoreLocal = YES;
    store.maskContainer = self.hostView;
    store.groupName = nil;
    
    void (^retrieveSuccess)(id data)=^(id data) {
      //  [self.chartController changeData:[[REMEnergyViewData alloc] initWithDictionary:(NSDictionary *)data]];
    };
    void (^retrieveError)(NSError *error, id response) = ^(NSError *error, id response) {
        //self.widgetTitle.text = [NSString stringWithFormat:@"Error: %@",error.description];
    };
    
    
    [REMDataAccessor access:store success:retrieveSuccess error:retrieveError];
}


@end
