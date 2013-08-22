//
//  REMBuildingTrendChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingTrendChartHandler.h"
#import "REMBuildingTrendChart.h"
#import "REMWidgetAxisHelper.h"
#import "REMBuildingTimeRangeDataModel.h"

@interface REMBuildingTrendChartHandler () {
    int currentSourceIndex; // Indicate that which button was pressed down.
}
 

@end

@implementation REMBuildingTrendChartHandler

- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        REMBuildingTrendChart* myView = [[REMBuildingTrendChart alloc] initWithFrame:frame];
        
        currentSourceIndex = 0;
        myView.hostView.hostedGraph.defaultPlotSpace.delegate = self;
        [myView.toggleGroup bindToggleChangeCallback:self selector:@selector(intervalChanged:)];
        
        self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
        
        self.view = myView;
        self.graph = (CPTXYGraph*)myView.hostView.hostedGraph;
        
        
        self.graph.plotAreaFrame.masksToBorder = NO;
        self.graph.defaultPlotSpace.allowsUserInteraction = NO;
        
        self.graph.plotAreaFrame.paddingTop=0.0f;
        self.graph.plotAreaFrame.paddingRight=10.0f;
        self.graph.plotAreaFrame.paddingBottom=10.0f;
        self.graph.plotAreaFrame.paddingLeft=40.0f;
        
        CPTMutableLineStyle *hiddenLineStyle = [CPTMutableLineStyle lineStyle];
        hiddenLineStyle.lineWidth = 0;
        CPTMutableLineStyle *xTickStyle = [CPTMutableLineStyle lineStyle];
        xTickStyle.lineWidth = 1;
        xTickStyle.lineColor = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
        
        CPTMutableTextStyle* labelStyle = [[CPTMutableTextStyle alloc]init];
        labelStyle.color = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
        CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.graph.axisSet;
        CPTXYAxis* x = axisSet.xAxis;
        [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
        x.majorTickLineStyle = xTickStyle;
        x.majorTickLength = 5;
        x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
        x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
        x.axisLineStyle = xTickStyle;
        CPTXYAxis* y = axisSet.yAxis;
        y.majorTickLineStyle = hiddenLineStyle;
        y.minorTickLineStyle = hiddenLineStyle;
        y.axisLineStyle = xTickStyle;
        y.labelAlignment = CPTAlignmentBottom;
        y.labelTextStyle = labelStyle;
        CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc]init];
        gridLineStyle.lineWidth=1.0f;
        gridLineStyle.lineColor=[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];;
        y.majorGridLineStyle = gridLineStyle;
        x.plotSpace = self.graph.defaultPlotSpace;
        y.plotSpace = self.graph.defaultPlotSpace;
        
        [self viewDidLoad];
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


- (int)getSourceIndex: (REMRelativeTimeRangeType)type {
    int i = 0;
    if (type == Today) {
        i = 0;
    } else if (type == Yesterday) {
        i = 1;
    } else if (type == ThisMonth) {
        i = 2;
    } else if (type == LastMonth) {
        i = 3;
    } else if (type == ThisYear) {
        i = 4;
    } else if (type == LastYear) {
        i = 5;
    }
    return i;
}

- (CPTAxisLabel*)makeXLabel:(NSString*)labelText  location:(int)location labelStyle:(CPTMutableTextStyle*)style {
    CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:labelText textStyle:style];
    label.tickLocation= CPTDecimalFromInt(location);
    label.offset=5;
    return label;
}

- (void)intervalChanged:(UIButton *)button {
    REMRelativeTimeRangeType t = Today;
    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
    if (button == myView.todayButton) {
        t = Today;
    } else if (button == myView.yestodayButton) {
        t = Yesterday;
    } else if (button == myView.thisMonthButton) {
        t = ThisMonth;
    } else if (button == myView.lastMonthButton) {
        t = LastMonth;
    } else if (button == myView.thisYearButton) {
        t = ThisYear;
    } else if (button == myView.lastYearButton) {
        t = LastYear;
    }
    
    currentSourceIndex = [self getSourceIndex:t];
    
    
    CPTMutableTextStyle* labelStyle = [[CPTMutableTextStyle alloc]init];
    labelStyle.color = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
    
    NSString* dateFormat = nil;
    int countOfX = 0;    // Max x value in datasource
    double maxY = INT64_MIN;    // Max y value of display points
    double minY = INT64_MAX;    // Min y value of display points
    
    if (t == Today || t == Yesterday) {
        dateFormat = @"%d点";
        countOfX = 24;
    } else if (t == ThisMonth || t == LastMonth) {
        dateFormat = @"%d日";
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        if (t == LastMonth) {
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setMonth: -1];
            today = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
        }
        NSRange range = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
        countOfX = range.length;
    } else {
        dateFormat = @"%d月";
        countOfX = 12;
    }
    NSMutableArray *locations = [[NSMutableArray alloc]initWithCapacity: countOfX - 1];
    NSMutableArray *tickLocations = [[NSMutableArray alloc]initWithCapacity: countOfX - 1];
    for (int i = 0; i < countOfX; i++) {
        if (t == Today || t == Yesterday) {
            [locations addObject:[self makeXLabel:[NSString stringWithFormat:dateFormat, i] location:i labelStyle:labelStyle]];
        } else {
            [locations addObject:[self makeXLabel:[NSString stringWithFormat:dateFormat, i + 1] location:i labelStyle:labelStyle]];
        }
        [tickLocations addObject:[NSNumber numberWithInt:i]];
    }
    
    NSMutableArray* data = [[self.datasource objectAtIndex:currentSourceIndex] objectForKey:@"data"];
    for (int j = 0; j < data.count; j++) {
        float y = [[data[j] objectForKey:@"y" ] floatValue];
        maxY = MAX(maxY, y);
        minY = MIN(minY, y);
    }
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.graph.axisSet;
    CPTXYAxis* x = axisSet.xAxis;
    CPTXYAxis* y = axisSet.yAxis;
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(countOfX - 1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minY) length:CPTDecimalFromFloat(maxY - minY)];
    x.axisLabels = [NSSet setWithArray:locations];
    x.majorTickLocations=[NSSet setWithArray:tickLocations];
    
    y.majorIntervalLength = CPTDecimalFromFloat((maxY - minY) / 5);
    
    CPTScatterPlot* scatterPlot = nil;
    if (self.graph.allPlots.count == 0) {
        scatterPlot = [[CPTScatterPlot alloc] initWithFrame: myView.hostView.hostedGraph.bounds];
        
        CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
        labelStyle.color = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
        scatterStyle.lineColor = [CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1];
        scatterStyle.lineWidth = 1;
        scatterPlot.labelTextStyle = labelStyle;
        
        CPTPlotSymbol *symbol = [CPTPlotSymbol diamondPlotSymbol];
        symbol.lineStyle=scatterStyle;
        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
        
        symbol.size=CGSizeMake(7.0, 7.0);
        scatterPlot.plotSymbol=symbol;
        
        scatterPlot.dataLineStyle = scatterStyle;
        [scatterPlot addAnimation:[self columnAnimation] forKey:@"y"];
        if (myView.hostView.hostedGraph.allPlots.count == 1) {
            CPTPlot* p = [myView.hostView.hostedGraph plotAtIndex:0];
            [myView.hostView.hostedGraph removePlot:p];
        }
        scatterPlot.delegate = self;
        scatterPlot.dataSource = self;
        
        [myView.hostView.hostedGraph addPlot:scatterPlot];
    } else {
        scatterPlot = [self.graph.allPlots objectAtIndex:0];
        [scatterPlot reloadData];
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

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(void))loadCompleted
{
    NSMutableDictionary *buildingCommodityInfo = [[NSMutableDictionary alloc] init];
    //    self.buildingInfo.building.buildingId
    [buildingCommodityInfo setValue:[NSNumber numberWithLong: buildingId] forKey:@"buildingId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithLong:commodityID] forKey:@"commodityId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:1] forKey:@"relativeType"];
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSBuildingTimeRangeData parameter:buildingCommodityInfo];
    store.isAccessLocal = YES;
    store.groupName = [NSString stringWithFormat:@"b-%lld-%lld", buildingId, commodityID];
    store.isStoreLocal = YES;
    store.maskContainer = self.view;
    store.groupName = nil;
    
    if (self.datasource.count != 6) {
        for (int i = 0; i < 6; i++) {
            NSMutableDictionary* series = [[NSMutableDictionary alloc] init];
            [series setValue:[CPTColor colorWithComponentRed:255 green:255 blue:255 alpha:1] forKey:@"color"];
            [self.datasource addObject:series];
        }
    }
    void (^retrieveSuccess)(id data)=^(id data) {
        for(NSDictionary *item in (NSArray *)data){
            REMBuildingTimeRangeDataModel* dataItem = [[REMBuildingTimeRangeDataModel alloc] initWithDictionary:item];
            int index = [self getSourceIndex:dataItem.timeRangeType];
            NSMutableDictionary* series = (NSMutableDictionary*) [self.datasource objectAtIndex:index];
            NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%llu", index, dataItem.timeRangeType, dataItem.timeRangeData.targetGlobalData.target.targetId];
            [series setValue:targetIdentity forKey:@"identity"];
            NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:dataItem.timeRangeData.targetEnergyData.count];
            REMTargetEnergyData* targetEData = dataItem.timeRangeData.targetEnergyData[0];
            for (int i = 0; i < targetEData.energyData.count; i++) {
                REMEnergyData* pointData = targetEData.energyData[i];
                [data addObject:@{@"y": [[NSDecimalNumber alloc]initWithDecimal: pointData.dataValue], @"x": pointData.localTime  }];
            }
            [series setValue:data forKey:@"data"];
        }
    };
    void (^retrieveError)(NSError *error, id response) = ^(NSError *error, id response) {
        //self.widgetTitle.text = [NSString stringWithFormat:@"Error: %@",error.description];
    };
    
    [REMDataAccessor access:store success:retrieveSuccess error:retrieveError];
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
    animation.delegate = self;
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
        NSDate* date = [item objectForKey:@"x"];
//        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
        return [NSNumber numberWithInteger: idx];
    }
    else
    {
        return [item objectForKey:@"y"];
    }
}

@end
