//
//  REMBuildingTrendChartController.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/8/13.
//
//

#import "REMBuildingTrendChartController.h"

@implementation REMBuildingTrendChartController

- (void)changeData:(REMEnergyViewData *)data
{
    self.data = data;
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
    
    
    
    for (int i = 0; i < [self.datasource count]; i++) {
        CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] initWithFrame:self.hostView.hostedGraph.bounds];
        CPTMutableTextStyle* labelStyle = [CPTMutableTextStyle alloc];
        labelStyle.color = [REMColor colorByIndex:i];
        
        CPTMutableLineStyle* scatterStyle = [CPTMutableLineStyle lineStyle];
        scatterStyle.lineColor = [REMColor colorByIndex:i];
        scatterStyle.lineWidth = 1;
        scatterPlot.labelTextStyle = labelStyle;
        scatterPlot.dataSource = self;
        scatterPlot.identifier = [NSNumber numberWithInt:i];
        
        CPTPlotSymbol *symbol = [CPTPlotSymbol diamondPlotSymbol];
        symbol.lineStyle=scatterStyle;
        symbol.fill= [CPTFill fillWithColor:scatterStyle.lineColor];
        
        symbol.size=CGSizeMake(7.0, 7.0);
        scatterPlot.plotSymbol=symbol;
        
        
        scatterPlot.dataSource=self;
        scatterPlot.dataLineStyle = scatterStyle;
        [scatterPlot addAnimation:[self columnAnimation] forKey:@"y"];
        scatterPlot.delegate = self;
        [self.hostView.hostedGraph addPlot:scatterPlot];
    }
    
    [REMWidgetAxisHelper decorateAxisSet:self.hostView.hostedGraph dataSource:self.datasource startPointIndex:0 endPointIndex:0];
}


- (void)initLineChart:(CGRect)frame
{
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:frame];
    
    CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:frame];
    hostView.hostedGraph=graph;
    
    graph.defaultPlotSpace.delegate = self;
    
//    for (int i = 0; i < [self.datasource count]; i++) {
//        CPTScatterPlot *scatterPlot = [[CPTScatterPlot alloc] initWithFrame:graph.bounds];
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
//        CPTPlotSymbol *symbol = [self getSymbol:i];
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
//        [graph addPlot:scatterPlot];
//    }
    self.hostView = hostView;
   // [self.chartView addSubview:hostView];
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
