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
#import "REMChartSeriesIndicator.h"
#import "REMCommodityModel.h"



@interface REMBuildingAverageChartHandler ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic) long long commodityId;
@property (nonatomic,strong) REMBuildingAverageChart *chartView;
@property (nonatomic,strong) NSArray *chartData;
@property (nonatomic,strong) REMEnergyViewData *averageData;

@property (nonatomic,strong) REMDataRange *dataValueRange;
@property (nonatomic,strong) REMDataRange *visiableRange;
@property (nonatomic,strong) REMDataRange *globalRange;
@property (nonatomic,strong) REMDataRange *draggableRange;


@property (nonatomic,strong) REMChartHorizonalScrollDelegator *scrollManager;

@end

@implementation REMBuildingAverageChartHandler


static NSString *kBenchmarkTitle = @"目标值";
static NSString *kAverageDataTitle = @"单位面积用%@";


- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
        self.scrollManager = [[REMChartHorizonalScrollDelegator alloc]init];
        self.requestUrl=REMDSBuildingAverageData;
    }
    return self;
}

-(void)prepareShare {
    
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



- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    self.commodityId = commodityID;
    
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong:buildingId], @"commodityId":[NSNumber numberWithLongLong:commodityID]};
    
    return parameter;
}


- (void)loadDataSuccessWithData:(id)data
{
    self.averageData = [[REMEnergyViewData alloc] initWithDictionary:data];
    
    if(self.averageData!=nil){
        [self loadChart];
    }
}

- (void)loadDataFailureWithError:(REMError *)error withResponse:(id)response{
    NSString *text = NSLocalizedString(@"BuildingChart_DataError", @"");
    [self drawLabelWithText:text];
}

- (void)loadChart
{
    //convert data
    BOOL hasData = [self convertData];
    
    if(hasData == NO || self.chartData==nil || self.chartData.count<=0)
    {
        [self drawLabelWithText:NSLocalizedString(@"BuildingChart_NoData", @"")];
    }
    else
    {
        //initialize graph
        [self.chartView initializeGraph];
        
        //initialize plot space
        [self initializePlotSpace];
        
        //initialize axises
        [self initializeAxises];
        
        //initialize plots
        [self initializePlots];
        
        //draw labels
        [self drawChartLabels];
    }
}

- (void)initializePlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate=self.scrollManager;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.draggableRange.start) length:CPTDecimalFromDouble([self.draggableRange distance])];
    
    //since y axis will never be able to drag, global space and visiable space for y axis are equal
    CPTPlotRange *dataValuePlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(self.dataValueRange.end + [self.dataValueRange distance] * 0.1)];
    plotSpace.yRange = dataValuePlotRange;
    plotSpace.globalYRange = dataValuePlotRange;
    
    
    self.scrollManager.globalRange=self.globalRange;
    self.scrollManager.visiableRange=self.visiableRange;
}

- (void)initializeAxises
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.graph.defaultPlotSpace;
    
    //x axis
    CPTXYAxis* x = [[CPTXYAxis alloc] init];
    [x setLabelingPolicy:CPTAxisLabelingPolicyNone];
    
    x.coordinate = CPTCoordinateX;
    x.orthogonalCoordinateDecimal = CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    x.plotSpace = plotSpace;
    x.axisLineStyle = [self axisLineStyle];
    x.majorTickLineStyle = [self hiddenLineStyle];
    x.minorTickLineStyle = [self hiddenLineStyle];
    x.majorGridLineStyle = [self hiddenLineStyle];
    x.minorGridLineStyle = [self gridLineStyle];
    x.anchorPoint=CGPointZero;
    
    
    NSMutableSet *xlabels = [[NSMutableSet alloc] init];
    NSMutableSet *xMajorLocations = [[NSMutableSet alloc] init];
    NSMutableSet *xMinorLocations = [[NSMutableSet alloc] init];
    
    double tickMonth = self.globalRange.start+0.5;
    
    while (tickMonth <= self.globalRange.end-0.5) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[self formatDateLabel:tickMonth] textStyle:[self xAxisLabelStyle]];
        label.tickLocation = CPTDecimalFromDouble(tickMonth);
        label.offset = 5;
        
        [xlabels addObject:label];
        [xMajorLocations addObject:[NSNumber numberWithDouble:tickMonth]];
        [xMinorLocations addObject:[NSNumber numberWithDouble:tickMonth + 0.5]];
        
        tickMonth += 1;
    }

    x.axisLabels = xlabels;
    x.majorTickLocations = xMajorLocations;
    x.minorTickLocations = xMinorLocations;
    
    //y axis
    CPTXYAxis* y= [[CPTXYAxis alloc] init];
    [y setLabelingPolicy:CPTAxisLabelingPolicyNone];
    
    y.coordinate = CPTCoordinateY;
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    y.plotSpace = plotSpace;
    y.axisLineStyle = [self axisLineStyle];
    y.majorTickLineStyle = [self hiddenLineStyle];
    y.minorTickLineStyle = [self hiddenLineStyle];
    y.anchorPoint=CGPointZero;
    
    NSMutableSet *ylabels = [[NSMutableSet alloc] init];
    NSMutableSet *yMajorLocations = [[NSMutableSet alloc] init];
    double dataValue = 0;
    while(dataValue<=self.dataValueRange.end){
        NSNumber *number = [NSNumber numberWithDouble:dataValue];
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[self formatDataValue:number] textStyle:[self yAxisLabelStyle]];
        label.tickLocation = CPTDecimalFromDouble(dataValue);
        label.offset = 5;
        
        [ylabels addObject:label];
        [yMajorLocations addObject:[NSNumber numberWithDouble:dataValue]];
        
        dataValue+=self.dataValueRange.end / 4;
    }

    y.axisLabels = ylabels;
    y.majorTickLocations = yMajorLocations;
    y.majorIntervalLength = CPTDecimalFromFloat(self.dataValueRange.end/4);
    y.majorGridLineStyle = [self gridLineStyle];
    y.labelTextStyle = [self yAxisLabelStyle];
    
    //add x and y axis into axis set
    self.chartView.graph.axisSet.axes = @[x,y];
}

-(NSString *)formatDateLabel:(int)monthTick
{
//    NSDate *date = [REMTimeHelper getDateFromMonthTicks:[NSNumber numberWithInt: monthTick]];
//    
//    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
//    [yearFormatter setDateFormat:@"yyyy年MM月"];
//    
//    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
//    [monthFormatter setDateFormat:@"MM月"];
//    
//    int month = [REMTimeHelper getMonth:date];
//    
//    return month == 1? [yearFormatter stringFromDate:date]: [monthFormatter stringFromDate:date];
    int year = monthTick / 12;
    int month = (monthTick % 12) + 1;
    
    return month == 1 ? [NSString stringWithFormat:@"%ddd年%dd月", year, month]:[NSString stringWithFormat:@"%dd月", month];
}

- (void)initializePlots
{
    NSString *columnIdentity, *lineIdentity;
    for(NSDictionary *series in self.chartData){
        NSString *identity = series[@"identity"];
        REMEnergyTargetType targetType = [[identity componentsSeparatedByString:@"-"][1] intValue];
        
        if(targetType == REMEnergyTargetCalcValue){
            columnIdentity = identity;
            continue;
        }
        else{
            lineIdentity = identity;
            continue;
        }
    }
    
    //unit - column
    CPTBarPlot *column=[[CPTBarPlot alloc] initWithFrame:self.chartView.graph.bounds];
    
    column.identifier=columnIdentity;
    
    column.barBasesVary=NO;
    column.barWidthsAreInViewCoordinates=YES;
    column.barWidth=CPTDecimalFromFloat(44);
    column.barOffset=CPTDecimalFromInt(0);
    
    column.fill= [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
    
    column.baseValue=CPTDecimalFromFloat(0);
    
    column.dataSource=self;
    column.delegate=self;
    
    column.lineStyle=nil;
    column.shadow=nil;
    
    column.anchorPoint=CGPointZero;
    
    [self.chartView.graph addPlot:column];
    
    //bench mark - line (color:235,106,79)
    CPTColor *lineColor = [[CPTColor alloc] initWithCGColor:[UIColor colorWithRed:(241.0/255.0) green:(94.0/255.0) blue:(49.0/255.0) alpha:1.0].CGColor];
    
    CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = lineColor;//[CPTColor orangeColor];
    lineStyle.lineWidth = 2;
    
    CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
    symbol.fill= [CPTFill fillWithColor:lineColor];
    symbol.size=CGSizeMake(10.0, 10.0);
    symbol.lineStyle = [self hiddenLineStyle];
    
    CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
    labelStyle.color = [REMColor colorByIndex:1];
    
    CPTScatterPlot *line = [[CPTScatterPlot alloc] initWithFrame:self.chartView.graph.bounds];
    line.dataSource = self;
    line.identifier = lineIdentity;
    line.plotSymbol = symbol;
    
    line.dataLineStyle = lineStyle;
    line.delegate = self;
    [self.chartView.graph addPlot:line];
}

- (BOOL)convertData
{
    NSArray *targetDatas = self.averageData.targetEnergyData;
    if(targetDatas == nil || [targetDatas isEqual:[NSNull null]] || targetDatas.count<=0)
    {
        return NO;
    }
    
    self.dataValueRange= [[REMDataRange alloc] initWithConstants];
    
    NSMutableArray *convertedData = [[NSMutableArray alloc] init];
    int index = 0;
    for(REMTargetEnergyData *targetEnergyData in targetDatas)
    {
        if(targetEnergyData == nil || [targetEnergyData isEqual:[NSNull null]])
            continue;
        
        REMEnergyTargetModel *target = targetEnergyData.target;
        NSArray *energyData = targetEnergyData.energyData;
        
        if(energyData == nil || [energyData isEqual:[NSNull null]] || energyData.count<=0)
            continue;
        
        NSMutableArray* data = [[NSMutableArray alloc]init];
        
        for(REMEnergyData *point in energyData){
            //if point value is null, do not add into series
            if([point.dataValue isEqual:[NSNull null]])
                continue;
            
            NSNumber *monthTicks = [REMTimeHelper getMonthTicksFromDate:point.localTime];
            
            [data addObject:@{@"y": point.dataValue, @"x": monthTicks}];
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [point.dataValue doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [point.dataValue doubleValue]);
        }
        
        NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%@", index, target.type, target.targetId];
        NSDictionary* series = @{ @"identity":targetIdentity, @"data":data};
        
        [convertedData addObject:series];
        
        index++;
    }
    
    //process data ranges
    NSDate *today = [REMTimeHelper today];
    
    NSNumber *globalEnd = [REMTimeHelper getMonthTicksFromDate:today];
    
    self.globalRange = [[REMDataRange alloc] initWithStart:[globalEnd doubleValue] - 35 andEnd:[globalEnd doubleValue]];
    self.visiableRange = [[REMDataRange alloc] initWithStart:0 andEnd:[globalEnd doubleValue]];
    
    self.visiableRange.start = [[REMTimeHelper getMonthTicksFromDate:[REMTimeHelper add:-1 onPart:REMDateTimePartYear ofDate:today]] doubleValue];
    
    self.globalRange.start -= 0.5;
    self.globalRange.end += 0.5;
    self.visiableRange.end = self.globalRange.end;
    
    double enlargeDistance = [self.visiableRange distance] * 0.3;
    self.draggableRange = [[REMDataRange alloc] initWithStart:(self.globalRange.start - enlargeDistance) andEnd:(self.globalRange.end + enlargeDistance)];
    
    self.chartData = convertedData;
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)drawChartLabels
{
    CGFloat fontSize = 14;
    CGFloat labelTopOffset = self.chartView.hostView.bounds.size.height+18;
    CGFloat labelLeftOffset = 57;
    CGFloat labelDistance = 18;
    
    REMCommodityModel *commodity = [[REMCommodityModel systemCommodities] objectForKey:[NSNumber numberWithLongLong:self.commodityId]];
    
    //average data
    UIColor *averageDataColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
    
    NSString *averageDataTitle = [NSString stringWithFormat:kAverageDataTitle,commodity.comment];
    
    CGFloat averageDataWidth = [averageDataTitle sizeWithFont:[UIFont systemFontOfSize:fontSize]].width + 26;
    CGRect averageDataFrame = CGRectMake(labelLeftOffset, labelTopOffset, averageDataWidth, fontSize);
    REMChartSeriesIndicator *averageDataIndicator = [[REMChartSeriesIndicator alloc] initWithFrame:averageDataFrame title:(NSString *)averageDataTitle andColor:averageDataColor];

    
    //benchmark
    UIColor *benchmarkColor = [UIColor colorWithRed:241.0/255.0 green:94.0/255.0 blue:49.0/255.0 alpha:1];
    
    CGFloat benchmarkWidth = [kBenchmarkTitle sizeWithFont:[UIFont systemFontOfSize:fontSize]].width + 26;
    CGRect benchmarkFrame = CGRectMake(labelLeftOffset+averageDataWidth+labelDistance, labelTopOffset, benchmarkWidth, fontSize);
    REMChartSeriesIndicator *benchmarkIndicator = [[REMChartSeriesIndicator alloc] initWithFrame:benchmarkFrame title:(NSString *)kBenchmarkTitle andColor:benchmarkColor];
    
    
    
    [self.view addSubview:benchmarkIndicator];
    [self.view addSubview:averageDataIndicator];
}


- (BOOL)plotSpace:(CPTXYPlotSpace *)space shouldHandlePointingDeviceUpEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    //left bound
    NSDecimal currentLeftLocation = space.xRange.location;
    NSDecimal currentRightLocation = CPTDecimalAdd(space.xRange.location,space.xRange.length);
    
    NSDecimal minLeftLocation = CPTDecimalFromDouble(self.globalRange.start);
    NSDecimal maxRightLocation = CPTDecimalFromDouble(self.globalRange.end);
    
    BOOL isCurrentLeftLessThanMinLeft = CPTDecimalLessThan(currentLeftLocation,minLeftLocation);
    BOOL isCurrentRightGreaterThanMaxRight = CPTDecimalGreaterThan(currentRightLocation, maxRightLocation);
    
    //if current left location is smaller than global range start, go back with animation
    //if current right location is greater than global range end, go back with animation too
    if(isCurrentLeftLessThanMinLeft == YES || isCurrentRightGreaterThanMaxRight == YES){
        CPTPlotRange *correctRange;
        if(isCurrentLeftLessThanMinLeft)
            correctRange = [[CPTPlotRange alloc] initWithLocation:minLeftLocation length:space.xRange.length];
        else
            correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance]) ];
        
        [CPTAnimation animate:space property:@"xRange" fromPlotRange:space.xRange toPlotRange:correctRange duration:0.15 withDelay:0 animationCurve:CPTAnimationCurveCubicInOut delegate:nil];
        
        return NO;
    }
    
    return  YES;
}


#pragma mark - data source delegate
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    
    int index = [[((NSString *)plot.identifier) componentsSeparatedByString:@"-"][0] intValue];
    
    return [[self.chartData[index] objectForKey:@"data"] count];
    //
//    NSUInteger records;
//    CPTBarPlot *line = (CPTBarPlot *)plot;
//    for (NSDictionary *series in self.chartData)
//    {
//        if([line.identifier isEqual:[series objectForKey:@"identity" ]] == YES)
//        {
//            records = [[series objectForKey:@"data"] count];
//            break;
//        }
//    }
////
//    //NSLog(@"line %@ has %d records.",line.identifier, records);
//    
//    return records;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    int index = [[((NSString *)plot.identifier) componentsSeparatedByString:@"-"][0] intValue];
    
    NSDictionary *point = [self.chartData[index] objectForKey:@"data"][idx];
    
    if(fieldEnum == CPTBarPlotFieldBarLocation || fieldEnum == CPTScatterPlotFieldX)
    {
        return [point objectForKey:@"x"];
    }
    else
    {
        return [point objectForKey:@"y"];
    }
    
//    NSNumber *number;
//    CPTBarPlot *line = (CPTBarPlot *)plot;
//    for (NSDictionary *series in self.chartData)
//    {
//        if([line.identifier isEqual:[series objectForKey:@"identity" ]] == YES)
//        {
//            NSDictionary *point = [series objectForKey:@"data"][idx];
//            
//            if(fieldEnum == CPTBarPlotFieldBarLocation)
//            {
//                number = [point objectForKey:@"x"];
//            }
//            else
//            {
//                number = [point objectForKey:@"y"];
//            }
//            
//            break;
//        }
//    }
//    return number;
}




/*
 
 -(void)longPressedAt:(NSDate*)x {
 
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
 */
@end
