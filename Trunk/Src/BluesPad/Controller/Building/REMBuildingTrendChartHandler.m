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
       // myView.scatterPlot.dataSource = self;
      //  myView.scatterPlot.delegate = self;
        
        [myView.todayButton addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
        [myView.yestodayButton addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
        [myView.thisMonthButton addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
        [myView.lastMonthButton addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
        [myView.thisYearButton addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
        [myView.lastYearButton addTarget:self action:@selector(intervalChanged:) forControlEvents:UIControlEventTouchUpInside];
        
        self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
        
        self.view = myView;
        [self viewDidLoad];
    }
    return self;
}

- (void)intervalChanged:(UIButton *)button {
    REMRelativeTimeRangeType t = Today;
    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
    if (button == myView.todayButton) {
        currentSourceIndex = 0;
        t = Today;
    } else if (button == myView.yestodayButton) {
        currentSourceIndex = 1;
        t = Yesterday;
    } else if (button == myView.thisMonthButton) {
        currentSourceIndex = 2;
        t = ThisMonth;
    } else if (button == myView.lastMonthButton) {
        currentSourceIndex = 3;
        t = LastMonth;
    } else if (button == myView.thisYearButton) {
        currentSourceIndex = 4;
        t = ThisYear;
    } else if (button == myView.lastYearButton) {
        currentSourceIndex = 5;
        t = LastYear;
    }
    
    CPTScatterPlot* scatterPlot = [[CPTScatterPlot alloc] initWithFrame: myView.hostView.hostedGraph.bounds];
    CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
    labelStyle.color = [REMColor colorByIndex:0];
    
    CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
    scatterStyle.lineColor = [REMColor colorByIndex:0];
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
    
    [REMWidgetAxisHelper decorateBuildingTrendAxisSet:(CPTXYGraph*)myView.hostView.hostedGraph dataSource:self.datasource interval:t seriesIndex:currentSourceIndex];
    [myView.hostView.hostedGraph addPlot:scatterPlot];
    [myView.hostView.hostedGraph reloadData];
    [scatterPlot reloadData];
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
    REMDataStore *store = [[REMDataStore alloc]initWithName:REMDSEnergyBuildingTimeRange parameter:buildingCommodityInfo];
    store.isAccessLocal = NO;
    store.isStoreLocal = NO;
    store.maskContainer = self.view;
    store.groupName = nil;
    
    void (^retrieveSuccess)(id data)=^(id data) {
        //  [self.chartController changeData:[[REMEnergyViewData alloc] initWithDictionary:(NSDictionary *)data]];
        NSArray* de = (NSArray*)data;
        
        NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for(NSDictionary *item in (NSArray *)data){
            [arr addObject:[[REMBuildingOverallModel alloc] initWithDictionary:item]];
        }
        
       // NSArray* keys  = [de allKeys];
        NSDate* d = [[NSDate alloc]initWithTimeIntervalSince1970:0];
        for (int i = 0; i < 6; i++) {
            NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%u", i, 2, 3];
            NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:20];
            int pointAmount = 12;
            int pointMul = 1;
            if (i == 0 || i == 1) {
                pointAmount = 24;
                pointMul = 1;
            }
            if (i == 2 || i == 3) {
                pointAmount = 30;
                pointMul = 24;
            }
            if (i == 4 || i == 5) {
                pointAmount = 12;
                pointMul = 720;
            }
            for (int j = 0; j < pointAmount; j++) {
                [data addObject:@{@"y": [[NSDecimalNumber alloc]initWithInt:rand()], @"x": [[NSDate alloc]initWithTimeInterval:j*pointMul*3600 sinceDate:d]  }];
            }
            NSDictionary* series = @{ @"identity":targetIdentity, @"color":[REMColor colorByIndex:i], @"data":data};
            [self.datasource addObject:series];
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

- (void)changeData:(REMEnergyViewData *)data
{
//    self.data = data;
//    int amountOfSeries = [self.data.targetEnergyData count];
//    int amountOfPoint = 0;
//    
//    self.datasource = [[NSMutableArray alloc]initWithCapacity:amountOfSeries];
//    
//    for (int i = 0; i < amountOfSeries; i++) {
//        REMTargetEnergyData* seriesData = [self.data.targetEnergyData objectAtIndex:i];
//        
//        NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%llu", i, seriesData.target.type, seriesData.target.targetId];
//        amountOfPoint = [seriesData.energyData count];
//        NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:amountOfPoint];
//        for (int j = 0; j < amountOfPoint; j++) {
//            REMEnergyData* pointData = [seriesData.energyData objectAtIndex:j];
//            [data addObject:@{@"y": [[NSDecimalNumber alloc]initWithDecimal:pointData.dataValue], @"x": pointData.localTime}];
//        }
//        NSDictionary* series = @{ @"identity":targetIdentity, @"color":[REMColor colorByIndex:i], @"data":data};
//        [self.datasource addObject:series];
//    }
//    
//    
//    
//    for (int i = 0; i < [self.datasource count]; i++) {
//        CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] initWithFrame:self.hostView.hostedGraph.bounds];
//        CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
//        labelStyle.color = [REMColor colorByIndex:i];
//        
//        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
//        scatterStyle.lineColor = [REMColor colorByIndex:i];
//        scatterStyle.lineWidth = 1;
//        scatterPlot.labelTextStyle = labelStyle;
//        scatterPlot.dataSource = self;
//        scatterPlot.identifier = [NSNumber numberWithInt:i];
//        
//        CPTPlotSymbol *symbol = [CPTPlotSymbol diamondPlotSymbol];
//        symbol.lineStyle=scatterStyle;
//        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
//        
//        symbol.size=CGSizeMake(7.0, 7.0);
//        scatterPlot.plotSymbol=symbol;
//        
//        
//        scatterPlot.dataSource=self;
//        scatterPlot.dataLineStyle = scatterStyle;
//        [scatterPlot addAnimation:[self columnAnimation] forKey:@"y"];
//        scatterPlot.delegate = self;
//        [self.hostView.hostedGraph addPlot:scatterPlot];
//    }
//    
//    [REMWidgetAxisHelper decorateAxisSet:self.hostView.hostedGraph dataSource:self.datasource startPointIndex:0 endPointIndex:0];
}


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
        return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
    }
    else
    {
        return [item objectForKey:@"y"];
    }
}

@end
