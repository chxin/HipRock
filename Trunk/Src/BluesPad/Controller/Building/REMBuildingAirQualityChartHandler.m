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

@interface REMBuildingAirQualityChartHandler ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) REMBuildingAirQualityChart *chartView;
@property (nonatomic,strong) REMAirQualityDataModel *airQualityData;
@property (nonatomic,strong) NSArray *chartData;

@property (nonatomic,strong) REMDataRange *dataValueRange;
@property (nonatomic,strong) REMDataRange *visiableRange;
@property (nonatomic,strong) REMDataRange *globalRange;

@end

@implementation REMBuildingAirQualityChartHandler


- (REMBuildingAirQualityChartHandler *)initWithViewFrame:(CGRect)frame
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
        NSLog(@"air success!");
        
        self.airQualityData = [[REMAirQualityDataModel alloc] initWithDictionary:data];
        
        loadCompleted();
        
        if(self.airQualityData!=nil){
            [self loadChart];
        }
    } error:^(NSError *error, id response) {
        NSLog(@"air fail! %@",error);
    }];
    
    loadCompleted();
}

-(void)loadChart
{
    //convert data
    [self convertData];
    
    //initialize plot space
    [self initializePlotSpace];
    
    //initialize axises
    [self initializeAxises];
    
    //initialize plots
    [self initializePlots];
    
    [self drawStandards];
    
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
    
//    if(convertedData.count>0){
//        for(int j=0;j<self.airQualityData.standards.count;j++){
//            REMAirQualityStandardModel *standard = self.airQualityData.standards[j];
//            
//            NSString* identity = [NSString stringWithFormat: @"sd-%d",j];
//            NSMutableArray *standardData = [[NSMutableArray alloc] init];
//            
//            for(int i=0;i<[[convertedData[0] objectForKey:@"data"] count]; i++) {
//                [standardData addObject:@{@"y": standard.standardValue, @"x": [[convertedData[0] objectForKey:@"data"][i] objectForKey:@"x"]}];
//            }
//            
//            [convertedData addObject:@{@"title":standard.standardName,@"identity":identity, @"data":standardData}];
//        }
//    }
    
    //process visiable range
    NSDate *visiableEndDate = [NSDate dateWithTimeIntervalSince1970:self.visiableRange.end];
    NSDate *visiableStartDate = [REMTimeHelper add:-14 onPart:REMDateTimePartDay ofDate:visiableEndDate];
    
    self.visiableRange.start = [visiableStartDate timeIntervalSince1970];
    
    self.chartData = convertedData;
}

-(void)initializePlotSpace
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.hostedGraph.defaultPlotSpace;
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
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.chartView.hostedGraph.defaultPlotSpace;
    
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
    
    NSDate *tickDate = [NSDate dateWithTimeIntervalSince1970:self.globalRange.start];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    while ([tickDate timeIntervalSince1970] <= self.globalRange.end) {
        tickDate = [calendar dateByAddingComponents:components toDate:tickDate options:0];
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[self formatDateLabel:tickDate] textStyle:axisTextStyle];
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
    self.chartView.hostedGraph.axisSet.axes = @[x,y];
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
        CPTColor *lineColor = [self getLineColorWithTagCode:[series objectForKey:@"code"]];
        
        CPTPlotSymbol *symbol = [CPTPlotSymbol ellipsePlotSymbol];
        symbol.fill= [CPTFill fillWithColor:lineColor];
        symbol.size=CGSizeMake(8.0, 8.0);
        
        CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineColor = lineColor;
        lineStyle.lineWidth = 2;
        
        CPTScatterPlot *line = [[CPTScatterPlot alloc] initWithFrame:self.chartView.hostedGraph.bounds];
        line.dataSource = self;
        line.identifier = [series objectForKey:@"identity"];
        
        line.dataLineStyle = lineStyle;
        line.plotSymbol = symbol;
        line.delegate = self;
        [self.chartView.hostedGraph addPlot:line];
    }
}

-(void)drawStandards
{
    CPTXYAxis *verticalAxis = ((CPTXYAxisSet *)self.chartView.hostedGraph.axisSet).yAxis;
    
    REMAirQualityStandardModel *standChina, *standardAmerican;
    for(REMAirQualityStandardModel *standard in self.airQualityData.standards){
        if([standard.standardName isEqual: @"美国标准"]){
            standardAmerican = standard;
        }
        if([standard.standardName isEqual: @"中国标准"]){
            standChina = standard;
        }
    }
    
    CPTPlotRange *bandRangeChina=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble([standChina.standardValue doubleValue])];
    CPTPlotRange *bandRangeAmerican=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble([standardAmerican.standardValue doubleValue])];
    
    CPTColor *colorForChinaStandard = [CPTColor redColor];//[CPTColor colorWithComponentRed:100/255 green:100/255 blue:100/255 alpha:0.5];
    CPTColor *colorForAmericanStandard = [CPTColor blueColor];//[CPTColor colorWithComponentRed:200/255 green:200/255 blue:200/255 alpha:0.5];
    
    CPTLimitBand *standardBandChina= [CPTLimitBand limitBandWithRange:bandRangeChina fill:[CPTFill fillWithColor:colorForChinaStandard]];
    CPTLimitBand *standardBandAmerican= [CPTLimitBand limitBandWithRange:bandRangeAmerican fill:[CPTFill fillWithColor:colorForAmericanStandard]];
    
    [verticalAxis addBackgroundLimitBand:standardBandChina];
    [verticalAxis addBackgroundLimitBand:standardBandAmerican];
    
    
}

-(CPTColor *)getLineColorWithTagCode:(NSString *)code
{
    if([code isEqualToString:@"MayAir"]){
        return [CPTColor orangeColor];// [[CPTColor alloc] initWithComponentRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
    else if([code isEqualToString:@"Honeywell"]){
        return [CPTColor greenColor];// [[CPTColor alloc] initWithComponentRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
    else if([code isEqualToString:@"Outdoor"]){
        return [CPTColor whiteColor];// [[CPTColor alloc] initWithComponentRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
    else{
        return [[CPTColor alloc] initWithComponentRed:0.0 green:0.0 blue:0.0 alpha:1];
    }
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
