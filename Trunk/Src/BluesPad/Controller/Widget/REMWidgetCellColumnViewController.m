//
//  REMWidgetCellColumnViewController.m
//  Blues
//
//  Created by zhangfeng on 7/11/13.
//
//

#import "REMWidgetCellColumnViewController.h"
#import "CPTGraphHostingView.h"
#import "CPTXYGraph.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetAxisHelper.h"
#import "REMTimeHelper.h"

@interface REMWidgetCellColumnViewController ()

@property (nonatomic,strong) CPTXYGraph *graph;
@property (nonatomic,strong) NSMutableArray *chartData;
@property (nonatomic) double maxEnergyValue;
@property (nonatomic) NSInteger maxDateIndex;

@end

@implementation REMWidgetCellColumnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initChart
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
    self.graph=[[CPTXYGraph alloc]initWithFrame:self.view.bounds];
    self.graph.plotAreaFrame.paddingTop=0.0f;
    self.graph.plotAreaFrame.paddingRight=10.0f;
    self.graph.plotAreaFrame.paddingBottom=40.0f;
    self.graph.plotAreaFrame.paddingLeft=50.0f;
    
    //Init host view
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:self.view.bounds];
    hostView.hostedGraph=self.graph;
    
    [REMWidgetAxisHelper decorateAxisSet:self.graph dataSource:self.chartData startPointIndex:0 endPointIndex:0 yStartZero:YES];
    
//    //build plot space
//    [self buildPlotSpace];
//    
//    //draw x axis
//    //[self drawXAxis];
//    
//    //draw y axises
//    [self drawAxises];
    
    //Draw columns
    [self drawColumns];

    [self.chartView addSubview:hostView];
}

- (void) buildPlotSpace
{
    //REMTimeRange *visableTimeRange = [self visableTimeRange];
    //REMTimeRange *globalTimeRange = self.chartData.count == 1? [self globalTimeRange]:visableTimeRange;
    
    double visableRangeStart = -1;// [visableTimeRange.startTime timeIntervalSince1970];
    double visableRangeEnd = self.maxDateIndex;//[visableTimeRange.endTime timeIntervalSince1970];
    double globalRangeStart = -1;// [globalTimeRange.startTime timeIntervalSince1970];
    double globalRangeEnd = self.maxDateIndex;//[globalTimeRange.endTime timeIntervalSince1970];
    
    if(self.chartData.count == 1)
    {
        //visableRangeStart =
    }
    
    double visableRangeLength = visableRangeEnd - visableRangeStart;
    double globalRangeLength = globalRangeEnd - globalRangeStart;
    
    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(visableRangeStart) length:CPTDecimalFromDouble(visableRangeLength)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromDouble(self.maxEnergyValue*1.1)];
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(globalRangeStart) length:CPTDecimalFromDouble(globalRangeLength)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromDouble(self.maxEnergyValue*1.1)];
}

- (void) drawAxises
{
    CPTXYAxisSet *axisSet= [[CPTXYAxisSet alloc] init];
    
    NSMutableArray *axisArray = [[NSMutableArray alloc] init];
    [axisArray addObject:[self buildXAxis]];
    [axisArray addObjectsFromArray:[self buildYAxises]];
    
    axisSet.axes = axisArray;
    
    self.graph.axisSet= axisSet;
}

- (CPTXYAxis *) buildXAxis
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    CPTXYAxis* x= [[CPTXYAxis alloc] init];
    x.coordinate = CPTCoordinateX;
    x.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    x.plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    x.visibleRange = plotSpace.xRange;
    x.anchorPoint=CGPointZero;
    
    return x;
}

- (NSArray *) buildYAxises
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;

    CPTMutableLineStyle *hiddenLineStyle = [CPTMutableLineStyle lineStyle];
    hiddenLineStyle.lineWidth = 0;
    
    CPTXYAxis* y= [[CPTXYAxis alloc] init];
    y.coordinate = CPTCoordinateY;
    y.orthogonalCoordinateDecimal=CPTDecimalFromInt(0);
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
    y.majorTickLineStyle = hiddenLineStyle;
    y.minorTickLineStyle = hiddenLineStyle;
    y.axisLineStyle = hiddenLineStyle;
    
    y.majorIntervalLength = CPTDecimalFromFloat(self.maxEnergyValue/4);
    
    y.gridLinesRange = plotSpace.xRange;
    CPTMutableLineStyle *gridLineStyle=[[CPTMutableLineStyle alloc]init];
    gridLineStyle.lineWidth=1.0f;
    gridLineStyle.lineColor=[CPTColor lightGrayColor];
    y.majorGridLineStyle = gridLineStyle;
    
    y.plotSpace = plotSpace;
    y.anchorPoint=CGPointZero;
    
    return [NSArray arrayWithObject:y];
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

- (REMTimeRange *)globalTimeRange
{
    if(self.data.targetEnergyData.count == 1)
        return [(REMTargetEnergyData *)self.data.targetEnergyData[0] target].visiableTimeRange;
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.data.targetEnergyData.count];
        for(REMTargetEnergyData *targetData in self.data.targetEnergyData)
        {
            [array addObject:targetData.target.globalTimeRange];
        }
        return [REMTimeHelper maxTimeRangeOfTimeRanges:array];
    }
}

- (REMTimeRange *)visableTimeRange
{
    if(self.data.targetEnergyData.count == 1)
        return [(REMTargetEnergyData *)self.data.targetEnergyData[0] target].visiableTimeRange;
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.data.targetEnergyData.count];
        for(REMTargetEnergyData *targetData in self.data.targetEnergyData)
        {
            [array addObject:targetData.target.visiableTimeRange];
        }
        return [REMTimeHelper maxTimeRangeOfTimeRanges:array];
    }
}

#pragma mark - CPTBarPlotDataSource members

/// @name Data Values
/// @{

/** @brief @required The number of data points for the plot.
 *  @param plot The plot.
 *  @return The number of data points for the plot.
 **/
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

//@optional

/** @brief @optional Gets a range of plot data for the given plot and field.
 *  Implement one and only one of the optional methods in this section.
 *  @param plot The plot.
 *  @param fieldEnum The field index.
 *  @param indexRange The range of the data indexes of interest.
 *  @return An array of data points.
 **/
//-(NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
//{
//}

/** @brief @optional Gets a plot data value for the given plot and field.
 *  Implement one and only one of the optional methods in this section.
 *  @param plot The plot.
 *  @param fieldEnum The field index.
 *  @param idx The data index of interest.
 *  @return A data point.
 **/
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
    
//    NSArray *plotIdentifierComponents = [((NSString *)plot.identifier) componentsSeparatedByString:@"-"];
//    NSInteger plotIndex = [[plotIdentifierComponents objectAtIndex:0] intValue];
//    
//    NSArray *data = (NSArray *)[self.chartData[plotIndex] objectForKey:@"data"];
//    
//    //REMTargetEnergyData *targetEnergyData = (REMTargetEnergyData *)self.data.targetEnergyData[plotIndex];
//    
//    //REMEnergyData *point = (REMEnergyData *)targetEnergyData.energyData[idx];
//    
//    NSNumber *value = [NSNumber numberWithInt: plotIndex * idx/*(arc4random() % 8)+10*/]; // [data[idx] objectForKey:@"y"];
//    
//    NSLog(@"plot: %@, index: %d, value: %f", plot.identifier, idx, [value floatValue]);
//    
//    return value; // [data[idx] objectForKey:@"y"];
}

/** @brief @optional Gets a range of plot data for the given plot and field.
 *  Implement one and only one of the optional methods in this section.
 *  @param plot The plot.
 *  @param fieldEnum The field index.
 *  @param indexRange The range of the data indexes of interest.
 *  @return A retained C array of data points.
 **/
//-(double *)doublesForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
//{
//}

/** @brief @optional Gets a plot data value for the given plot and field.
 *  Implement one and only one of the optional methods in this section.
 *  @param plot The plot.
 *  @param fieldEnum The field index.
 *  @param idx The data index of interest.
 *  @return A data point.
 **/
//-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
//{
//}

/** @brief @optional Gets a range of plot data for the given plot and field.
 *  Implement one and only one of the optional methods in this section.
 *  @param plot The plot.
 *  @param fieldEnum The field index.
 *  @param indexRange The range of the data indexes of interest.
 *  @return A one-dimensional array of data points.
 **/
//-(CPTNumericData *)dataForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange
//{
//}

/** @brief @optional Gets a range of plot data for all fields of the given plot simultaneously.
 *  Implement one and only one of the optional methods in this section.
 *
 *  The data returned from this method should be a two-dimensional array. It can be arranged
 *  in row- or column-major order although column-major will load faster, especially for large arrays.
 *  The array should have the same number of rows as the length of @par{indexRange}.
 *  The number of columns should be equal to the number of plot fields required by the plot.
 *  The column index (zero-based) corresponds with the field index.
 *  The data type will be converted to match the @link CPTPlot::cachePrecision cachePrecision @endlink if needed.
 *
 *  @param plot The plot.
 *  @param indexRange The range of the data indexes of interest.
 *  @return A two-dimensional array of data points.
 **/
//-(CPTNumericData *)dataForPlot:(CPTPlot *)plot recordIndexRange:(NSRange)indexRange
//{
//}

/// @}

/// @name Data Labels
/// @{

/** @brief @optional Gets a range of data labels for the given plot.
 *  @param plot The plot.
 *  @param indexRange The range of the data indexes of interest.
 *  @return An array of data labels.
 **/
//-(NSArray *)dataLabelsForPlot:(CPTPlot *)plot recordIndexRange:(NSRange)indexRange
//{
//}

/** @brief @optional Gets a data label for the given plot.
 *  This method will not be called if
 *  @link CPTPlotDataSource::dataLabelsForPlot:recordIndexRange: -dataLabelsForPlot:recordIndexRange: @endlink
 *  is also implemented in the datasource.
 *  @param plot The plot.
 *  @param idx The data index of interest.
 *  @return The data label for the point with the given index.
 *  If you return @nil, the default data label will be used. If you return an instance of NSNull,
 *  no label will be shown for the index in question.
 **/
//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
//{
//    
//}

/// @}


#pragma mark - CPTBarPlotDelegate members
//@optional

/// @name Point Selection
/// @{

/** @brief @optional Informs the delegate that a data label was
 *  @if MacOnly clicked. @endif
 *  @if iOSOnly touched. @endif
 *  @param plot The plot.
 *  @param idx The index of the
 *  @if MacOnly clicked data label. @endif
 *  @if iOSOnly touched data label. @endif
 **/
//-(void)plot:(CPTPlot *)plot dataLabelWasSelectedAtRecordIndex:(NSUInteger)idx
//{
//}

/** @brief @optional Informs the delegate that a data label was
 *  @if MacOnly clicked. @endif
 *  @if iOSOnly touched. @endif
 *  @param plot The plot.
 *  @param idx The index of the
 *  @if MacOnly clicked data label. @endif
 *  @if iOSOnly touched data label. @endif
 *  @param event The event that triggered the selection.
 **/
//-(void)plot:(CPTPlot *)plot dataLabelWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(CPTNativeEvent *)event
//{
//}

/// @}

/// @name Drawing
/// @{

/**
 *  @brief @optional Informs the delegate that plot drawing is finished.
 *  @param plot The plot.
 **/
//-(void)didFinishDrawing:(CPTPlot *)plot
//{
//}

/// @}

//@optional

/// @name Scaling
/// @{

/** @brief @optional Informs the receiver that it should uniformly scale (e.g., in response to a pinch gesture).
 *  @param space The plot space.
 *  @param interactionScale The scaling factor.
 *  @param interactionPoint The coordinates of the scaling centroid.
 *  @return @YES if the gesture should be handled by the plot space, and @NO if not.
 *  In either case, the delegate may choose to take extra actions, or handle the scaling itself.
 **/
//-(BOOL)plotSpace:(CPTPlotSpace *)space shouldScaleBy:(CGFloat)interactionScale aboutPoint:(CGPoint)interactionPoint;

/// @}

/// @name Scrolling
/// @{

/** @brief @optional Notifies that plot space is going to scroll.
 *  @param space The plot space.
 *  @param proposedDisplacementVector The proposed amount by which the plot space will shift.
 *  @return The displacement actually applied.
 **/
//-(CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)proposedDisplacementVector;

/// @}

/// @name Plot Range Changes
/// @{

/** @brief @optional Notifies that plot space is going to change a plot range.
 *  @param space The plot space.
 *  @param newRange The proposed new plot range.
 *  @param coordinate The coordinate of the range.
 *  @return The new plot range to be used.
 **/
//-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
//{
//    CPTXYAxisSet *axisSet=(CPTXYAxisSet *)space.graph.axisSet;
//    
//    CPTMutablePlotRange *range=[newRange mutableCopy];
//    
//    
//    if (newRange.locationDouble<0) {
//        range.location=CPTDecimalFromFloat(0.0f);
//    }
//    
//    NSLog(@"co: %d",coordinate);
//    
//    CPTMutablePlotRange *changedRange;
//    if (coordinate == CPTCoordinateX )
//    {
//        //NSLog(@"range.location x:%f",newRange.locationDouble);
//        if(newRange.locationDouble>90)
//        {
//            range.location=CPTDecimalFromFloat(90.0f);
//            
//        }
//        changedRange=[range mutableCopy];
//        [changedRange expandRangeByFactor:CPTDecimalFromFloat(1.025)];
//        changedRange.location=range.location;
//        CPTXYAxis *x=axisSet.axes[0];
//        x.visibleRange=changedRange;
//    }
//    else if(coordinate == CPTCoordinateY)
//    {
//        //NSLog(@"range.location y:%f",newRange.locationDouble);
//        if(newRange.locationDouble>0)
//            range.location = CPTDecimalFromFloat(0.0f);
//        
//        changedRange=[range mutableCopy];
//        [changedRange expandRangeByFactor:CPTDecimalFromFloat(1.05)];
//        
//        CPTXYAxis *y= axisSet.axes[1];
//        y.visibleRange=changedRange;        
//    }
//    
//    return range;
//
//}

/** @brief @optional Notifies that plot space has changed a plot range.
 *  @param space The plot space.
 *  @param coordinate The coordinate of the range.
 **/
//-(void)plotSpace:(CPTPlotSpace *)space didChangePlotRangeForCoordinate:(CPTCoordinate)coordinate;

/// @}

/// @name User Interaction
/// @{

/** @brief @optional Notifies that plot space intercepted a device down event.
 *  @param space The plot space.
 *  @param event The native event.
 *  @param point The point in the host view.
 *  @return Whether the plot space should handle the event or not.
 *  In either case, the delegate may choose to take extra actions, or handle the scaling itself.
 **/
//-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point;

/** @brief @optional Notifies that plot space intercepted a device dragged event.
 *  @param space The plot space.
 *  @param event The native event.
 *  @param point The point in the host view.
 *  @return Whether the plot space should handle the event or not.
 *  In either case, the delegate may choose to take extra actions, or handle the scaling itself.
 **/
//-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point;

/** @brief @optional Notifies that plot space intercepted a device cancelled event.
 *  @param space The plot space.
 *  @param event The native event.
 *  @return Whether the plot space should handle the event or not.
 *  In either case, the delegate may choose to take extra actions, or handle the scaling itself.
 **/
//-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceCancelledEvent:(CPTNativeEvent *)event;

/** @brief @optional Notifies that plot space intercepted a device up event.
 *  @param space The plot space.
 *  @param event The native event.
 *  @param point The point in the host view.
 *  @return Whether the plot space should handle the event or not.
 *  In either case, the delegate may choose to take extra actions, or handle the scaling itself.
 **/
//-(BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceUpEvent:(CPTNativeEvent *)event atPoint:(CGPoint)point;

/// @}

#pragma mark - UIGestureRecognizerDelegate members
//@optional
// called when a gesture recognizer attempts to transition out of UIGestureRecognizerStatePossible. returning NO causes it to transition to UIGestureRecognizerStateFailed
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//}

// called when the recognition of one of gestureRecognizer or otherGestureRecognizer would be blocked by the other
// return YES to allow both to recognize simultaneously. the default implementation returns NO (by default no two gestures can be recognized simultaneously)
//
// note: returning YES is guaranteed to allow simultaneous recognition. returning NO is not guaranteed to prevent simultaneous recognition, as the other gesture's delegate may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//}


@end
