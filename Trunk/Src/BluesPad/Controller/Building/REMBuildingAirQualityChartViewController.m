/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityChartHandler.m
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingAirQualityChartViewController.h"
#import "REMAirQualityDataModel.h"
#import "REMCommonHeaders.h"
#import "REMDataRange.h"
#import "REMBuildingAirQualityChart.h"
#import "REMBuildingChartSeriesIndicator.h"
#import "REMBuildingConstants.h"

#define REMHalfDaySeconds 12*60*60

@interface REMBuildingAirQualityChartViewController ()

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
@property (nonatomic,strong) NSDateFormatter *formatter;


@end

@implementation REMBuildingAirQualityChartViewController

#define kTagCodeSuffixOutdoor @"Outdoor"
#define kTagCodeSuffixHoneywell @"Honeywell"
#define kTagCodeSuffixMayAir @"MayAir"
#define kAmericanStandardCode @"美国标准"
#define kChinaStandardCode @"中国标准"

#define kWordAirQualityOutdoor REMLocalizedString(@"Building_AirQualityOutdoor")
#define kWordAirQualityHoneywell REMLocalizedString(@"Building_AirQualityHoneywell")
#define kWordAirQualityMayair REMLocalizedString(@"Building_AirQualityMayair")
#define kWordAirQualityAmericanStandard REMLocalizedString(@"Building_AirQualityAmericanStandard")
#define kWordAirQualityChinaStandard REMLocalizedString(@"Building_AirQualityChinaStandard")


static NSDictionary *codeNameMap;



- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
        self.scrollManager = [[REMChartHorizonalScrollDelegator alloc]init];
        codeNameMap = @{kTagCodeSuffixOutdoor:kWordAirQualityOutdoor,
                        kTagCodeSuffixHoneywell:kWordAirQualityHoneywell,
                        kTagCodeSuffixMayAir:kWordAirQualityMayair,
                        kAmericanStandardCode:kWordAirQualityAmericanStandard,
                        kChinaStandardCode:kWordAirQualityChinaStandard,};
        
        self.requestUrl=REMDSBuildingAirQuality;
        
        self.formatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

- (void)loadView
{
    self.view = [[REMBuildingAirQualityChart alloc] initWithFrame:self.viewFrame];
    self.chartView = (REMBuildingAirQualityChart *)self.view;
    
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
    else{
        [self drawLabelWithText:NSLocalizedString(@"BuildingChart_NoData", @"")];
    }
}

- (void)loadDataFailureWithError:(REMError *)error withResponse:(id)response{
    NSString *text = NSLocalizedString(@"BuildingChart_DataError", @"");
    [self drawLabelWithText:text];
}

-(void)loadChart
{
    //convert data
    BOOL hasData = [self convertData];
    
    if(hasData == NO || self.chartData == nil || self.chartData.count<=0)
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
    
    NSDate *today = [REMTimeHelper convertGMTDateToLocal:[REMTimeHelper today]];
    NSDate *_14DaysBefore = [REMTimeHelper add:-14 onPart:REMDateTimePartDay ofDate:[REMTimeHelper tomorrow]];
    NSDate *_366DaysBefore = [REMTimeHelper add:-365 onPart:REMDateTimePartDay ofDate:[REMTimeHelper tomorrow]];
    
    for (int i=0;i<self.airQualityData.airQualityData.targetEnergyData.count;i++) {
        REMTargetEnergyData *targetEnergyData = (REMTargetEnergyData *)self.airQualityData.airQualityData.targetEnergyData[i];
        
        REMEnergyTargetModel *target = targetEnergyData.target;
        NSArray *energyData = targetEnergyData.energyData;
        
        NSString *seriesCode = nil;
        
        if([target.code hasSuffix:kTagCodeSuffixHoneywell]){
            seriesCode = kTagCodeSuffixHoneywell;
        }
        else if([target.code hasSuffix:kTagCodeSuffixMayAir]){
            seriesCode = kTagCodeSuffixMayAir;
        }
        else if([target.code hasSuffix:kTagCodeSuffixOutdoor]){
            seriesCode = kTagCodeSuffixOutdoor;
        }
        
        if(seriesCode == nil){
            continue;
        }
        
        NSString* targetIdentity = [NSString stringWithFormat:@"air-%d-%d-%@", i, target.type, target.targetId];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        for (int j=0;j<energyData.count;j++) {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            
            if([point.dataValue isEqual:[NSNull null]])
                continue;
            if([point.localTime timeIntervalSince1970] <= [_366DaysBefore timeIntervalSince1970])
                continue;
            
            [data addObject:@{@"y": point.dataValue, @"x": point.localTime}];
            
            self.globalRange.start = MIN(self.globalRange.start, [point.localTime timeIntervalSince1970]);
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [point.dataValue doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [point.dataValue doubleValue]);
        }
        
        NSDictionary* series = @{@"code":seriesCode,@"title":target.name, @"identity":targetIdentity, @"data":data};
        
        [convertedData addObject:series];
    }
    
    if(self.dataValueRange.end<100){
        self.dataValueRange.end = 100;
    }
    
    for(REMAirQualityStandardModel *standard in self.airQualityData.standards){
        if([standard.standardName isEqualToString: kAmericanStandardCode]){
            self.standardAmerican = standard;
        }
        if([standard.standardName isEqualToString: kChinaStandardCode]){
            self.standardChina = standard;
        }
    }
    
    //process global range
    self.globalRange.end = [today timeIntervalSince1970];
    if(self.globalRange.start<[_366DaysBefore timeIntervalSince1970])
        self.globalRange.start = [_366DaysBefore timeIntervalSince1970];
    self.globalRange.start -= REMHalfDaySeconds;
    self.globalRange.end += REMHalfDaySeconds;
    
    //process visiable range
    self.visiableRange.start = [_14DaysBefore timeIntervalSince1970];
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
    plotSpace.delegate=self;//.scrollManager;
    
    //long dayTicks = [[REMTimeHelper tomorrow] timeIntervalSince1970] - [[REMTimeHelper today] timeIntervalSince1970];
    
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
    
    NSDate *tickDate = [NSDate dateWithTimeIntervalSince1970:self.globalRange.start + REMHalfDaySeconds];

    while ([tickDate timeIntervalSince1970] < self.globalRange.end) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[self formatDateLabel:tickDate] textStyle:[self xAxisLabelStyle]];
        label.tickLocation = CPTDecimalFromDouble([tickDate timeIntervalSince1970]);
        label.offset = 5;
        
        [xlabels addObject:label];
        [xlocations addObject:[NSNumber numberWithDouble:[tickDate timeIntervalSince1970] + REMHalfDaySeconds]];
        
        tickDate = [REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:tickDate];
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
    int day = [REMTimeHelper getDay:date];
    if(day == 1){
        [self.formatter setDateFormat:@"MM月dd日"];
    }
    else{
        [self.formatter setDateFormat:@"dd日"];
    }
    
    return [self.formatter stringFromDate:date];
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
        [line addAnimation:[self plotAnimation] forKey:@"grow"];
        [self.chartView.hostView.hostedGraph addPlot:line];
    }
}

-(void)drawStandards
{
    CPTXYAxis *verticalAxis = ((CPTXYAxisSet *)self.chartView.hostView.hostedGraph.axisSet).yAxis;
    
    CPTPlotRange *bandRangeChina=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble([self.standardAmerican.standardValue doubleValue]) length:CPTDecimalFromDouble([self.standardChina.standardValue doubleValue] - [self.standardAmerican.standardValue doubleValue])];
    CPTPlotRange *bandRangeAmerican=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble([self.standardAmerican.standardValue doubleValue])];
    
    CPTColor *chinaColor = [self getColorWithCode:kChinaStandardCode];
    CPTColor *americanColor = [self getColorWithCode:kAmericanStandardCode];
    
    
    CPTLimitBand *standardBandChina= [CPTLimitBand limitBandWithRange:bandRangeChina fill:[CPTFill fillWithColor:chinaColor]];
    CPTLimitBand *standardBandAmerican= [CPTLimitBand limitBandWithRange:bandRangeAmerican fill:[CPTFill fillWithColor:americanColor]];
    
    [verticalAxis addBackgroundLimitBand:standardBandChina];
    [verticalAxis addBackgroundLimitBand:standardBandAmerican];
}

-(void)drawLabels
{
    //standard labels
    for(NSString *standardCode in @[kChinaStandardCode, kAmericanStandardCode]){
        UILabel *standardLabel = [self getStandardLabelWithCode:standardCode];
        
        [self.view addSubview:standardLabel];
    }
    
    //line dots and labels
    for(NSDictionary *series in self.chartData){
        NSString *seriesCode = [series objectForKey:@"code"];
        
        REMBuildingChartSeriesIndicator *indicator = [self getSeriesIndicatorWithCode:seriesCode];
        [self.view addSubview:indicator];
    }
}

-(UILabel *)getStandardLabelWithCode:(NSString *)standardCode
{
    CGFloat fontSize = 11;
    CGFloat labelOffset = 11;
    
    NSString *labelTextFormat = codeNameMap[standardCode];
    REMAirQualityStandardModel *standard;
    UIColor *standardColor;// = [self getColorWithCode:standardCode].uiColor;
    
    if([standardCode isEqualToString: kChinaStandardCode]){
        standard = self.standardChina;
        standardColor = [self getColorWithCode:standardCode].uiColor;//[UIColor colorWithRed:255.0/255.0 green:97.0/255.0 blue:106.0/255.0 alpha:1];
    }
    else{
        standard = self.standardAmerican;
        standardColor = [self getColorWithCode:standardCode].uiColor;//[UIColor colorWithRed:119.0/255.0 green:196.0/255.0 blue:255.0/255.0 alpha:1];
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

-(REMBuildingChartSeriesIndicator *)getSeriesIndicatorWithCode:(NSString *)seriesCode
{
    CGFloat fontSize = 14.0, y = self.chartView.hostView.bounds.size.height + 30, x = self.chartView.hostView.hostedGraph.plotAreaFrame.frame.origin.x, width=0.0, height=15.0, indicatorSpace = 18,dotWidth=15, dotSpace=11;
    
    for(NSString *code in @[kTagCodeSuffixOutdoor,kTagCodeSuffixHoneywell,kTagCodeSuffixMayAir]){
        NSString *name = codeNameMap[code];
        UIFont *font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:fontSize];
        CGSize size = [name sizeWithFont:font];
        
        x += width == 0 ? width : width + indicatorSpace;
        width = size.width + dotWidth + dotSpace + 5;
        
        if([seriesCode isEqualToString:code])
            break;
    }
    
    CGRect indicatorFrame = CGRectMake(x,y,width,height);
    
    NSString *indicatorName = codeNameMap[seriesCode];
    UIColor *indicatorColor = [self getColorWithCode:seriesCode].uiColor;
    
    REMBuildingChartSeriesIndicator *indicator = [[REMBuildingChartSeriesIndicator alloc] initWithFrame:indicatorFrame title:indicatorName andColor:indicatorColor];
    
    return indicator;
}

-(CPTColor *)getColorWithCode:(NSString *)code
{
    if([code isEqualToString:kTagCodeSuffixMayAir]){
        return [[CPTColor alloc] initWithComponentRed:0.0/255.0 green:163.0/255.0 blue:179.0/255.0 alpha:1];
    }
    else if([code isEqualToString:kTagCodeSuffixHoneywell]){
        return [[CPTColor alloc] initWithComponentRed:97.0/255.0 green:184.0/255.0 blue:2.0/255.0 alpha:1];
    }
    else if([code isEqualToString:kTagCodeSuffixOutdoor]){
        return [[CPTColor alloc] initWithComponentRed:106.0/255.0 green:99.0/255.0 blue:74.0/255.0 alpha:1];
    }
    else if([code isEqualToString:kChinaStandardCode]){
        return [[CPTColor alloc] initWithComponentRed:58.0/255.0 green:255.0/255.0 blue:168.0/255.0 alpha:0.43];
    }
    else if([code isEqualToString:kAmericanStandardCode]){
        return [[CPTColor alloc] initWithComponentRed:0.0/255.0 green:226.0/255.0 blue:255.0/255.0 alpha:0.39];
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
