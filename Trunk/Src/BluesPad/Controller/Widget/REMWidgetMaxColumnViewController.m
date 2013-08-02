//
//  REMWidgetMaxColumnViewController.m
//  Blues
//
//  Created by 谭 坦 on 7/18/13.
//
//

#import "REMWidgetMaxColumnViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "REMWidgetAxisHelper.h"
#import "REMWidgetMaxViewController.h"

@interface REMWidgetMaxColumnViewController()

@property (nonatomic,strong) CPTXYGraph *graph;
@property (nonatomic,strong) NSMutableArray *chartData;
@property (nonatomic) double maxEnergyValue;
@property (nonatomic) NSInteger maxDateIndex;

@end

@implementation REMWidgetMaxColumnViewController

- (void)initDiagram
{
    [self initData];
    [self drawChart];
}


- (void)initData
{
    int seriesCount = self.data.targetEnergyData.count;
    self.maxDateIndex = 0;
    self.maxEnergyValue = 0;
    
    self.chartData = [[NSMutableArray alloc]initWithCapacity:seriesCount];
    
    for (int i = 0; i < seriesCount; i++)
    {
        REMTargetEnergyData *targetEnergyData = (REMTargetEnergyData *)self.data.targetEnergyData[i];
        REMEnergyTargetModel *target = targetEnergyData.target;
        NSArray *energyData = targetEnergyData.energyData;
        
        NSString* targetIdentity = [NSString stringWithFormat:@"%d-%d-%llu", i, target.type, target.targetId];
        
        NSMutableArray* data = [[NSMutableArray alloc]initWithCapacity:energyData.count];
        for (int j = 0; j < energyData.count; j++)
        {
            REMEnergyData *point = (REMEnergyData *)energyData[j];
            [data addObject:@{@"y": [[NSDecimalNumber alloc] initWithDecimal:point.dataValue], @"x": point.localTime}];
            
            if(j>self.maxDateIndex)
                self.maxDateIndex = j;
            
            if([[[NSDecimalNumber alloc] initWithDecimal:point.dataValue] doubleValue] > self.maxEnergyValue)
                self.maxEnergyValue = [[[NSDecimalNumber alloc] initWithDecimal:point.dataValue] doubleValue];
        }
        NSDictionary* series = @{ @"identity":targetIdentity, @"color":[REMColor colorByIndex:i], @"data":data};
        
        [self.chartData addObject:series];
    }
    
    self.maxDateIndex += 1;
}


- (void) drawChart
{
    //Declare graph
    self.graph=[[CPTXYGraph alloc]initWithFrame:self.chartView.bounds];
    self.graph.plotAreaFrame.paddingTop=0.0f;
    self.graph.plotAreaFrame.paddingRight=10.0f;
    self.graph.plotAreaFrame.paddingBottom=40.0f;
    self.graph.plotAreaFrame.paddingLeft=50.0f;
    
    //Init host view
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:self.chartView.bounds];
    hostView.hostedGraph=self.graph;
    
    [REMWidgetAxisHelper decorateAxisSet:self.graph dataSource:self.chartData startPointIndex:0 endPointIndex:0 yStartZero:YES];
    
    [self drawColumns];
    
    [self.chartView addSubview:hostView];
}


- (void) drawColumns
{
    int offset = [self firstColumnOffset];
    
    for(int i=0;i< self.chartData.count;i++)
    {
        CPTBarPlot *column=[[CPTBarPlot alloc] initWithFrame:self.graph.bounds];
        
        //index-type-targetid
        column.identifier=[self.chartData[i] objectForKey:@"identity"];
        
        column.barBasesVary=NO;
        column.barWidthsAreInViewCoordinates=YES;
        column.barWidth=CPTDecimalFromFloat([self columnWidth]);
        column.barOffset=CPTDecimalFromInt(offset);
        
        column.fill= [CPTFill fillWithColor:[REMColor colorByIndex:i]];
        
        column.baseValue=CPTDecimalFromFloat(0);
        
        column.dataSource=self;
        column.delegate=self;
        
        column.lineStyle=nil;
        column.shadow=nil;
        
        column.anchorPoint=CGPointZero;
        
        [column addAnimation:[self columnAnimation] forKey:@"grow"];
        
        [self.graph addPlot:column];
        
        offset+=[self columnWidth] + [self columnSpaceWidth];
    }
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

- (float) firstColumnOffset
{
    return (0 - [self seriesWidth] / 2) + ([self columnWidth] / 2) ;
}

- (float) columnWidth
{
    int totalColumns = self.maxDateIndex * self.chartData.count;
    
    return ([self totalColumnAreaWidth] / totalColumns) - [self columnSpaceWidth];
}

- (float) columnSpaceWidth
{
    float spaceWidth = [self seriesWidth] / (self.chartData.count+2) / (self.chartData.count + 2) ;
    
    return spaceWidth>1?spaceWidth:1;
}

- (float) seriesWidth
{
    return [self totalColumnAreaWidth] / self.maxDateIndex;
}

- (float) totalColumnAreaWidth
{
    return [self totalChartAreaWidth] * (self.chartData.count-1) / (self.chartData.count);
}

- (float) totalSeriesSpaceWidth
{
    return [self totalChartAreaWidth] - [self totalColumnAreaWidth];
}

- (float) totalChartAreaWidth
{
    //how width is the chart
    float chartWidth = self.graph.bounds.size.width - self.graph.paddingLeft - self.graph.paddingRight;
    
    //only count/(count+1) of total space can be used for drawing columns
    float totalChartSpace = chartWidth * self.chartData.count / (self.chartData.count + 1);
    
    return totalChartSpace;
}

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(CPTNativeEvent *)event
{
    int index = [self indexOfPlot:plot] ;
    NSDictionary* pointData = [[[self.chartData objectAtIndex:index] objectForKey:@"data"] objectAtIndex:idx];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString* xLabelOfPoint = [formatter stringFromDate: [pointData objectForKey:@"x"]] ;
    NSNumber *yVal = [pointData objectForKey:@"y"];
    REMWidgetMaxViewController* m = self.maxViewController;
    [m.tooltipLabel setText:[NSString stringWithFormat:@"Time:%@ Value:%@", xLabelOfPoint, yVal]];
}

#pragma mark - CPTBarPlotDataSource members

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

- (NSInteger) indexOfPlot:(CPTPlot *)plot
{
    NSArray *plotIdentifierComponents = [((NSString *)plot.identifier) componentsSeparatedByString:@"-"];
    NSInteger plotIndex = [[plotIdentifierComponents objectAtIndex:0] intValue];

    return plotIndex;
}

@end
