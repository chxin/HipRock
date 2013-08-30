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
@property (nonatomic,strong) REMAirQualityStandardModel *standardChina, *standardAmerican;
@property (nonatomic,strong) UIColor *colorForChinaStandard, *colorForAmericanStandard;

@end

@implementation REMBuildingAirQualityChartHandler

const static NSString *kOutdoorCode = @"Outdoor";
const static NSString *kMayAirCode = @"MayAir";
const static NSString *kHoneywellCode = @"Honeywell";
const static NSString *kAmericanStandardCode = @"美国标准";
const static NSString *kChinaStandardCode = @"中国标准";


const static NSString *kOutdoorLabelName = @"室外PM2.5";
const static NSString *kHoneywellLabelName = @"室内新风PM2.5(霍尼)";
const static NSString *kMayAirLabelName = @"室内新风PM2.5(美埃)";
const static NSString *kAmericanStandardLabelFormat = @"%d %@(PM2.5美国标准)";
const static NSString *kChinaStandardLabelFormat = @"%d %@(PM2.5中国标准)";

static NSDictionary *codeNameMap;



- (REMBuildingAirQualityChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
        
        codeNameMap = [[NSDictionary alloc] initWithObjects:@[kOutdoorLabelName,kMayAirLabelName,kHoneywellLabelName,kAmericanStandardLabelFormat,kChinaStandardLabelFormat] forKeys:@[kOutdoorCode,kMayAirCode,kHoneywellCode,kAmericanStandardCode,kChinaStandardCode]];
        
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

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(void))loadCompleted
{
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong: buildingId]};
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSBuildingAirQuality parameter:parameter];
    store.isAccessLocal = YES;
    store.isStoreLocal = YES;
    store.maskContainer = self.view;
    
    [REMDataAccessor access:store success:^(id data) {
        self.airQualityData = [[REMAirQualityDataModel alloc] initWithDictionary:data];
        
        loadCompleted();
        
        if(self.airQualityData!=nil){
            [self loadChart];
        }
    } error:^(NSError *error, id response) {
        //NSLog(@"air fail! %@",error);
    }];
}

-(void)loadChart
{
    //convert data
    [self convertData];
    
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
    [self initializeLabels];
    
}

-(void)convertData
{
    NSMutableArray *convertedData = [[NSMutableArray alloc] init];
    
    self.globalRange = [[REMDataRange alloc] initWithConstants];
    self.visiableRange = [[REMDataRange alloc] initWithConstants];
    self.dataValueRange= [[REMDataRange alloc] initWithConstants];
    
    for (int i=0;i<self.airQualityData.airQualityData.targetEnergyData.count;i++) {
        REMTargetEnergyData *targetEnergyData = (REMTargetEnergyData *)self.airQualityData.airQualityData.targetEnergyData[i];
        
        REMEnergyTargetModel *target = targetEnergyData.target;
        NSArray *energyData = targetEnergyData.energyData;
        
        self.visiableRange.start = MIN(self.visiableRange.start, [target.visiableTimeRange.startTime timeIntervalSince1970]);
        self.visiableRange.end = MAX(self.visiableRange.end, [target.visiableTimeRange.endTime timeIntervalSince1970]);
        
        NSString* targetIdentity = [NSString stringWithFormat:@"air-%d-%d-%llu", i, target.type, target.targetId];
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        for (int j=0;j<energyData.count;j++) {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithDecimal: point.dataValue];
            
            [data addObject:@{@"y": value, @"x": point.localTime}];
            
            self.globalRange.start = MIN(self.globalRange.start, [point.localTime timeIntervalSince1970]);
            self.globalRange.end = MAX(self.globalRange.end, [point.localTime timeIntervalSince1970]);
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [value doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [value doubleValue]);
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
    
    //process visiable range
    NSDate *visiableEndDate = [NSDate dateWithTimeIntervalSince1970:self.visiableRange.end];
    NSDate *visiableStartDate = [REMTimeHelper add:-14 onPart:REMDateTimePartDay ofDate:visiableEndDate];
    
    self.visiableRange.start = [visiableStartDate timeIntervalSince1970];
    
    self.chartData = convertedData;
}

-(void)initializePlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.hostView.hostedGraph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.visiableRange.start) length:CPTDecimalFromDouble([self.visiableRange distance])];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.globalRange.start) length:CPTDecimalFromDouble([self.globalRange distance])];
    
    //since y axis will never be able to drag, global space and visiable space for y axis are equal
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(self.dataValueRange.start) length:CPTDecimalFromDouble([self.dataValueRange distance])];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble([self.dataValueRange start]) length:CPTDecimalFromDouble([self.dataValueRange distance])];
    
    [plotSpace setElasticGlobalXRange:YES];
    [plotSpace setAllowsMomentum:YES];
}

-(void)initializeAxises
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.hostView.hostedGraph.defaultPlotSpace;
    
    //line styles
    CPTMutableLineStyle *hiddenLineStyle = [CPTMutableLineStyle lineStyle];
    hiddenLineStyle.lineWidth = 0;
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc] init];
    gridLineStyle.lineWidth = 1.0f;
    gridLineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithWhite:0.7 alpha:0.3].CGColor];
    
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
    x.majorGridLineStyle = gridLineStyle;
    
    
    NSMutableSet *xlabels = [[NSMutableSet alloc] init];
    NSMutableSet *xlocations = [[NSMutableSet alloc] init];
    
    NSDate *tickDate = [NSDate dateWithTimeIntervalSince1970:self.globalRange.start];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    while ([tickDate timeIntervalSince1970] <= self.globalRange.end) {
        tickDate = [calendar dateByAddingComponents:components toDate:tickDate options:0];
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[self formatDateLabel:tickDate] textStyle:axisTextStyle];
        label.tickLocation = CPTDecimalFromDouble([tickDate timeIntervalSince1970]);
        label.offset = 5;
        
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
    y.anchorPoint=CGPointZero;
    y.majorIntervalLength = CPTDecimalFromFloat(self.dataValueRange.end/4);
    y.majorGridLineStyle = gridLineStyle;
    y.labelTextStyle = axisTextStyle;
    
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
        symbol.size=CGSizeMake(8.0, 8.0);
        
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
    
    CPTPlotRange *bandRangeChina=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble([self.standardChina.standardValue doubleValue])];
    CPTPlotRange *bandRangeAmerican=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble([self.standardAmerican.standardValue doubleValue])];
    
    CPTColor *chinaColor = [self getColorWithCode:(NSString *)kChinaStandardCode];
    CPTColor *americanColor = [self getColorWithCode:(NSString *)kAmericanStandardCode];
    
    
    CPTLimitBand *standardBandChina= [CPTLimitBand limitBandWithRange:bandRangeChina fill:[CPTFill fillWithColor:chinaColor]];
    CPTLimitBand *standardBandAmerican= [CPTLimitBand limitBandWithRange:bandRangeAmerican fill:[CPTFill fillWithColor:americanColor]];
    
    [verticalAxis addBackgroundLimitBand:standardBandChina];
    [verticalAxis addBackgroundLimitBand:standardBandAmerican];
}

-(void)initializeLabels
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

-(UILabel *)getStandardLabelWithCode:(NSString *)standardCode
{
    NSString *labelTextFormat = codeNameMap[standardCode];
    REMAirQualityStandardModel *standard;
    UIColor *standardColor = [self getColorWithCode:standardCode].uiColor;
    
    if(standardCode == (NSString *)kChinaStandardCode){
        standard = self.standardChina;
    }
    else{
        standard = self.standardAmerican;
    }
    
    CGPoint point = [self getViewPointFromChartPoint:self.globalRange.end :[standard.standardValue doubleValue]];
    CGRect labelFrame = CGRectMake(self.chartView.bounds.size.width-15, self.chartView.hostView.bounds.size.height - point.y+10,300, 14);
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial" size:14];
    label.text = [NSString stringWithFormat: labelTextFormat,[standard.standardValue intValue],standard.uom];
    label.textColor = standardColor;
    label.frame = labelFrame;
    
    return label;
}

-(REMChartSeriesIndicator *)getSeriesIndicatorWithCode:(NSString *)seriesCode
{
    CGFloat fontSize = 14.0, y = self.chartView.hostView.bounds.size.height + 43, x = 44.0, width=0.0, height=fontSize, indicatorSpace = 59,dotWidth=15, dotSpace=11;
    
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
    
    NSLog(@"%@:%@",seriesCode,NSStringFromCGRect(indicatorFrame));
    
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
        return [[CPTColor alloc] initWithComponentRed:99.0/255.0 green:0.0/255.0 blue:5.0/255.0 alpha:1];
    }
    else if([code isEqualToString:(NSString *)kAmericanStandardCode]){
        return [[CPTColor alloc] initWithComponentRed:26.0/255.0 green:64.0/255.0 blue:110.0/255.0 alpha:1];
    }
    else{
        return [[CPTColor alloc] initWithComponentRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
}

-(CGPoint)getViewPointFromChartPoint:(double)x :(double)y
{
    //CGPoint dataPoint;
    NSDecimal plotPoint[2];
    plotPoint[CPTCoordinateX] = CPTDecimalFromDouble(x);
    plotPoint[CPTCoordinateY] = CPTDecimalFromDouble(y);
        
    CPTGraph *graph = self.chartView.hostView.hostedGraph;
    [graph layoutIfNeeded];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
     
    // Convert the plot point to plot area space coordinates (I guess ;))
    CGPoint viewPoint = [plotSpace plotAreaViewPointForPlotPoint:plotPoint];
    
    return  viewPoint;
    
//    // Convert the view point to the button container layer coordinate system
//    dataPoint = [graph convertPoint:viewPoint fromLayer:graph.plotAreaFrame.plotArea];
//    
//    return [self.view convertPoint:dataPoint fromView:self.chartView.hostView];
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
