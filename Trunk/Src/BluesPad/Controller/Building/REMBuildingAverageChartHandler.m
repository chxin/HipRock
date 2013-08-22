//
//  REMBuildingAverageChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "REMBuildingAverageChartHandler.h"
#import "REMBuildingAverageChart.h"
#import "REMEnergyViewData.h"
#import "REMCommodityUsageModel.h"
#import "CorePlot-CocoaTouch.h"
#import "REMDataRange.h"

@interface REMBuildingAverageChartHandler ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) REMBuildingAverageChart *chartView;
@property (nonatomic,strong) NSArray *chartData;
@property (nonatomic,strong) REMAverageUsageDataModel *averageData;

@property (nonatomic,strong) REMDataRange *dataValueRange;
@property (nonatomic,strong) REMDataRange *visiableRange;
@property (nonatomic,strong) REMDataRange *globalRange;

@end

@implementation REMBuildingAverageChartHandler


- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view = [[REMBuildingAverageChart alloc] initWithFrame:self.viewFrame];
    self.chartView = (REMBuildingAverageChart *)self.view;
    
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //UILongPressGestureRecognizer *longPressGuesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    //[self.view addGestureRecognizer:longPressGuesture];
}


- (CPTGraphHostingView*) getHostView  {
    return self.chartView.hostView;
}

-(void)longPressedAt:(NSDate*)x {
    NSLog(@"%@",[x description]);
    
    //determin x date
    NSTimeInterval pressingPoint = [x timeIntervalSince1970];
    NSArray *unitData = [self.chartData[0] objectForKey:@"data"];
    
    int index = 0;
    NSDate *pointDate = nil;
    REMDataRange *pointRange = nil;
    NSDictionary *point = nil;
    for(;index<unitData.count;index++){
        point = unitData[index];
        
        //15 day
        pointDate = [NSDate dateWithTimeIntervalSince1970: [((NSDate *)[point valueForKey:@"x"]) timeIntervalSince1970]];
        
        NSDate *upperBoundDate = [REMTimeHelper add:15 onPart:REMDateTimePartDay ofDate:pointDate];
        NSDate *lowerBoundDate = [REMTimeHelper add:-15 onPart:REMDateTimePartDay ofDate:pointDate];
        pointRange = [[REMDataRange alloc] initWithStart:[lowerBoundDate timeIntervalSince1970] andEnd:[upperBoundDate timeIntervalSince1970]];
        
        if([pointRange isValueInside:pressingPoint]){
            break;
        }
    }
    
    if(pointDate != nil){
        CPTXYAxis *horizontalAxis = ((CPTXYAxisSet *)self.chartView.graph.axisSet).xAxis;
        
        //clear the previous one tool tip
        if(self.chartView.annotationBand != nil){
            self.chartView.annotationBand = nil;
            [horizontalAxis removeBackgroundLimitBand:self.chartView.annotationBand];
        }
        
        if(self.chartView.annotation != nil)
        {
            [self.chartView.graph.plotAreaFrame.plotArea removeAllAnnotations];
            self.chartView.annotation = nil;
        }
        
        //draw lower part of the tool tip
        NSDate *bandStartDate = [REMTimeHelper add:-10 onPart:REMDateTimePartDay ofDate: pointDate];
        NSDate *bandEndDate = [REMTimeHelper add:10 onPart:REMDateTimePartDay ofDate: pointDate];
        CPTPlotRange *bandRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble([bandStartDate timeIntervalSince1970]) length:CPTDecimalFromDouble([bandEndDate timeIntervalSince1970] - [bandStartDate timeIntervalSince1970])];
        CPTLimitBand *band= [CPTLimitBand limitBandWithRange:bandRange fill:[CPTFill fillWithColor:[CPTColor lightGrayColor]]];
        [horizontalAxis addBackgroundLimitBand:band];
        
        //draw upper part of the tool tip
        CPTMutableTextStyle *tooltipTextStyle = [[CPTMutableTextStyle alloc] init];
        tooltipTextStyle.textAlignment = CPTTextAlignmentCenter;
        tooltipTextStyle.fontSize = 14.0;
         
        CPTTextLayer *layer = [[CPTTextLayer alloc] initWithText:[[point valueForKey:@"y"] stringValue]];
        layer.textStyle = tooltipTextStyle;
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        layer.bounds = CGRectMake(0, 0, 160, 40);
        layer.cornerRadius = 5;
        layer.borderColor = [UIColor redColor].CGColor;
        
        NSArray *anchorPoint = [NSArray arrayWithObjects:[NSNumber numberWithDouble:[x timeIntervalSince1970] ],@100 , nil];
        
        self.chartView.annotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:self.chartView.graph.defaultPlotSpace anchorPlotPoint:anchorPoint];
        self.chartView.annotation.contentLayer = layer;
        [self.chartView.graph.plotAreaFrame.plotArea addAnnotation:self.chartView.annotation];
    }
}



- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageData :(void (^)(void))loadCompleted
{
    if(averageData == nil)
        return;
    
    self.averageData = averageData;
    loadCompleted();
    
    //convert data
    [self convertData];
    
    //initialize plot space
    [self initializePlotSpace];
    
    //initialize axises
    [self initializeAxises];
    
    //initialize plots
    [self initializePlots];
}

- (void)initializePlotSpace
{
    //self.dataValueRange = [self.dataValueRange expandByFactor:1.1];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.globalRange.start) length:CPTDecimalFromDouble([self.globalRange distance])];
    
    //since y axis will never be able to drag, global space and visiable space for y axis are equal
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.dataValueRange.start) length:CPTDecimalFromDouble([self.dataValueRange distance])];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble([self.dataValueRange start]) length:CPTDecimalFromDouble([self.dataValueRange distance])];
}

- (void)initializeAxises
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.graph.defaultPlotSpace;
    
    //line styles
    CPTMutableLineStyle *hiddenLineStyle = [CPTMutableLineStyle lineStyle];
    hiddenLineStyle.lineWidth = 0;
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc] init];
    gridLineStyle.lineWidth = 1.0f;
    gridLineStyle.lineColor = [CPTColor whiteColor];
    
    //text styles
    CPTMutableTextStyle *axisTextStyle = [CPTMutableTextStyle textStyle];
    axisTextStyle.color = [CPTColor whiteColor];
    
    //x axis
    CPTXYAxis* x = [[CPTXYAxis alloc] init];
    [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
    
    x.coordinate = CPTCoordinateX;
    x.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    x.plotSpace = plotSpace;
    x.axisLineStyle = axisLineStyle;
    x.majorTickLineStyle = hiddenLineStyle;
    x.minorTickLineStyle = hiddenLineStyle;
    x.anchorPoint=CGPointZero;
    
    
    NSMutableSet *xlabels = [[NSMutableSet alloc] init];
    NSMutableSet *xlocations = [[NSMutableSet alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    NSDate *tickDate = [NSDate dateWithTimeIntervalSince1970:self.globalRange.start];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    while ([tickDate timeIntervalSince1970] <= self.globalRange.end) {
        tickDate = [calendar dateByAddingComponents:components toDate:tickDate options:0];
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[formatter stringFromDate:tickDate] textStyle:axisTextStyle];
        label.tickLocation = CPTDecimalFromDouble([tickDate timeIntervalSince1970]);
        //NSLog(@"date: %@",[formatter stringFromDate:tickDate]);
        
        [xlabels addObject:label];
        [xlocations addObject:[NSNumber numberWithDouble:[tickDate timeIntervalSince1970]]];
    }

    x.axisLabels = xlabels;
    x.majorTickLocations = xlocations;
    
    //y axis
    CPTXYAxis* y= [[CPTXYAxis alloc] init];
    y.coordinate = CPTCoordinateY;
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    y.plotSpace = plotSpace;
    y.axisLineStyle = axisLineStyle;
    y.majorTickLineStyle = hiddenLineStyle;
    y.minorTickLineStyle = hiddenLineStyle;
    y.anchorPoint=CGPointZero;
    
    
    y.gridLinesRange = plotSpace.yRange;
    y.majorIntervalLength = CPTDecimalFromFloat(self.dataValueRange.end/4);
    y.majorGridLineStyle = gridLineStyle;
    y.labelTextStyle = axisTextStyle;
    
    //add x and y axis into axis set
    self.chartView.graph.axisSet.axes = @[x,y];
}

- (void)initializePlots
{
    //unit - column
    CPTBarPlot *column=[[CPTBarPlot alloc] initWithFrame:self.chartView.graph.bounds];
    
    column.identifier=[self.chartData[0] objectForKey:@"identity"];
    
    column.barBasesVary=NO;
    column.barWidthsAreInViewCoordinates=YES;
    column.barWidth=CPTDecimalFromFloat(30);
    //column.barOffset=CPTDecimalFromInt(5);
    
    column.fill= [CPTFill fillWithColor:[CPTColor whiteColor]];
    
    column.baseValue=CPTDecimalFromFloat(0);
    
    column.dataSource=self;
    column.delegate=self;
    
    column.lineStyle=nil;
    column.shadow=nil;
    
    column.anchorPoint=CGPointZero;
    
    [self.chartView.graph addPlot:column];
    
    //bench mark - line (color:235,106,79)
    CPTColor *lineColor = [[CPTColor alloc] initWithCGColor:[UIColor colorWithRed:(235.0/255.0) green:(106.0/255.0) blue:(79.0/255.0) alpha:1.0].CGColor];
    
    CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = lineColor;//[CPTColor orangeColor];
    lineStyle.lineWidth = 3;
    
    CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
    labelStyle.color = [REMColor colorByIndex:1];
    
    CPTScatterPlot *line = [[CPTScatterPlot alloc] initWithFrame:self.chartView.graph.bounds];
    line.dataSource = self;
    line.identifier = [self.chartData[1] objectForKey:@"identity"];
    
    line.dataLineStyle = lineStyle;
    line.delegate = self;
    [self.chartView.graph addPlot:line];
}

- (void)convertData
{
    NSArray *energySeries = @[self.averageData.unitData.targetEnergyData[0],self.averageData.benchmarkData.targetEnergyData[0]];
    NSMutableArray *convertedData = [[NSMutableArray alloc] initWithCapacity:2];
    
    self.globalRange = [[REMDataRange alloc] initWithConstants];
    self.visiableRange = [[REMDataRange alloc] initWithConstants];
    self.dataValueRange= [[REMDataRange alloc] initWithConstants];
    
    int index = 0;
    for(REMTargetEnergyData *targetEnergyData in energySeries){
        REMEnergyTargetModel *target = targetEnergyData.target;
        NSArray *energyData = targetEnergyData.energyData;
        
        NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%llu", index, target.type, target.targetId];
        NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:energyData.count];
        
        self.visiableRange.start = MIN(self.visiableRange.start, [target.visiableTimeRange.startTime timeIntervalSince1970]);
        self.visiableRange.end = MAX(self.visiableRange.end, [target.visiableTimeRange.endTime timeIntervalSince1970]);
        
        for (int j = 0; j < energyData.count; j++)
        {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            NSDecimalNumber *value = [[NSDecimalNumber alloc] initWithDecimal:point.dataValue];
            [data addObject:@{@"y": value, @"x": point.localTime}];
            
            self.globalRange.start = MIN(self.globalRange.start, [point.localTime timeIntervalSince1970]);
            self.globalRange.end = MAX(self.globalRange.end, [point.localTime timeIntervalSince1970]);
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [value doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [value doubleValue]);
        }
        NSDictionary* series = @{ @"identity":targetIdentity, @"data":data};
        
        [convertedData addObject:series];
        index ++;
    }

    //self.globalRange.end = self.visiableRange.end;
    
    self.chartData = convertedData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data source delegate
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSUInteger records;
    
    CPTBarPlot *line = (CPTBarPlot *)plot;
    for (NSDictionary *series in self.chartData)
    {
        if([line.identifier isEqual:[series objectForKey:@"identity" ]] == YES)
        {
            records = [[series objectForKey:@"data"] count];
            break;
        }
    }
    
    //NSLog(@"line %@ has %d records.",line.identifier, records);
    
    return records;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSNumber *number;
    CPTBarPlot *line = (CPTBarPlot *)plot;
    for (NSDictionary *series in self.chartData)
    {
        if([line.identifier isEqual:[series objectForKey:@"identity" ]] == YES)
        {
            NSDictionary *point = [series objectForKey:@"data"][idx];
            
            if(fieldEnum == CPTBarPlotFieldBarLocation)
            {
                //number = [NSNumber numberWithInt: idx];//[point objectForKey:@"x"];
                number = [NSNumber numberWithDouble:[((NSDate *)[point objectForKey:@"x"]) timeIntervalSince1970]];
            }
            else
            {
                number = [point objectForKey:@"y"];
            }
            
            break;
        }
    }
    return number;
}

#pragma mark - plot space delegate
-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    return newRange;
}

@end
