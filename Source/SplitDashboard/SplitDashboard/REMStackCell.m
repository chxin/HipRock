//
//  REMViewController.m
//  StackChartDemo
//
//  Created by TanTan on 6/6/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import "REMStackCell.h"
#import "CorePlot-CocoaTouch.h"


@interface REMStackCell ()
@property (nonatomic,retain) CPTXYGraph* stackGraph;
@property (nonatomic,retain) NSMutableArray* dataArray;
@property (nonatomic,retain) NSMutableArray* seriesArray;
@property (nonatomic) BOOL hasInit;
@property (nonatomic,strong) NSMutableArray *colors;
@end

@implementation REMStackCell

- (BOOL)isInitialized
{
    return self.hasInit;
}

- (void)initChart
{
    
    [self initDataArray];
    [self initColor];
    [self initGraph];
    self.hasInit=YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (CPTColor *) getColor:(int)index
{
    return [self.colors objectAtIndex:index];
}

- (void)initDataArray
{
    NSArray *data = @[@10,@15,@20,@25,@30];
    
    self.dataArray = [[NSMutableArray alloc] initWithObjects:nil];
    for(int i=0;i<data.count;i++)
    {
        NSNumber *idx= [NSNumber numberWithInt:(i+1)*10];
        NSLog(@"x:%@,y:%@",idx,data[i]);
        NSDictionary* one = @{@"x": idx,@"y":data[i]};
        [self.dataArray addObject:one];
    }
    
    self.seriesArray = [[NSMutableArray alloc] initWithCapacity:3];
    NSDictionary* first =@{@"color":[UIColor blueColor],@"id":@"plot1"};
    NSDictionary* second =@{@"color":[UIColor redColor],@"id":@"plot2"};
    NSDictionary* third =@{@"color":[UIColor greenColor],@"id":@"plot3"};
    [self.seriesArray addObject:first];
    [self.seriesArray addObject:second];
    [self.seriesArray addObject:third];
}


- (void) initGraph
{
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    CPTXYGraph*   stackGraph = [[CPTXYGraph alloc] initWithFrame:hostView.frame];
    hostView.hostedGraph=stackGraph;
    self.stackGraph=stackGraph;
    
    stackGraph.plotAreaFrame.masksToBorder=NO;
    stackGraph.paddingLeft=0.0f;
    stackGraph.paddingBottom=30.0f;
    stackGraph.paddingRight=0.0f;
    stackGraph.paddingTop=0.0f;
    stackGraph.plotAreaFrame.paddingTop=10.0f;
    stackGraph.plotAreaFrame.paddingRight=10.0f;
    stackGraph.plotAreaFrame.paddingBottom=30.0f;
    stackGraph.plotAreaFrame.paddingLeft=40.0f;
    
    CPTXYAxisSet* axisSet = (CPTXYAxisSet*)stackGraph.axisSet;
    CPTXYAxis* x= axisSet.xAxis;
    
    x.majorIntervalLength=CPTDecimalFromInt(10);
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    
    NSArray* tickPosition=@[@10,@20,@30,@40,@50];
    NSArray* tickLabel=@[@"a",@"b",@"c",@"d",@"e"];
    int pos=0;
    NSMutableArray* xLabels= [NSMutableArray arrayWithCapacity:tickPosition.count];
    for(NSNumber *num in tickPosition)
    {
        CPTAxisLabel* label= [[CPTAxisLabel alloc] initWithText:[tickLabel objectAtIndex:pos++]
                                                      textStyle:x.labelTextStyle];
        
        label.tickLocation=num.decimalValue;
        //label.offset=x.labelOffset+x.;
        
        [xLabels addObject:label];
    }
    
    x.axisLabels = [NSSet setWithArray:xLabels];
    
    CPTXYAxis *y=axisSet.yAxis;
    y.majorIntervalLength=CPTDecimalFromInt(10);
    
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    
    
    CPTXYPlotSpace* plotSpace=(CPTXYPlotSpace*)stackGraph.defaultPlotSpace;
    plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(70)];
    plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(100)];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [anim setDuration:0.5f];
    anim.toValue = [NSNumber numberWithFloat:1.0f];
    
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;

    
    for (int i=0; i<self.seriesArray.count; ++i) {
        CPTBarPlot* barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
        //barPlot.plotRange =[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(10) length:CPTDecimalFromInt(500)];
        barPlot.lineStyle=nil;
        barPlot.anchorPoint=CGPointZero;
        barPlot.fill = [CPTFill fillWithColor:[self getColor:i]];
        barPlot.barOffset=CPTDecimalFromFloat(0.2f);
        barPlot.barCornerRadius=0;
        if(i == 0)
        {
            barPlot.barBasesVary = NO;
        }
        else{
            barPlot.barBasesVary=YES;
            
        }
        barPlot.barWidth=CPTDecimalFromInt(7);
        barPlot.dataSource=self;
        barPlot.identifier=[self.seriesArray[i] objectForKey:@"id"];
        [stackGraph addPlot:barPlot toPlotSpace:plotSpace];
        [barPlot addAnimation:anim forKey:@"grow"];
    }
    
    
    [self.chartView addSubview:hostView];
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

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.dataArray.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    NSDictionary* data=[self.dataArray objectAtIndex:idx];
    
    if(fieldEnum == CPTScatterPlotFieldX)
    {
        return [data valueForKey:@"x"];
    }
    else
    {
        double offset=0;
        CPTBarPlot* bar = (CPTBarPlot*)plot;
        if(bar.barBasesVary){
            for(NSDictionary* obj in self.seriesArray){
                if([[obj objectForKey:@"id"] isEqual: bar.identifier] ){
                    break;
                }
                else{
                    offset+=[((NSNumber*)[data valueForKey:@"y"]) doubleValue];
                }
            }
        }
        
        if(fieldEnum==1){
            return  [NSNumber numberWithDouble: [[data valueForKey:@"y"] doubleValue]+offset];
        }
        else{
            return [NSNumber numberWithDouble:offset];
        }
        
        
    }
}

@end
