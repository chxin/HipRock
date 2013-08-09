//
//  REMBuildingTrendChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingTrendChartHandler.h"
#import "REMBuildingTrendChart.h"

@interface REMBuildingTrendChartHandler ()

@end

@implementation REMBuildingTrendChartHandler

- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        REMBuildingTrendChart* myView = [[REMBuildingTrendChart alloc] initWithFrame:frame];
        //((REMBuildingTrendChart*)(self.view)).chartController = self;
        myView.hostView.hostedGraph.defaultPlotSpace.delegate = self;
        myView.scatterPlot.dataSource = self;
        myView.scatterPlot.delegate = self;
        
        self.view = myView;
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMBuildingOverallModel *)buildingOverall :(void (^)(void))loadCompleted
{
    
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
    NSNumber *index = (NSNumber*)(plot.identifier);
    NSDictionary* datasource = [self.datasource objectAtIndex:[index integerValue]];
    NSMutableArray* data = [datasource objectForKey:@"data"];
    return data.count;
}



- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    
    NSNumber *index = (NSNumber*)(plot.identifier);
    NSDictionary* datasource = [self.datasource objectAtIndex:[index integerValue]];
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
