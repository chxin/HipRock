//
//  REMBuildingAirQualityChartHandler.m
//  Blues
//
//  Created by tantan on 8/22/13.
//
//

#import "REMBuildingAirQualityChartHandler.h"
#import "REMAirQualityDataModel.h"
#import "REMCommonHeaders.h"
#import "REMDataRange.h"
#import "REMBuildingAirQualityChart.h"
#import "REMChartSeriesIndicator.h"
#import "REMBuildingConstants.h"

@interface REMBuildingAirQualityChartHandler ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) REMBuildingAirQualityChart *chartView;
@property (nonatomic,strong) REMAirQualityDataModel *airQualityData;
@property (nonatomic,strong) NSArray *chartData;

@property (nonatomic,strong) REMDataRange *dataValueRange;
@property (nonatomic,strong) REMDataRange *visiableRange;
@property (nonatomic,strong) REMDataRange *globalRange;
@property (nonatomic,strong) REMDataRange *draggableRange;

@property (nonatomic,strong) REMAirQualityStandardModel *standardChina, *standardAmerican;
@property (nonatomic,strong) UIColor *colorForChinaStandard, *colorForAmericanStandard;


@property (nonatomic,strong) REMChartHorizonalScrollDelegator *scrollManager;


@end

@implementation REMBuildingAirQualityChartHandler


static NSString *kOutdoorCode = @"GalaxySoho_Outdoor";
static NSString *kMayAirCode = @"GalaxySoho_MayAir";
static NSString *kHoneywellCode = @"GalaxySoho_Honeywell";
static NSString *kAmericanStandardCode = @"美国标准";
static NSString *kChinaStandardCode = @"中国标准";

static NSString *kOutdoorLabelName = @"室外PM2.5";
static NSString *kHoneywellLabelName = @"室内新风PM2.5(霍尼)";
static NSString *kMayAirLabelName = @"室内新风PM2.5(美埃)";
static NSString *kAmericanStandardLabelFormat = @"%d %@(PM2.5美国标准)";
static NSString *kChinaStandardLabelFormat = @"%d %@(PM2.5中国标准)";

static NSString *kNoDataText = @"暂无数据";

static NSDictionary *codeNameMap;



- (REMBuildingAirQualityChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
        self.scrollManager = [[REMChartHorizonalScrollDelegator alloc]init];
        codeNameMap = [[NSDictionary alloc] initWithObjects:@[kOutdoorLabelName,kMayAirLabelName,kHoneywellLabelName,kAmericanStandardLabelFormat,kChinaStandardLabelFormat] forKeys:@[kOutdoorCode,kMayAirCode,kHoneywellCode,kAmericanStandardCode,kChinaStandardCode]];
        self.requestUrl=REMDSBuildingAirQuality;
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view = [[REMBuildingAirQualityChart alloc] initWithFrame:self.viewFrame];
    self.chartView = (REMBuildingAirQualityChart *)self.view;
    
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong: buildingId]};
    
    return parameter;
}

- (void)loadDataSuccessWithData:(id)data
{
    self.airQualityData = [[REMAirQualityDataModel alloc] initWithDictionary:data];
    
    if(self.airQualityData!=nil){
        [self loadChart];
    }
}

-(void)loadChart
{
    //convert data
    BOOL hasData = [self convertData];
    
    if(hasData == NO || self.chartData == nil || self.chartData.count<=0)
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
        
        //
        [self drawStandards];
        
        [self drawLabels];
    }
}

-(BOOL)convertData
{
    NSMutableArray *convertedData = [[NSMutableArray alloc] init];
    
    if(self.airQualityData.airQualityData.targetEnergyData.count<=0){
        return NO;
    }
    
    self.globalRange = [[REMDataRange alloc] initWithConstants];
    self.visiableRange = [[REMDataRange alloc] initWithConstants];
    self.dataValueRange= [[REMDataRange alloc] initWithConstants];
    
    
    for (int i=0;i<self.airQualityData.airQualityData.targetEnergyData.count;i++) {
        REMTargetEnergyData *targetEnergyData = (REMTargetEnergyData *)self.airQualityData.airQualityData.targetEnergyData[i];
        
        REMEnergyTargetModel *target = targetEnergyData.target;
        NSArray *energyData = targetEnergyData.energyData;
        
        self.visiableRange.start = MIN(self.visiableRange.start, [target.visiableTimeRange.startTime timeIntervalSince1970]);
        self.visiableRange.end = MAX(self.visiableRange.end, [target.visiableTimeRange.endTime timeIntervalSince1970]);
        
        NSString* targetIdentity = [NSString stringWithFormat:@"air-%d-%d-%@", i, target.type, target.targetId];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        for (int j=0;j<energyData.count;j++) {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            
            if([point.dataValue isEqual:[NSNull null]])
                continue;
            
            [data addObject:@{@"y": point.dataValue, @"x": point.localTime}];
            
            self.globalRange.start = MIN(self.globalRange.start, [point.localTime timeIntervalSince1970]);
            self.globalRange.end = MAX(self.globalRange.end, [point.localTime timeIntervalSince1970]);
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [point.dataValue doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [point.dataValue doubleValue]);
        }
        
        NSDictionary* series = @{@"code":target.code,@"title":target.name, @"identity":targetIdentity, @"data":data};
        
        [convertedData addObject:series];
    }
    
    if(self.dataValueRange.end<100){
        self.dataValueRange.end = 100;
    }
    
    for(REMAirQualityStandardModel *standard in self.airQualityData.standards){
        if([standard.standardName isEqual: kAmericanStandardCode]){
            self.standardAmerican = standard;
        }
        if([standard.standardName isEqual: kChinaStandardCode]){
            self.standardChina = standard;
        }
    }
    
    //process global range
    NSDate *tomorrow = [REMTimeHelper add:-4 onPart:REMDateTimePartHour ofDate: [REMTimeHelper tomorrow]];
    self.globalRange.end = [tomorrow timeIntervalSince1970];
    //process visiable range
    NSDate *visiableStartDate = [REMTimeHelper add:-14 onPart:REMDateTimePartDay ofDate:tomorrow];
    
    self.visiableRange.start = [visiableStartDate timeIntervalSince1970];
    self.visiableRange.end = self.globalRange.end;
    
    double enlargeDistance = [self.visiableRange distance] * 0.3;
    self.draggableRange = [[REMDataRange alloc] initWithStart:(self.globalRange.start - enlargeDistance) andEnd:(self.globalRange.end + enlargeDistance)];
    
    self.chartData = convertedData;
    
    return YES;
}

-(void)initializePlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.hostView.hostedGraph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.delegate=self.scrollManager;
    
    long dayTicks = [[REMTimeHelper tomorrow] timeIntervalSince1970] - [[REMTimeHelper today] timeIntervalSince1970];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.draggableRange.start) length:CPTDecimalFromDouble([self.draggableRange distance])];
    
    //since y axis will never be able to drag, global space and visiable space for y axis are equal
    CPTPlotRange *dataValuePlotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(self.dataValueRange.end + [self.dataValueRange distance] * 0.05)];
    plotSpace.yRange = dataValuePlotRange;
    plotSpace.globalYRange = dataValuePlotRange;
    
    self.scrollManager.globalRange=self.globalRange;
    self.scrollManager.visiableRange=self.visiableRange;
}

-(void)initializeAxises
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.hostView.hostedGraph.defaultPlotSpace;
    
    
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
    x.anchorPoint=CGPointZero;
    x.minorGridLineStyle = [self gridLineStyle];
    
    
    NSMutableSet *xlabels = [[NSMutableSet alloc] init];
    NSMutableSet *xlocations = [[NSMutableSet alloc] init];
    
    NSDate *tickDate = [NSDate dateWithTimeIntervalSince1970:self.globalRange.start];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    while ([tickDate timeIntervalSince1970] < self.globalRange.end) {
        tickDate = [calendar dateByAddingComponents:components toDate:tickDate options:0];
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[self formatDateLabel:tickDate] textStyle:[self xAxisLabelStyle]];
        label.tickLocation = CPTDecimalFromDouble([tickDate timeIntervalSince1970]);
        label.offset = 5;
        
        [xlabels addObject:label];
        [xlocations addObject:[NSNumber numberWithDouble:[tickDate timeIntervalSince1970] + 12*60*60]];
    }
    
    x.axisLabels = xlabels;
    x.minorTickLocations = xlocations;
    
    //y axis
    CPTXYAxis* y= [[CPTXYAxis alloc] init];
    [y setLabelingPolicy:CPTAxisLabelingPolicyNone];
    
    y.coordinate = CPTCoordinateY;
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    y.plotSpace = plotSpace;
    y.axisLineStyle = [self axisLineStyle];
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
    self.chartView.hostView.hostedGraph.axisSet.axes = @[x,y];
}

-(NSString *)formatDateLabel:(NSDate *)date
{
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM月dd日"];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd日"];
    
    int day = [REMTimeHelper getDay:date];
    
    return day == 1? [monthFormatter stringFromDate:date]: [dayFormatter stringFromDate:date];
}

-(void)initializePlots
{
    for(NSDictionary *series in self.chartData){
        CPTColor *lineColor = [self getColorWithCode:[series objectForKey:@"code"]];
        
        CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
        symbol.fill= [CPTFill fillWithColor:lineColor];
        symbol.size=CGSizeMake(10.0, 10.0);
        symbol.lineStyle = [self hiddenLineStyle];
        
        CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineColor = lineColor;
        lineStyle.lineWidth = 2;
        
        CPTScatterPlot *line = [[CPTScatterPlot alloc] initWithFrame:self.chartView.hostView.hostedGraph.bounds];
        line.dataSource = self;
        line.identifier = [series objectForKey:@"identity"];
        
        line.dataLineStyle = lineStyle;
        line.plotSymbol = symbol;
        line.delegate = self;
        [self.chartView.hostView.hostedGraph addPlot:line];
    }
}

-(void)drawStandards
{
    CPTXYAxis *verticalAxis = ((CPTXYAxisSet *)self.chartView.hostView.hostedGraph.axisSet).yAxis;
    
    CPTPlotRange *bandRangeChina=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble([self.standardAmerican.standardValue doubleValue]) length:CPTDecimalFromDouble([self.standardChina.standardValue doubleValue] - [self.standardAmerican.standardValue doubleValue])];
    CPTPlotRange *bandRangeAmerican=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble([self.standardAmerican.standardValue doubleValue])];
    
    CPTColor *chinaColor = [self getColorWithCode:(NSString *)kChinaStandardCode];
    CPTColor *americanColor = [self getColorWithCode:(NSString *)kAmericanStandardCode];
    
    
    CPTLimitBand *standardBandChina= [CPTLimitBand limitBandWithRange:bandRangeChina fill:[CPTFill fillWithColor:chinaColor]];
    CPTLimitBand *standardBandAmerican= [CPTLimitBand limitBandWithRange:bandRangeAmerican fill:[CPTFill fillWithColor:americanColor]];
    
    [verticalAxis addBackgroundLimitBand:standardBandChina];
    [verticalAxis addBackgroundLimitBand:standardBandAmerican];
}

-(void)drawLabels
{
    //standard labels
    for(NSString *standardCode in @[(NSString *)kChinaStandardCode, (NSString *)kAmericanStandardCode]){
        UILabel *standardLabel = [self getStandardLabelWithCode:standardCode];
        
        [self.view addSubview:standardLabel];
    }
    
    //line dots and labels
    for(NSDictionary *series in self.chartData){
        NSString *seriesCode = [series objectForKey:@"code"];
        
        REMChartSeriesIndicator *indicator = [self getSeriesIndicatorWithCode:seriesCode];
        [self.view addSubview:indicator];
    }
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

-(UILabel *)getStandardLabelWithCode:(NSString *)standardCode
{
    CGFloat fontSize = 11;
    CGFloat labelOffset = 11;
    
    NSString *labelTextFormat = codeNameMap[standardCode];
    REMAirQualityStandardModel *standard;
    UIColor *standardColor;// = [self getColorWithCode:standardCode].uiColor;
    
    if(standardCode == (NSString *)kChinaStandardCode){
        standard = self.standardChina;
        standardColor = [UIColor colorWithRed:255.0/255.0 green:97.0/255.0 blue:106.0/255.0 alpha:1];
    }
    else{
        standard = self.standardAmerican;
        standardColor = [UIColor colorWithRed:119.0/255.0 green:196.0/255.0 blue:255.0/255.0 alpha:1];
    }
    
    NSString *labelText = [NSString stringWithFormat: labelTextFormat,[standard.standardValue intValue],standard.uom];
    
    UIFont *labelFont = [UIFont systemFontOfSize:fontSize];
    CGFloat labelTopOffset = self.chartView.hostView.bounds.size.height-[self getViewPointFromChartPoint: self.globalRange.end :[standard.standardValue doubleValue]].y;
    CGFloat labelWidth = [labelText sizeWithFont:labelFont].width;
    CGRect labelFrame = CGRectMake(self.chartView.hostView.bounds.size.width+labelOffset,  labelTopOffset,labelWidth, fontSize);
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = labelFont;
    label.text = labelText;
    label.textColor = standardColor;
    label.frame = labelFrame;
    
    return label;
}

-(REMChartSeriesIndicator *)getSeriesIndicatorWithCode:(NSString *)seriesCode
{
    CGFloat fontSize = 14.0, y = self.chartView.hostView.bounds.size.height + 30, x = self.chartView.hostView.hostedGraph.plotAreaFrame.frame.origin.x, width=0.0, height=15.0, indicatorSpace = 18,dotWidth=15, dotSpace=11;
    
    for(NSString *code in @[kOutdoorCode,kHoneywellCode,kMayAirCode]){
        NSString *name = codeNameMap[code];
        UIFont *font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:fontSize];
        CGSize size = [name sizeWithFont:font];
        
        x += width == 0 ? width : width + indicatorSpace;
        width = size.width +dotWidth+ dotSpace;
        
        if([seriesCode isEqualToString:(NSString *)code])
            break;
    }
    
    CGRect indicatorFrame = CGRectMake(x,y,width,height);
    
    NSString *indicatorName = codeNameMap[seriesCode];
    UIColor *indicatorColor = [self getColorWithCode:seriesCode].uiColor;
    
    REMChartSeriesIndicator *indicator = [[REMChartSeriesIndicator alloc] initWithFrame:indicatorFrame title:indicatorName andColor:indicatorColor];
    
    return indicator;
}

-(CPTColor *)getColorWithCode:(NSString *)code
{
    if([code isEqualToString:(NSString *)kMayAirCode]){
        return [[CPTColor alloc] initWithComponentRed:0.0/255.0 green:163.0/255.0 blue:179.0/255.0 alpha:1];
    }
    else if([code isEqualToString:(NSString *)kHoneywellCode]){
        return [[CPTColor alloc] initWithComponentRed:97.0/255.0 green:184.0/255.0 blue:2.0/255.0 alpha:1];
    }
    else if([code isEqualToString:(NSString *)kOutdoorCode]){
        return [[CPTColor alloc] initWithComponentRed:106.0/255.0 green:99.0/255.0 blue:74.0/255.0 alpha:1];
    }
    else if([code isEqualToString:(NSString *)kChinaStandardCode]){
        return [[CPTColor alloc] initWithComponentRed:255.0/255.0 green:0.0/255.0 blue:14.0/255.0 alpha:0.39];
    }
    else if([code isEqualToString:(NSString *)kAmericanStandardCode]){
        return [[CPTColor alloc] initWithComponentRed:58.0/255.0 green:148.0/255.0 blue:255.0/255.0 alpha:0.43];
    }
    else{
        return [[CPTColor alloc] initWithComponentRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
}

-(CGPoint)getViewPointFromChartPoint:(double)x :(double)y
{
    CGPoint dataPoint;
    NSDecimal plotPoint[2];
    plotPoint[CPTCoordinateX] = CPTDecimalFromDouble(x);
    plotPoint[CPTCoordinateY] = CPTDecimalFromDouble(y);
        
    CPTGraph *graph = self.chartView.hostView.hostedGraph;
    [graph layoutIfNeeded];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
     
    // Convert the plot point to plot area space coordinates (I guess ;))
    CGPoint viewPoint = [plotSpace plotAreaViewPointForPlotPoint:plotPoint];
    
    //viewPoint;
    
//    // Convert the view point to the button container layer coordinate system
    dataPoint = [graph convertPoint:viewPoint fromLayer:graph.plotAreaFrame.plotArea];
    
    return dataPoint;
//    
//    return [self.view convertPoint:dataPoint fromView:self.chartView.hostView];
}

#pragma mark -
#pragma mark plotspace delegate for event
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


@end
