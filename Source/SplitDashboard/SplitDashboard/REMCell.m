//
//  REMCell.m
//  Dashboard
//
//  Created by TanTan on 6/18/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import "REMCell.h"
#import "REMEnergyData.h"

@interface REMCell()
@property (nonatomic,strong) REMEnergyData *data;
@property (nonatomic,strong) NSMutableArray *colors;
@property  BOOL hasInit;
@end

@implementation REMCell

- (BOOL)isInitialized
{
    return self.hasInit;
}


- (void)initChart
{
    [self initLineData];
    [self initColor];
    [self loadLineChart];
    self.hasInit=YES;
}


- (void)initLineData
{
    REMEnergyData *energyData = [[REMEnergyData alloc] init];
    energyData.series = [[NSMutableArray alloc] initWithCapacity:10];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *beginDate=[formatter dateFromString:@"2013-01-01 00:00:00"];
    NSTimeInterval beginInterval=[beginDate timeIntervalSince1970];
    NSLog(@"start:%f",beginInterval);
    
    for(int i=1;i<=5;i++)
    {
        REMSeries *series= [[REMSeries alloc] init];
        series.uid=[NSString stringWithFormat:@"Plot%d",i ];
        
        series.data = [[NSMutableArray alloc] initWithCapacity:100];
        
        NSTimeInterval interval=beginInterval;
        
        
        for(int j=1;j<=500;j++)
        {
            NSNumber *xValue=[NSNumber numberWithDouble:j];
            NSNumber *yValue=[NSNumber numberWithInt:35+i*10];
            
            interval+=60*60;// one hour
            
            //NSLog(@"x:%@",xValue);
            
            
            NSArray *array=@[xValue,yValue,[NSNumber numberWithLongLong:interval]];
            [series.data addObject:array];
            
            
        }
        [energyData.series addObject:series];
        
    }
    self.data=energyData;
}

- (void) initColor
{
    NSArray *hexColor=@[
                        @"#30a0d4",
                        @"#9ac350",
                        @"#9d6ba4",
                        @"#aa9465",
                        @"#74939b",
                        @"#b9686e",
                        @"#6887c5",
                        @"#8aa386",
                        @"#b93d95",
                        @"#c2c712",
                        @"#c8693f",
                        @"#718b80",
                        @"#908d52",
                        @"#3187b7",
                        @"#4098a7"];
    self.colors = [[NSMutableArray alloc] initWithCapacity:hexColor.count];
    for(NSString *str in hexColor)
    {
        unsigned rgbValue=0;
        NSScanner *scanner = [NSScanner scannerWithString:str];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        [self.colors addObject:[CPTColor colorWithComponentRed:
                                ((rgbValue & 0xFF0000)>>16)/255.00
                                                         green:((rgbValue & 0xFF00) >> 8)/255.00
                                                          blue:((rgbValue & 0xFF)/255.00) alpha:1.0]];
    }
    
    
}

- (void) loadLineChart
{
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    
    CPTXYGraph *graph = [[CPTXYGraph alloc]  initWithFrame:hostView.bounds];
    graph.plotAreaFrame.masksToBorder=NO;
    
    graph.plotAreaFrame.paddingTop=0.0f;
    graph.plotAreaFrame.paddingRight=20.0f;
    graph.plotAreaFrame.paddingBottom=30.0f;
    graph.plotAreaFrame.paddingLeft=30.0f;
    graph.paddingBottom=30;
    hostView.hostedGraph=graph;
    
    
    
    
    CPTXYAxis* x= [[CPTXYAxis alloc] init];
    
    x.coordinate = CPTCoordinateX;
    
    [self setTickPosition:x];
    
    
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0f];
    
    CPTPlotRange *bandRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(10) length:CPTDecimalFromInt(20)];
    CPTLimitBand *band= [CPTLimitBand limitBandWithRange:bandRange fill:[CPTFill fillWithColor:[CPTColor lightGrayColor]]];
    //[x addBackgroundLimitBand:band];
    
    CPTXYAxis *y= [[ CPTXYAxis alloc]init];
    y.coordinate=CPTCoordinateY;
    y.majorIntervalLength=CPTDecimalFromInt(40);
    
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    
    CPTXYPlotSpace *plotSpace=(CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.allowsUserInteraction=YES;
    plotSpace.delegate=self;
    
    
    plotSpace.xRange= [CPTPlotRange plotRangeWithLocation:CPTDecimalFromLong(0) length:CPTDecimalFromInt(15)];
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(200)];
    
    
    CPTMutablePlotRange *visibleXRange=[plotSpace.xRange mutableCopy];
    CPTMutablePlotRange *visibleYRange=[plotSpace.yRange mutableCopy];
    [visibleXRange expandRangeByFactor:CPTDecimalFromFloat(1.025)];
    visibleXRange.location=plotSpace.xRange.location;
    x.visibleRange=visibleXRange;
    [visibleYRange expandRangeByFactor:CPTDecimalFromFloat(1.05)];
    y.visibleRange=visibleYRange;
    CPTMutablePlotRange *globalXRange=[plotSpace.xRange mutableCopy];
    [globalXRange setLength:CPTDecimalFromFloat(250.0f)];
    plotSpace.globalXRange=globalXRange;
    
    
    
    x.plotSpace=plotSpace;
    y.plotSpace=plotSpace;
    
    y.gridLinesRange = plotSpace.yRange;
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc]init];
    gridLineStyle.lineWidth=1.0f;
    gridLineStyle.lineColor=[CPTColor lightGrayColor];
    y.majorGridLineStyle=gridLineStyle;
    y.axisConstraints=[CPTConstraints constraintWithLowerOffset:0.0f];
    y.minorTickLength=0;
    CPTXYPlotSpace *y1Space= [[CPTXYPlotSpace alloc]init];
    y1Space.identifier=@"y1";
    y1Space.xRange=plotSpace.xRange;
    y1Space.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(500)];
    y1Space.delegate=self;
    y1Space.allowsUserInteraction=YES;
    [graph addPlotSpace:y1Space];
    
    CPTXYAxis *y1 =[[CPTXYAxis alloc]init];
    y1.tickDirection = CPTSignPositive;
    y1.coordinate=CPTCoordinateY;
    y1.majorIntervalLength=CPTDecimalFromInt(100);
    y1.minorTickAxisLabels=nil;
    y1.minorTickLocations=nil;
    y1.minorTickLength=0.0f;
    y1.orthogonalCoordinateDecimal=CPTDecimalFromInt(50);
    y1.plotSpace=y1Space;
    
    
    y1.axisConstraints=[CPTConstraints constraintWithUpperOffset:0.0f];
    
    CPTXYAxisSet *axisSet= [[CPTXYAxisSet alloc] init];
    
    axisSet.axes =[NSArray arrayWithObjects:x,y, y1,nil];
    
    graph.axisSet=axisSet;
    
    
    //adding animation here
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    [anim setDuration:0.5f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    int idx=0;
    for(REMSeries *series in self.data.series)
    {
        CPTScatterPlot *line = [[CPTScatterPlot alloc] initWithFrame:graph.bounds ];
        line.identifier=series.uid;
        line.anchorPoint=CGPointZero;
        CPTMutableLineStyle *style=[[CPTMutableLineStyle alloc] init];
        style.lineWidth=1.5;
        style.lineColor= [self getColor:idx];
        
        line.dataLineStyle=style;
        
        
        CPTPlotSymbol *symbol = [self getSymbol:idx];
        symbol.lineStyle=style;
        symbol.fill= [CPTFill fillWithColor:style.lineColor];
        
        symbol.size=CGSizeMake(7.0, 7.0);
        line.plotSymbol=symbol;
        
        
        line.delegate=self;
        line.dataSource=self;
        if(idx % 2 == 0){
            [graph addPlot:line toPlotSpace:y1Space];
        }
        else{
            [graph addPlot:line toPlotSpace:plotSpace];
        }
        idx++;
        
        [line addAnimation:anim forKey:@"grow"];
        
    }
    
    
    
    
    x.anchorPoint=CGPointZero;
    [x addAnimation:anim forKey:@"grow-x"];
    
    CABasicAnimation *yanim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [yanim setDuration:1.0f];
    
    yanim.toValue = [NSNumber numberWithFloat:1];
    yanim.fromValue = [NSNumber numberWithFloat:0.0f];
    yanim.removedOnCompletion = NO;
    yanim.delegate = self;
    yanim.fillMode = kCAFillModeForwards;
    y.anchorPoint=CGPointZero;
    [y addAnimation:yanim forKey:@"grow-y" ];
    y1.anchorPoint=CGPointZero;
    [y1 addAnimation:yanim forKey:@"grow-y1"];
    

    
    
    [self.chartView addSubview:hostView];
    
}



- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)space.graph.axisSet;
    
    CPTMutablePlotRange *range=[newRange mutableCopy];
    
    NSLog(@"range.location:%f",newRange.locationDouble);
    
    if (newRange.locationDouble<0) {
        range.location=CPTDecimalFromFloat(0.0f);
    }
    
    
    CPTMutablePlotRange *changedRange;
    
    if (coordinate ==CPTCoordinateX )
    {
        NSLog(@"range.length:%f",newRange.lengthDouble);
        
        if(newRange.locationDouble>90)
        {
            range.location=CPTDecimalFromFloat(90.0f);
            
        }
        changedRange=[range mutableCopy];
        [changedRange expandRangeByFactor:CPTDecimalFromFloat(1.025)];
        changedRange.location=range.location;
        CPTXYAxis *x=axisSet.axes[0];
        x.visibleRange=changedRange;
        
    }
    else
    {
        changedRange=[range mutableCopy];
        [changedRange expandRangeByFactor:CPTDecimalFromFloat(1.05)];
        //axisSet.yAxis.visibleRange=changedRange;
        if ([space.identifier isEqual:@"y1"] == YES) {
            CPTXYAxis *y1=axisSet.axes[2];
            y1.visibleRange=changedRange;
        }
        else
        {
            CPTXYAxis *y= axisSet.axes[1];
            y.visibleRange=changedRange;
        }
        
    }
    
    return range;
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

- (CPTColor *) getColor:(int)index
{
    return [self.colors objectAtIndex:index];
}

-(void)setTickPosition: (CPTAxis *)xAxis
{
    REMSeries *series=(REMSeries *)self.data.series[0];
    
    NSMutableArray *locations= [[NSMutableArray alloc]initWithCapacity:series.data.count];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSMutableArray *tickLocations=[[NSMutableArray alloc]initWithCapacity:series.data.count];
    
    NSLog(@"data length:%d",series.data.count);
    for (int i=1;i<series.data.count;i+=8) {
        NSNumber *xVal=series.data[i][2];
        NSDate *date= [NSDate dateWithTimeIntervalSince1970:[xVal doubleValue] ];
        
        NSString *text=[formatter stringFromDate:date];
        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:text
                                                      textStyle:xAxis.labelTextStyle];
        label.tickLocation= CPTDecimalFromInt(i);
        label.offset=5;
        //NSLog(@"label:%@",text);
        [locations addObject:label];
        [tickLocations addObject:[NSNumber numberWithInt:i]];
    }
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    xAxis.majorTickLocations=[NSSet setWithArray:tickLocations];
    xAxis.minorTickLength=0.0f;
    xAxis.axisLabels= [NSSet setWithArray:locations];
    
    
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if([plot.identifier isEqual:@"indicator"] == YES)
    {
        return 1;
    }
    
    REMSeries *series= (REMSeries *)self.data.series[0];
    
    return series.data.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    
    
    
    NSNumber *num;
    CPTScatterPlot *line = (CPTScatterPlot *)plot;
    for (REMSeries *series in self.data.series){
        
        if([line.identifier isEqual:series.uid] == YES)
        {
            if(fieldEnum == CPTScatterPlotFieldX)
            {
                num= ((NSArray *)series.data[idx])[0];
                
            }
            else
            {
                num= ((NSArray *)series.data[idx])[1];
                
            }
            break;
        }
    }
    
    
    return num;
}

- (void)scatterPlot:(CPTScatterPlot *)plot plotSymbolWasSelectedAtRecordIndex:(NSUInteger)idx
{
    for(REMSeries *series in self.data.series)
    {
        //NSLog(@"series.id:%@",series.uid);
        if([series.uid isEqual:plot.identifier] == YES)
        {
            NSNumber *value=series.data[idx][1];
            NSString *text=[value stringValue];
        }
    }
}


@end
