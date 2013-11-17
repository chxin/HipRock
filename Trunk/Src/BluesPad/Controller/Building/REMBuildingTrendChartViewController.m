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

@interface REMBuildingTrendChartViewController () {
    int currentSourceIndex; // Indicate that which button was pressed down.
}

@property (nonatomic) CGRect viewFrame;

@end

@implementation REMBuildingTrendChartViewController



-(void)activedButtonChanged:(UIButton*)newButton {
    [self intervalChanged:newButton];
}

- (void)loadView
{
    
    // Custom initialization
    REMBuildingTrendChart* myView = [[REMBuildingTrendChart alloc] initWithFrame:self.viewFrame];
    
    currentSourceIndex = 0;
    myView.hostView.hostedGraph.defaultPlotSpace.delegate = self;
    
    myView.toggleGroup.delegate = self;
    
    self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
    
    self.view = myView;
    self.graph = (CPTXYGraph*)myView.hostView.hostedGraph;
    
    
    self.graph.plotAreaFrame.masksToBorder = NO;
    self.graph.defaultPlotSpace.allowsUserInteraction = NO;
    
    self.graph.paddingTop = 18.0;
    self.graph.paddingLeft = 56.0;
    self.graph.paddingBottom = 0.0;
    self.graph.paddingRight = 0.0;
    
    self.graph.plotAreaFrame.paddingTop=0.0f;
    self.graph.plotAreaFrame.paddingRight=0.0f;
    self.graph.plotAreaFrame.paddingBottom=1.0f;
    self.graph.plotAreaFrame.paddingLeft=1.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
    x.majorTickLineStyle = [self hiddenLineStyle];
    x.majorTickLength = 0;
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    x.axisLineStyle = [self axisLineStyle];
    x.majorGridLineStyle = [self gridLineStyle];
    x.plotSpace = self.graph.defaultPlotSpace;
    
    CPTXYAxis* y = axisSet.yAxis;
    //        y.majorTickLineStyle = hiddenLineStyle;
    //        y.minorTickLineStyle = hiddenLineStyle;
    //        y.axisLineStyle = xTickStyle;
    //        y.labelAlignment = CPTAlignmentMiddle;
    //        y.labelTextStyle = labelStyle;
    //        y.majorGridLineStyle = gridLineStyle;
    //        y.plotSpace = self.graph.defaultPlotSpace;
    [y setLabelingPolicy:CPTAxisLabelingPolicyNone];
    y.majorTickLineStyle = [self hiddenLineStyle];
    y.majorTickLength = 0;
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    y.axisLineStyle = [self axisLineStyle];
    y.majorGridLineStyle = [self gridLineStyle];
    y.plotSpace = self.graph.defaultPlotSpace;
    
}


- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.viewFrame = frame;
        self.requestUrl=REMDSBuildingTimeRangeData;
    }
    return self;
}

- (CPTGraphHostingView*) getHostView {
    return nil;
   // return ((REMBuildingTrendChart*)self.view).hostView;
}
-(void)longPressedAt:(NSDate*)x {
    
    NSMutableArray* data = [[self.datasource objectAtIndex:currentSourceIndex] objectForKey:@"data"];
    uint nearByPoint1Interval = UINT32_MAX;
    int nearByPointIndex = -1;
    for (int i = 0; i < data.count; i++) {
        NSDate* pointX = [[data objectAtIndex:i] objectForKey:@"x"];
        uint pointIntervalWithTouchPoint =  abs([pointX timeIntervalSinceDate:x]);
        if (pointIntervalWithTouchPoint <= nearByPoint1Interval) {
            nearByPoint1Interval = pointIntervalWithTouchPoint;
        } else {
            nearByPointIndex = i - 1;
            break;
        }
    }
    NSLog(@"Long Pressed At %@, nearby point index is %d", x, nearByPointIndex);
    
    
    [self drawToolTip: nearByPointIndex];
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
    
    NSMutableArray* data = [[self.datasource objectAtIndex:currentSourceIndex] objectForKey:@"data"];
    if (data.count == 0) {
        myView.hostView.hidden = YES;
        myView.noDataLabel.hidden = NO;
        //[self drawNoDataLabel];
        return;
    }
    
    myView.hostView.hidden = NO;
    myView.noDataLabel.hidden = YES;
    NSString* dateFormat = nil;
    int amountOfY = 5;
//    int countOfX = 0;    // Max x value in datasource
    double maxY = INT64_MIN;    // Max y value of display points
    double minY = 0;    // Min y value of display points
    for (int j = 0; j < data.count; j++) {
        NSNumber* yValObj = [data[j] objectForKey:@"y" ];
        if ([yValObj isEqual:[NSNull null]]) continue;
        float y = [yValObj floatValue];
        maxY = MAX(maxY, y);
//        minY = MIN(minY, y);
    }
    float xLabelOffset = 0;
    float xGridlineOffset = 0;
    int xLabelValOffset = 0;
    
    if (currentSourceIndex < 2) {
        dateFormat = @"%d点";
        xLabelOffset = -0.5;
        xGridlineOffset = -0.5;
        xLabelValOffset = 0;
    } else if (currentSourceIndex < 4) {
        dateFormat = @"%d日";
        xLabelOffset = 0;
        xGridlineOffset = -0.5;
        xLabelValOffset = 1;
    } else {
        dateFormat = @"%d月";
        xLabelOffset = 0;
        xGridlineOffset = -0.5;
        xLabelValOffset = 1;
    }
    
    // 临时的计算x轴gridline和tick数量的方式
    int xStep = 0;
    if (data.count < 20) {
        xStep = 1;
    } else {
        xStep = 2;
    }
    NSMutableArray *xLabelLocations = [[NSMutableArray alloc]init];
    NSMutableArray *xtickLocations = [[NSMutableArray alloc]init];
    
    int xCount = 0;
    if (currentSourceIndex == 0) {
        xCount = [REMTimeHelper getHour:[NSDate date]];
    } else if (currentSourceIndex == 1) {
        xCount = 24;
    } else if (currentSourceIndex == 2) {
        xCount = [REMTimeHelper getDay:[NSDate date]];
    } else if (currentSourceIndex == 3) {
        xCount = [REMTimeHelper getDaysOfDate:[REMTimeHelper addMonthToDate:[NSDate date] month:-1]];
    } else if (currentSourceIndex == 4) {
        xCount = [REMTimeHelper getMonth:[NSDate date]];
    } else {
        xCount = 12;
    }
    for (int i = 0; i < xCount + 1; i++) {
        if (i % xStep == 0) [xLabelLocations addObject:[self makeXLabel:[NSString stringWithFormat:dateFormat, i + xLabelValOffset] location:i+xLabelOffset labelStyle:[self xAxisLabelStyle]]];
        [xtickLocations addObject:[NSNumber numberWithFloat:i+xGridlineOffset]];
    }
    NSMutableArray *ylocations = [[NSMutableArray alloc]init];
    NSMutableArray *ytickLocations = [[NSMutableArray alloc]init];
    
    double yLength = maxY - minY;
    double yInterval = 0;
    if (yLength > 0) {
        double mag = 1;
        double yIntervalMag = yLength / amountOfY;
        while (yIntervalMag > 10) {
            yIntervalMag /= 10;
            mag *= 10;
        }
        while (yIntervalMag < 1) {
            yIntervalMag *= 10;
            mag /= 10;
        }
        yInterval = ceil(yIntervalMag * 2) * mag / 2;
    } else {
        yInterval = 1;
    }
    float yRangeLength = yInterval * (amountOfY + 0.2);
    int yLocationStart = minY / yInterval;
    yLocationStart *= yInterval;
    NSNumberFormatter* yFormatter = [[NSNumberFormatter alloc]init];
    yFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    for (float i = yLocationStart; i < minY + yRangeLength; i = i + yInterval) {
        NSString* ylabelText = [self formatDataValue:[NSNumber numberWithDouble:i]];
        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:ylabelText textStyle:[self yAxisLabelStyle]];
        label.offset = 5;
        label.tickLocation= CPTDecimalFromFloat(i);
        [ylocations addObject:label];
        if (i != 0) [ytickLocations addObject:[NSNumber numberWithFloat:i]];
    }
    
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    CPTXYAxis* y = axisSet.yAxis;
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(-0.5) length:CPTDecimalFromInt(xCount)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minY) length:CPTDecimalFromFloat(yRangeLength)];
    x.axisLabels = [NSSet setWithArray:xLabelLocations];
    x.majorTickLocations=[NSSet setWithArray:xtickLocations];
//    x.majorIntervalLength = CPTDecimalFromInt(xStep);
    
    y.axisLabels = [NSSet setWithArray:ylocations];
    y.majorTickLocations=[NSSet setWithArray:ytickLocations];
//    y.majorIntervalLength = CPTDecimalFromFloat((maxY - minY) / 5);
    
    CPTScatterPlot* scatterPlot = nil;
    if (self.graph.allPlots.count == 0) {
        scatterPlot = [[CPTScatterPlot alloc] initWithFrame: myView.hostView.hostedGraph.bounds];
        
//        CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
//        labelStyle.color = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
        scatterStyle.lineColor = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:.7];
        scatterStyle.lineWidth = 2;
//        scatterPlot.labelTextStyle = labelStyle;
        
        CPTMutableLineStyle* symbolLineStyle = [CPTMutableLineStyle lineStyle];
        symbolLineStyle.lineWidth = 0;
        CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
        symbol.lineStyle=symbolLineStyle;
        symbol.size = CGSizeMake(12.0, 12.0);
//        symbol.lineStyle
        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
        scatterPlot.plotSymbol=symbol;
        
        scatterPlot.dataLineStyle = scatterStyle;
        [scatterPlot addAnimation:[self columnAnimation] forKey:@"y"];
        if (myView.hostView.hostedGraph.allPlots.count == 1) {
            CPTPlot* p = [myView.hostView.hostedGraph plotAtIndex:0];
            [myView.hostView.hostedGraph removePlot:p];
        }
        scatterPlot.delegate = self;
        scatterPlot.dataSource = self;
        
        //self.graph.plotAreaFrame.paddingLeft=100.0f;
        [myView.hostView.hostedGraph addPlot:scatterPlot];
    } else {
        scatterPlot = [self.graph.allPlots objectAtIndex:0];
        [scatterPlot reloadData];
        //self.graph.plotAreaFrame.paddingLeft=100.0f;
        [myView.hostView.hostedGraph reloadData];
    }
}

- (void)drawToolTip: (NSInteger)index {
    [self.graph removeAllAnnotations];
    
    CPTScatterPlot* plot = [[self getHostView].hostedGraph.allPlots objectAtIndex:0];
    NSNumber *xValue = [plot cachedNumberForField:CPTScatterPlotFieldX recordIndex:index];
    
    CPTPlotRange *yRange   = [plot.plotSpace plotRangeForCoordinate:CPTCoordinateY];
    CPTPlotSpaceAnnotation* annotation = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:plot.graph.defaultPlotSpace anchorPlotPoint:[NSArray arrayWithObjects:xValue,[ NSNumber numberWithFloat:yRange.maxLimitDouble ], nil]];
    annotation.displacement = CPTPointMake(0.0, plot.labelOffset);
    NSDictionary *item=[[self.datasource objectAtIndex:currentSourceIndex] objectForKey:@"data"][index];
    NSDate* xDate = [item objectForKey:@"x"];
    NSNumber* yVal = [item objectForKey:@"y"];
    CPTTextLayer* textLayer = [[CPTTextLayer alloc]initWithText: [NSString stringWithFormat: @"x:%@ \ry:%@", xDate, yVal ]];
    textLayer.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1]];
    annotation.contentLayer = textLayer;
    
    CPTPlotSpaceAnnotation* lineAnno = [[CPTPlotSpaceAnnotation alloc]initWithPlotSpace:plot.graph.defaultPlotSpace anchorPlotPoint:[NSArray arrayWithObjects:xValue,[ NSNumber numberWithFloat:yRange.maxLimitDouble / 2 ], nil]];
    //lineAnno.displacement = CPTPointMake(0.0, plot.labelOffset);
    
    lineAnno.displacement = CGPointMake(0, (plot.graph.frame.size.height - plot.frame.size.height) / 2 - 15);
    CPTLayer* lineLayer = [[CPTLayer alloc]initWithFrame:CGRectMake(0, 0, 1, plot.frame.size.height)];
    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    lineAnno.contentLayer = lineLayer;
    [self.graph addAnnotation:lineAnno];
    [self.graph addAnnotation:annotation];
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
    if (self.datasource.count != 6) {
        for (int i = 0; i < 6; i++) {
            NSMutableDictionary* series = [[NSMutableDictionary alloc] init];
            [series setValue:[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1] forKey:@"color"];
            [self.datasource addObject:series];
        }
    
    
        for(NSDictionary *item in (NSArray *)data){
            REMBuildingTimeRangeDataModel* dataItem = [[REMBuildingTimeRangeDataModel alloc] initWithDictionary:item];
            int index = [self getSourceIndex:dataItem.timeRangeType];
            NSMutableDictionary* series = (NSMutableDictionary*) [self.datasource objectAtIndex:index];
            NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%@", index, dataItem.timeRangeType, dataItem.timeRangeData.targetGlobalData.target.targetId];
            [series setValue:targetIdentity forKey:@"identity"];
            NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:dataItem.timeRangeData.targetEnergyData.count];
            if(dataItem.timeRangeData.targetEnergyData.count>0){
                REMTargetEnergyData* targetEData = dataItem.timeRangeData.targetEnergyData[0];
                for (int i = 0; i < targetEData.energyData.count; i++) {
                    REMEnergyData* pointData = targetEData.energyData[i];
                    if ([pointData.dataValue isEqual:[NSNull null]] || pointData.dataValue.floatValue < 0) {
                        [data addObject:@{@"y": [NSNull null], @"x": pointData.localTime  }];
                    } else {
                        [data addObject:@{@"y": pointData.dataValue, @"x": pointData.localTime  }];
                    }
                }
                [series setValue:data forKey:@"data"];
            }
        }
    }
    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
    [myView.thisMonthButton setOn:YES];
    [self intervalChanged:myView.thisMonthButton];
    
}

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







//////////////////////////////////////////
- (CABasicAnimation *) columnAnimation
{
    //adding animation here
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [animation setDuration:0.5f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.removedOnCompletion = NO;
    //animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}


#pragma mark -
#pragma mark LineDataSource
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSDictionary* datasource = [self.datasource objectAtIndex:currentSourceIndex];
    NSMutableArray* data = [datasource objectForKey:@"data"];
    return data.count;
}



- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSDictionary* datasource = [self.datasource objectAtIndex:currentSourceIndex];
    NSMutableArray* data = [datasource objectForKey:@"data"];
    
    NSDictionary *item=data[idx];
    
    if (fieldEnum == CPTPieChartFieldSliceWidth) {
        NSDate* date =  [item objectForKey:@"x"];
       // date = [REMTimeHelper convertLocalDateToGMT:date];
        NSInteger i = 0;
        if (currentSourceIndex < 2) i = [REMTimeHelper getHour:date] + 1;
        else if (currentSourceIndex < 4) i = [REMTimeHelper getDay:date];
        else if (currentSourceIndex < 6) i = [REMTimeHelper getMonth:date];
//        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
        return [NSNumber numberWithInteger: i - 1];
    }
    else
    {
        return [item objectForKey:@"y"];
    }
}

@end
