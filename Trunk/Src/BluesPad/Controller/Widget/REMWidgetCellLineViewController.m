//
//  REMWidgetCellLineViewController.m
//  Blues
//
//  Created by 徐 子龙 on 13-7-15.
//
//

#import "REMWidgetCellLineViewController.h"
@interface REMWidgetCellLineViewController ()
@property  (nonatomic) NSNumber *currentSelectedIndex;
@property  (nonatomic,strong) NSMutableArray *datasource;
@end
@implementation REMWidgetCellLineViewController

- (void)initChart
{
    [self initData];
    [self initLineChart];
}

- (void)initData
{
    int amountOfSeries = [self.data.targetEnergyData count];
    int amountOfPoint = 0;
    
    self.datasource = [[NSMutableArray alloc]initWithCapacity:amountOfSeries];
    
    for (int i = 0; i < amountOfSeries; i++) {
        REMTargetEnergyData* seriesData = [self.data.targetEnergyData objectAtIndex:i];
        
        NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%llu", i, seriesData.target.type, seriesData.target.targetId];
        amountOfPoint = [seriesData.energyData count];
        NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:amountOfPoint];
        for (int j = 0; j < amountOfPoint; j++) {
            REMEnergyData* pointData = [seriesData.energyData objectAtIndex:j];
            [data addObject:@{@"y": [[NSDecimalNumber alloc]initWithDecimal:pointData.dataValue], @"x": pointData.localTime}];
        }
        NSDictionary* series = @{ @"identity":targetIdentity, @"color":[REMColor colorByIndex:i], @"data":data};
        [self.datasource addObject:series];
    }
}


- (void)initLineChart
{
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:self.view.bounds];
    
    CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:hostView.frame];
    hostView.hostedGraph=graph;
    
    [REMWidgetAxisHelper decorateAxisSet:graph dataSource:self.datasource startPointIndex:0 endPointIndex:0];
    graph.defaultPlotSpace.delegate = self;
    
    for (int i = 0; i < [self.datasource count]; i++) {
        CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
        CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
        labelStyle.color = [REMColor colorByIndex:i];
        
        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
        scatterStyle.lineColor = [REMColor colorByIndex:i];
        scatterStyle.lineWidth = 1;
        scatterPlot.labelTextStyle = labelStyle;
        scatterPlot.dataSource = self;
        scatterPlot.identifier = [NSNumber numberWithInt:i];
        
        CPTPlotSymbol *symbol = [self getSymbol:i];
        symbol.lineStyle=scatterStyle;
        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
        
        symbol.size=CGSizeMake(7.0, 7.0);
        scatterPlot.plotSymbol=symbol;
        
        
        scatterPlot.dataSource=self;
        scatterPlot.dataLineStyle = scatterStyle;
        [scatterPlot addAnimation:[self columnAnimation] forKey:@"y"];
        scatterPlot.delegate = self;
        [graph addPlot:scatterPlot];
    }
    
    [self.chartView addSubview:hostView];
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

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    
    
   // NSLog(@"touchdown x:%f,y:%f",point.x,point.y);
    
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    //CPTGraph* graph = self.chart.graph;
//    NSDecimal plotPoint[2];
//    
//    [space plotPoint:plotPoint forPlotAreaViewPoint:point];
//   // NSUInteger index = CPDecimalUnsignedIntValue(plotPoint[CPCoordinateX]);
//    
//    plotPoint[0] = [[NSDecimalNumber numberWithDouble:0] decimalValue];
//    plotPoint[1] = [[NSDecimalNumber numberWithDouble:0] decimalValue];
//    CGPoint p = [space plotAreaViewPointForPlotPoint:plotPoint];
//    plotPoint[0] = [[NSDecimalNumber numberWithDouble:1] decimalValue];
//    plotPoint[1] = [[NSDecimalNumber numberWithDouble:1] decimalValue];
//    CGPoint p2 = [space plotAreaViewPointForPlotPoint:plotPoint];
//    plotPoint[0] = [[NSDecimalNumber numberWithDouble:10] decimalValue];
//    plotPoint[1] = [[NSDecimalNumber numberWithDouble:10] decimalValue];
//    CGPoint p3 = [space plotAreaViewPointForPlotPoint:plotPoint];
//    
//    NSLog(@"touchdown2 x:%d y:%d",plotPoint[0],plotPoint[1]);
    
    return YES;
}

- (CPTPlotSymbol *) getSymbol:(int) index
{
    CPTPlotSymbol *symbol;
    switch (index) {
        case 0:
            symbol = [CPTPlotSymbol diamondPlotSymbol];
            break;
        case 1:
            symbol=    [CPTPlotSymbol rectanglePlotSymbol];
            break;
        case 2:
            symbol=[CPTPlotSymbol trianglePlotSymbol];
            break;
        case 3:
            symbol=[CPTPlotSymbol snowPlotSymbol];
            break;
        case 4:
            symbol =[CPTPlotSymbol starPlotSymbol];
            break;
        case 5:
            symbol=[CPTPlotSymbol pentagonPlotSymbol];
            break;
        case 6:
            symbol = [CPTPlotSymbol hexagonPlotSymbol];
            break;
        case 7:
            symbol = [CPTPlotSymbol ellipsePlotSymbol];
            break;
        case 8:
            symbol=[CPTPlotSymbol crossPlotSymbol];
            break;
        case 9:
            symbol=[CPTPlotSymbol plusPlotSymbol];
            break;
        default:
            symbol = [CPTPlotSymbol diamondPlotSymbol];
            break;
    }
    return symbol;
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
