/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTrendChartHandler.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingTrendChart.h"
#import "REMWidgetAxisHelper.h"
#import "REMBuildingTimeRangeDataModel.h"
#import "REMTimeHelper.h"
#import "REMBuildingChartSeriesIndicator.h"

@interface REMBuildingTrendChartViewController () {
    int currentSourceIndex; // Indicate that which button was pressed down.
}

@property (nonatomic) CGRect viewFrame;
@property (nonatomic, assign) BOOL loadDataSuccess;
@end

@implementation REMBuildingTrendChartViewController


-(void)activedButtonChanged:(UIButton*)newButton {
    [self intervalChanged:newButton];
}

- (void)loadView
{
    self.loadDataSuccess = NO;
    // Custom initialization
    REMBuildingTrendChart* myView = [[REMBuildingTrendChart alloc] initWithFrame:self.viewFrame];
    
    currentSourceIndex = 0;
//    myView.hostView.hostedGraph.defaultPlotSpace.delegate = self;
//    
    myView.toggleGroup.delegate = self;
//
//    
//    
    self.view = myView;
//    self.graph = (CPTXYGraph*)myView.hostView.hostedGraph;
//    
//    
//    self.graph.plotAreaFrame.masksToBorder = NO;
//    self.graph.defaultPlotSpace.allowsUserInteraction = NO;
//    
//    self.graph.paddingTop = 18.0;
//    self.graph.paddingLeft = 56.0;
//    self.graph.paddingBottom = 0.0;
//    self.graph.paddingRight = 0.0;
//    
//    self.graph.plotAreaFrame.paddingTop=0.0f;
//    self.graph.plotAreaFrame.paddingRight=0.0f;
//    self.graph.plotAreaFrame.paddingBottom=1.0f;
//    self.graph.plotAreaFrame.paddingLeft=1.0f;
//    
//    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.graph.axisSet;
//    CPTXYAxis* x = axisSet.xAxis;
//    [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
//    x.majorTickLineStyle = [self hiddenLineStyle];
//    x.majorTickLength = 0;
//    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
//    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
//    x.axisLineStyle = [self axisLineStyle];
//    x.majorGridLineStyle = [self gridLineStyle];
//    x.plotSpace = self.graph.defaultPlotSpace;
//    
//    CPTXYAxis* y = axisSet.yAxis;
//    [y setLabelingPolicy:CPTAxisLabelingPolicyNone];
//    y.majorTickLineStyle = [self hiddenLineStyle];
//    y.majorTickLength = 0;
//    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
//    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
//    y.axisLineStyle = [self axisLineStyle];
//    y.majorGridLineStyle = [self gridLineStyle];
//    y.plotSpace = self.graph.defaultPlotSpace;
    
}


- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.viewFrame = frame;
        self.requestUrl=REMDSBuildingTimeRangeData;
        self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
    }
    return self;
}

- (CPTGraphHostingView*) getHostView {
    return nil;
    // return ((REMBuildingTrendChart*)self.view).hostView;
}

-(void)prepareShare {
    if (currentSourceIndex != 2) {
        REMToggleButton* activeBtn = nil;
        REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
        if (currentSourceIndex == 0) {
            activeBtn = myView.todayButton;
        } else if (currentSourceIndex == 1) {
            activeBtn = myView.yestodayButton;
        } else if (currentSourceIndex == 2) {
            activeBtn = myView.thisMonthButton;
        } else if (currentSourceIndex == 3) {
            activeBtn = myView.lastMonthButton;
        } else if (currentSourceIndex == 4) {
            activeBtn = myView.thisYearButton;
        } else if (currentSourceIndex == 5) {
            activeBtn = myView.lastYearButton;
        }
        [myView.thisMonthButton setOn:YES];
        [activeBtn setOn:NO];
        [self intervalChanged:myView.thisMonthButton];
    }
}

- (int)getSourceIndex: (REMRelativeTimeRangeType)type {
    int i = 0;
    
    if (type == REMRelativeTimeRangeTypeToday) {
        i = 0;
    } else if (type == REMRelativeTimeRangeTypeYesterday) {
        i = 1;
    } else if (type == REMRelativeTimeRangeTypeThisMonth) {
        i = 2;
    } else if (type == REMRelativeTimeRangeTypeLastMonth) {
        i = 3;
    } else if (type == REMRelativeTimeRangeTypeThisYear) {
        i = 4;
    } else if (type == REMRelativeTimeRangeTypeLastYear) {
        i = 5;
    }
    
    return i;
}

- (CPTAxisLabel*)makeXLabel:(NSString*)labelText  location:(float)location labelStyle:(CPTTextStyle*)style {
    CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:labelText textStyle:style];
    label.tickLocation= CPTDecimalFromFloat(location);
    label.offset=5;
    return label;
}



- (void)intervalChanged:(UIButton *)button {
    if (!self.loadDataSuccess) return;
    REMRelativeTimeRangeType timeRange = REMRelativeTimeRangeTypeToday;
    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
    if (button == myView.todayButton) {
        timeRange = REMRelativeTimeRangeTypeToday;
    } else if (button == myView.yestodayButton) {
        timeRange = REMRelativeTimeRangeTypeYesterday;
    } else if (button == myView.thisMonthButton) {
        timeRange = REMRelativeTimeRangeTypeThisMonth;
    } else if (button == myView.lastMonthButton) {
        timeRange = REMRelativeTimeRangeTypeLastMonth;
    } else if (button == myView.thisYearButton) {
        timeRange = REMRelativeTimeRangeTypeThisYear;
    } else if (button == myView.lastYearButton) {
        timeRange = REMRelativeTimeRangeTypeLastYear;
    }
    currentSourceIndex = [self getSourceIndex:timeRange];
    
    REMBuildingTimeRangeDataModel* seriesArray = [self.datasource objectAtIndex:currentSourceIndex];
    int pointCount = 0;
    for (int i = 0; i < seriesArray.timeRangeData.targetEnergyData.count; i++) {
        REMTargetEnergyData* s = seriesArray.timeRangeData.targetEnergyData[i];
        pointCount+= s.energyData.count;
    }
    if (pointCount == 0) {
        myView.chartView.hidden = YES;
        myView.noDataLabel.hidden = NO;
        myView.legendView.hidden = YES;
        //[self drawNoDataLabel];
        return;
    }

    myView.noDataLabel.hidden = YES;
    myView.legendView.hidden = NO;
    REMEnergyStep step = currentSourceIndex < 2 ? REMEnergyStepHour : (currentSourceIndex < 4 ? REMEnergyStepDay : REMEnergyStepMonth);
    [myView redrawWith:self.datasource[currentSourceIndex] step:step timeRangeType:timeRange];
    
//    for (NSDictionary* series in seriesArray) {
    
//        scatterPlot = [[CPTScatterPlot alloc] initWithFrame: myView.hostView.hostedGraph.bounds];
//        scatterPlot.plotSpace = myView.hostView.hostedGraph.defaultPlotSpace;
//        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
//        scatterStyle.lineColor = [series objectForKey:@"color"];
//        scatterStyle.lineWidth = 2;
//        
//        CPTMutableLineStyle* symbolLineStyle = [CPTMutableLineStyle lineStyle];
//        symbolLineStyle.lineWidth = 0;
//        CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
//        symbol.lineStyle=symbolLineStyle;
//        symbol.size = CGSizeMake(12.0, 12.0);
//        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
//        scatterPlot.plotSymbol=symbol;
//        
//        scatterPlot.dataLineStyle = scatterStyle;
//        [scatterPlot addAnimation:[self columnAnimation] forKey:@"y"];
//        
//        scatterPlot.delegate = self;
//        scatterPlot.dataSource = self;
//        scatterPlot.identifier = [series objectForKey:@"identity"];
//        [myView.hostView.hostedGraph addPlot:scatterPlot];
        
//        CGFloat fontSize = 14;
//        CPTColor* color = [series objectForKey:@"color"];
//        // Draw legend
//        NSString* legendText = [series objectForKey:@"name"];
//        CGSize textSize = [legendText sizeWithFont:[UIFont systemFontOfSize:fontSize]];
//        CGFloat benchmarkWidth = textSize.width + 26;
//        CGRect benchmarkFrame = CGRectMake(legendLeft, legendTop, benchmarkWidth, MAX(textSize.height, 15));
//        legendLeft = legendLeft + benchmarkWidth + labelDistance;
//        if (legendLeft > myView.legendView.bounds.size.width) {
//            legendLeft = 57;
//            legendTop += 14*2;
//        }
//        REMBuildingChartSeriesIndicator *benchmarkIndicator = [[REMBuildingChartSeriesIndicator alloc] initWithFrame:benchmarkFrame title:legendText andColor:color.uiColor];
//        [myView.legendView addSubview:benchmarkIndicator];
//    }
//    [myView.hostView.hostedGraph reloadData];
}

- (void)drawToolTip: (NSInteger)index {
//    [self.graph removeAllAnnotations];
//    
//    CPTScatterPlot* plot = [[self getHostView].hostedGraph.allPlots objectAtIndex:0];
//    NSNumber *xValue = [plot cachedNumberForField:CPTScatterPlotFieldX recordIndex:index];
//    
//    CPTPlotRange *yRange   = [plot.plotSpace plotRangeForCoordinate:CPTCoordinateY];
//    CPTPlotSpaceAnnotation* annotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:plot.graph.defaultPlotSpace anchorPlotPoint:[NSArray arrayWithObjects:xValue,[ NSNumber numberWithFloat:yRange.maxLimitDouble ], nil]];
//    annotation.displacement = CPTPointMake(0.0, plot.labelOffset);
//    NSDictionary *item=[[self.datasource objectAtIndex:currentSourceIndex] objectForKey:@"data"][index];
//    NSDate* xDate = [item objectForKey:@"x"];
//    NSNumber* yVal = [item objectForKey:@"y"];
//    CPTTextLayer* textLayer = [[CPTTextLayer alloc]initWithText: [NSString stringWithFormat: @"x:%@ \ry:%@", xDate, yVal ]];
//    textLayer.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1]];
//    annotation.contentLayer = textLayer;
//    
//    CPTPlotSpaceAnnotation* lineAnno = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:plot.graph.defaultPlotSpace anchorPlotPoint:[NSArray arrayWithObjects:xValue,[ NSNumber numberWithFloat:yRange.maxLimitDouble / 2 ], nil]];
//    //lineAnno.displacement = CPTPointMake(0.0, plot.labelOffset);
//    
//    lineAnno.displacement = CGPointMake(0, (plot.graph.frame.size.height - plot.frame.size.height) / 2 - 15);
//    CPTLayer* lineLayer = [[CPTLayer alloc]initWithFrame:CGRectMake(0, 0, 1, plot.frame.size.height)];
//    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
//    lineAnno.contentLayer = lineLayer;
//    [self.graph addAnnotation:lineAnno];
//    [self.graph addAnnotation:annotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    NSMutableDictionary *buildingCommodityInfo = [[NSMutableDictionary alloc] init];
    //    self.buildingInfo.building.buildingId
    [buildingCommodityInfo setValue:[NSNumber numberWithLong: buildingId] forKey:@"buildingId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithLong:commodityID] forKey:@"commodityId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:1] forKey:@"relativeType"];
    
    return buildingCommodityInfo;
}

- (void)loadDataSuccessWithData:(id)data
{
    self.loadDataSuccess = YES;

    for(NSDictionary *item in (NSArray *)data){
        REMBuildingTimeRangeDataModel* dataItem = [[REMBuildingTimeRangeDataModel alloc] initWithDictionary:item];
        int index = [self getSourceIndex:dataItem.timeRangeType];
        [self.datasource setObject:dataItem atIndexedSubscript:index];
    }
    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
    [myView.thisMonthButton setOn:YES];
    [self intervalChanged:myView.thisMonthButton];
    
}

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error {
    self.loadDataSuccess = NO;
    if (self.datasource.count != 6) {
        for (int i = 0; i < 6; i++) {
            NSMutableDictionary* series = [[NSMutableDictionary alloc] init];
            [series setValue:[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1] forKey:@"color"];
            [self.datasource addObject:series];
        }
    }
    
    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
    [myView.thisMonthButton setOn:YES];
    [self intervalChanged:myView.thisMonthButton];
    
    [self drawLabelWithText:NSLocalizedString(@"BuildingChart_DataError",@"")];
}

@end
