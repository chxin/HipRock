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



@interface REMBuildingAverageChartHandler ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) REMBuildingAverageChart *chartView;
@property (nonatomic,strong) NSArray *chartData;
@property (nonatomic,strong) REMAverageUsageDataModel *averageData;

@property (nonatomic,strong) REMDataRange *dataValueRange;
@property (nonatomic,strong) REMDataRange *visiableRange;
@property (nonatomic,strong) REMDataRange *globalRange;
@property (nonatomic,strong) REMDataRange *draggableRange;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) NSTimeInterval lastTime;
@property (nonatomic) BOOL isDragging;

@end

@implementation REMBuildingAverageChartHandler

static NSString *kNoDataText = @"暂无数据";

static NSString *kBenchmarkTitle = @"单位用电";
static NSString *kAverageDataTitle = @"指数";


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




- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageData :(void (^)(void))loadCompleted
{
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong:buildingId], @"commodityId":[NSNumber numberWithLongLong:commodityID]};
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSBuildingAverageData parameter:parameter];
    store.isAccessLocal = YES;
    store.isStoreLocal = YES;
    store.maskContainer = self.view;
    store.groupName = [NSString stringWithFormat:@"b-%lld-%lld", buildingId, commodityID];
    [REMDataAccessor access:store success:^(id data) {
        self.averageData = [[REMAverageUsageDataModel alloc] initWithDictionary:data];
        
        loadCompleted();
        
        if(self.averageData!=nil){
            [self loadChart];
        }
    } error:^(NSError *error, id response) {
        
    }];
}

- (void)loadChart
{
    //convert data
    BOOL hasData = [self convertData];
    
    if(hasData == NO || self.chartData==nil || self.chartData.count<=0)
    {
        [self drawNoDataLabel];
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
    plotSpace.delegate=self;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.draggableRange.start) length:CPTDecimalFromDouble([self.draggableRange distance])];
    
    //since y axis will never be able to drag, global space and visiable space for y axis are equal
    CPTPlotRange *dataValuePlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(self.dataValueRange.end + [self.dataValueRange distance] * 0.05)];
    plotSpace.yRange = dataValuePlotRange;
    plotSpace.globalYRange = dataValuePlotRange;
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
    
    double tickMonth = self.globalRange.start;
    
    while (tickMonth <= self.globalRange.end) {
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
    NSDate *date = [REMTimeHelper getDateFromMonthTicks:[NSNumber numberWithInt: monthTick]];
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy年MM月"];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM月"];
    
    int month = [REMTimeHelper getMonth:date];
    
    return month == 1? [yearFormatter stringFromDate:date]: [monthFormatter stringFromDate:date];
}

- (void)initializePlots
{
    //unit - column
    CPTBarPlot *column=[[CPTBarPlot alloc] initWithFrame:self.chartView.graph.bounds];
    
    column.identifier=[self.chartData[0] objectForKey:@"identity"];
    
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
    line.identifier = [self.chartData[1] objectForKey:@"identity"];
    line.plotSymbol = symbol;
    
    line.dataLineStyle = lineStyle;
    line.delegate = self;
    [self.chartView.graph addPlot:line];
}

- (BOOL)convertData
{
    if(self.averageData.unitData.targetEnergyData.count<1 && self.averageData.benchmarkData.targetEnergyData.count<1)
    {
        return NO;
    }
    
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
        
        self.visiableRange.start = MIN(self.visiableRange.start, [[REMTimeHelper getMonthTicksFromDate:target.visiableTimeRange.startTime] doubleValue]);
        self.visiableRange.end = MAX(self.visiableRange.end, [[REMTimeHelper getMonthTicksFromDate:target.visiableTimeRange.endTime] doubleValue]);
        
        for (int j = 0; j < energyData.count; j++)
        {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            
            NSNumber *monthTicks = [REMTimeHelper getMonthTicksFromDate:point.localTime];
            
            NSDecimalNumber *value = [[NSDecimalNumber alloc] initWithDecimal:point.dataValue];
            [data addObject:@{@"y": value, @"x": monthTicks}];
            
            self.globalRange.start = MIN(self.globalRange.start, [[REMTimeHelper getMonthTicksFromDate:point.localTime] doubleValue]);
            self.globalRange.end = MAX(self.globalRange.end, [[REMTimeHelper getMonthTicksFromDate:point.localTime] doubleValue]);
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [value doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [value doubleValue]);
        }
        NSDictionary* series = @{ @"identity":targetIdentity, @"data":data};
        
        [convertedData addObject:series];
        index ++;
    }

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
    CGFloat labelTopOffset = self.chartView.hostView.bounds.size.height+43-16;
    CGFloat labelLeftOffset = 56;
    CGFloat fontSize = 14;
    CGFloat labelDistance = 54;
    
    UIColor *benchmarkColor = [UIColor colorWithRed:241.0/255.0 green:94.0/255.0 blue:49.0/255.0 alpha:1];

    CGFloat benchmarkWidth = [kBenchmarkTitle sizeWithFont:[UIFont systemFontOfSize:fontSize]].width + 26;
    CGRect benchmarkFrame = CGRectMake(labelLeftOffset, labelTopOffset, benchmarkWidth, fontSize);
    REMChartSeriesIndicator *benchmarkIndicator = [[REMChartSeriesIndicator alloc] initWithFrame:benchmarkFrame title:(NSString *)kBenchmarkTitle andColor:benchmarkColor];
    
    UIColor *averageDataColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];

    CGFloat averageDataWidth = [kAverageDataTitle sizeWithFont:[UIFont systemFontOfSize:fontSize]].width + 26;
    CGRect averageDataFrame = CGRectMake(labelLeftOffset+benchmarkWidth+labelDistance, labelTopOffset, averageDataWidth, fontSize);
    REMChartSeriesIndicator *averageDataIndicator = [[REMChartSeriesIndicator alloc] initWithFrame:averageDataFrame title:(NSString *)kAverageDataTitle andColor:averageDataColor];
    
    
    [self.view addSubview:benchmarkIndicator];
    [self.view addSubview:averageDataIndicator];
}

-(void)drawNoDataLabel
{
    CGFloat fontSize = 36;
    CGSize labelSize = [kNoDataText sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, labelSize.width, labelSize.height)];
    noDataLabel.text = (NSString *)kNoDataText;
    noDataLabel.textColor = [UIColor whiteColor];
    noDataLabel.textAlignment = NSTextAlignmentLeft;
    noDataLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:noDataLabel];
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
                number = [point objectForKey:@"x"];
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

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    self.lastPoint=point;
    self.lastTime=event.timestamp;
    
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    //NSLog(@"dragged");
    
    //self.isDragging=YES;
     CGFloat deltaX=point.x-self.lastPoint.x;
    NSTimeInterval diffTime= event.timestamp-self.lastTime;
    //NSLog(@"diff time:%f",diffTime);
    //NSLog(@"delta x:%f",deltaX);
    if(diffTime<0.1)return NO;
    self.lastPoint=point;
    return YES;
}



- (BOOL)plotSpace:(CPTXYPlotSpace *)space shouldHandlePointingDeviceUpEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    
    CGFloat deltaX=point.x-self.lastPoint.x;
    
    if(ABS(deltaX)>8){
        NSTimeInterval diffTime= event.timestamp-self.lastTime;
        //NSLog(@"diff time:%f",diffTime);
        //NSLog(@"delta x:%f",deltaX);
        diffTime=MAX(0.05, diffTime);
        CGFloat speed = deltaX/diffTime;
        CGFloat constTime=0.2;
        CGFloat accelerate=speed/constTime;
        CGFloat distance = speed*constTime-0.5*accelerate*constTime*constTime;
        NSDecimal lastPoint[2], newPoint[2];
         CPTPlotArea *plotArea = self.getHostView.hostedGraph.plotAreaFrame.plotArea;
         CGPoint pointInPlotArea = [self.getHostView.hostedGraph convertPoint:point toLayer:plotArea];
        [space plotPoint:lastPoint forPlotAreaViewPoint:pointInPlotArea];
        [space plotPoint:newPoint forPlotAreaViewPoint:CGPointMake(pointInPlotArea.x + distance,pointInPlotArea.y)];
        
        NSDecimal shiftX = CPTDecimalSubtract(lastPoint[CPTCoordinateX], newPoint[CPTCoordinateX]);
        
        //NSLog(@"shiftx:%f",CPTDecimalFloatValue(shiftX));
        CPTMutablePlotRange *newRange= [space.xRange mutableCopy];
        
        newRange.location = CPTDecimalAdd(newRange.location, shiftX);
        
        
        //left bound
        NSDecimal currentLeftLocation = newRange.location;
        NSDecimal currentRightLocation = CPTDecimalAdd(newRange.location,newRange.length);
        
        NSDecimal minLeftLocation = CPTDecimalFromDouble(self.globalRange.start);
        NSDecimal maxRightLocation = CPTDecimalFromDouble(self.globalRange.end);
        
        BOOL isCurrentLeftLessThanMinLeft = CPTDecimalLessThan(currentLeftLocation,minLeftLocation);
        BOOL isCurrentRightGreaterThanMaxRight = CPTDecimalGreaterThan(currentRightLocation, maxRightLocation);
        
        //if current left location is smaller than global range start, go back with animation
        //if current right location is greater than global range end, go back with animation too
        CPTPlotRange  *correctRange;
        if(isCurrentLeftLessThanMinLeft == YES ){
            correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.globalRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
        }
        else if(isCurrentRightGreaterThanMaxRight == YES){
            correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
            
        }
        if(correctRange!=nil){
            constTime= ABS(CPTDecimalFloatValue(CPTDecimalSubtract(newRange.location, space.xRange.location))/speed);
           

        }

        
         [CPTAnimation animate:space
                          property:@"xRange"
                     fromPlotRange:space.xRange
                       toPlotRange:newRange
                          duration:constTime
                    animationCurve:CPTAnimationCurveSinusoidalOut
                          delegate:nil];
        
        if(correctRange!=nil){
            //newRange = [correctRange mutableCopy];
            [CPTAnimation animate:space property:@"xRange" fromPlotRange:newRange toPlotRange:correctRange duration:0.3 withDelay:constTime animationCurve:CPTAnimationCurveSinusoidalOut delegate:nil];
            
        }
        
        return  NO;
        
    }
    else{
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
            if(isCurrentLeftLessThanMinLeft == YES ){
                correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.globalRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
            }
            else if(isCurrentRightGreaterThanMaxRight == YES){
                correctRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
                
            }

            [CPTAnimation animate:space property:@"xRange" fromPlotRange:space.xRange toPlotRange:correctRange duration:0.3 withDelay:0 animationCurve:CPTAnimationCurveSinusoidalOut delegate:nil];
            
            return NO;
        }
    }
    
    return  YES;
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
