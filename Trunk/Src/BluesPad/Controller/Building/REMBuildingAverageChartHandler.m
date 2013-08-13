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
    
    [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.view.layer.borderColor = [UIColor redColor].CGColor;
    //self.view.layer.borderWidth = 1.0;
    //self.view.backgroundColor = [UIColor yellowColor];
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageData :(void (^)(void))loadCompleted
{
    
    self.averageData = averageData;
    
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
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc]init];
    gridLineStyle.lineWidth=1.0f;
    gridLineStyle.lineColor=[CPTColor lightGrayColor];
    
    //x axis
    CPTXYAxis* x= [[CPTXYAxis alloc] init];
    x.coordinate = CPTCoordinateX;
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    x.plotSpace = plotSpace;
    x.visibleRange = plotSpace.xRange;
    x.axisLineStyle = axisLineStyle;
    x.anchorPoint=CGPointZero;
    
    //y axis
    CPTXYAxis* y= [[CPTXYAxis alloc] init];
    y.coordinate = CPTCoordinateY;
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    y.plotSpace = plotSpace;
    y.visibleRange = plotSpace.yRange;
    y.anchorPoint=CGPointZero;
    
    y.gridLinesRange = plotSpace.yRange;
    y.majorIntervalLength = CPTDecimalFromFloat(self.dataValueRange.end/4);
    y.majorGridLineStyle = gridLineStyle;
    
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
    column.barWidth=CPTDecimalFromFloat(10);
    column.barOffset=CPTDecimalFromInt(5);
    
    column.fill= [CPTFill fillWithColor:[CPTColor whiteColor]];
    
    column.baseValue=CPTDecimalFromFloat(0);
    
    column.dataSource=self;
    column.delegate=self;
    
    column.lineStyle=nil;
    column.shadow=nil;
    
    column.anchorPoint=CGPointZero;
    
    [self.chartView.graph addPlot:column];
    
    //bench mark - line
    CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 1;
    
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
        
        self.visiableRange.start = MIN(self.visiableRange.start, [target.visiableTimeRange.startTime timeIntervalSince1970]/1000);
        self.visiableRange.end = MAX(self.visiableRange.end, [target.visiableTimeRange.endTime timeIntervalSince1970]/1000);
        
        for (int j = 0; j < energyData.count; j++)
        {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            NSDecimalNumber *value = [[NSDecimalNumber alloc] initWithDecimal:point.dataValue];
            [data addObject:@{@"y": value, @"x": point.localTime}];
            
            self.globalRange.start = MIN(self.globalRange.start, [point.localTime timeIntervalSince1970]/1000);
            self.globalRange.end = MAX(self.globalRange.end, [point.localTime timeIntervalSince1970]/1000);
            
            self.dataValueRange.start = MIN(self.dataValueRange.start, [value doubleValue]);
            self.dataValueRange.end = MAX(self.dataValueRange.end, [value doubleValue]);
        }
        NSDictionary* series = @{ @"identity":targetIdentity, @"data":data};
        
        [convertedData addObject:series];
        index ++;
    }

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

@end
