//
//  REMWidgetCellPieViewControllerViewController.m
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMWidgetCellPieViewController.h"

@interface REMWidgetCellPieViewController ()
@property  (nonatomic) NSNumber *currentSelectedIndex;
@property (nonatomic,strong) CPTPieChart *chart;

@end

@implementation REMWidgetCellPieViewController

- (void)initChart
{
    //[self initData];
    [self initPieChart];
}



- (void)initPieChart
{
    
    
    
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:self.view.bounds];
    
    CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:hostView.bounds];
    hostView.hostedGraph=graph;
    hostView.allowPinchScaling=YES;
    graph.plotAreaFrame.masksToBorder=NO;
    graph.paddingLeft=10.0f;
    graph.paddingRight=10.0f;
    graph.paddingTop=0.0f;
    graph.paddingBottom=20.0f;
    graph.axisSet=nil;
    CPTPieChart *pie=[[CPTPieChart alloc] init];
    pie.pieRadius=0;
    pie.pieInnerRadius=0;
    pie.delegate=self;
    pie.startAngle=M_PI_4;
    //pie.endAngle=M_PI_4*3;
    pie.dataSource=self;
    pie.identifier=@"pieplot1";
    pie.sliceDirection=CPTPieDirectionClockwise;
    self.chart=pie;
    [graph addPlot:pie];
    pie.plotSpace.delegate=self;
    
    
    
    
    
    [CPTAnimation animate:pie
                 property:@"pieRadius"
                     from: 0
                       to: 60
                 duration:0.5
                withDelay:0
           animationCurve:CPTAnimationCurveBounceOut
                 delegate:nil];
    
    
    /*[CPTAnimation animate:pie
                 property:@"endAngle"
                     from: M_PI_4
                       to: M_PI_4 * 4
                 duration:1
                withDelay:1
           animationCurve:CPTAnimationCurveCubicInOut
                 delegate:nil];*/
    
    
    [self.chartView addSubview:hostView];
    
    /*
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchPie:)];
    
    pinch.delegate=self;
    
    [hostView addGestureRecognizer:pinch];*/
    
    
}

- (void) pinchPie:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
        
        
        self.chart.pieRadius*=sender.scale;
        
        
        [sender setScale:1];
        
        [self.chart reloadData];
    }
    
    
    
}



- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    
    CPTFill *fill = [CPTFill fillWithColor:[REMColor colorByIndex:idx]];
    
    return fill;
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.chart.graph.hostingView.bounds.size.width/2.0f, self.chart.graph.hostingView.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    
    
    NSLog(@"touchdown x:%f,y:%f",point.x,point.y);
    
    return YES;
}

- (BOOL)plotSpace:(CPTPlotSpace *)space shouldHandlePointingDeviceDraggedEvent:(UIEvent *)event atPoint:(CGPoint)point
{
    return YES;
    /*
     
     UITouch *touch = [[event allTouches] anyObject];
     
     CGPoint pt = [touch locationInView:self.chart.graph.hostingView];
     
     float dx = pt.x  - self.chart.graph.hostingView.center.x-100;
     float dy = pt.y  - self.chart.graph.hostingView.center.y-100;
     float ang = atan2(dy,dx);
     
     float angleDif = self.deltaAngle - ang;
     
     NSLog(@"angleDif:%f",angleDif);
     
     CGAffineTransform newTrans = CGAffineTransformRotate(self.transform, -angleDif);
     self.chart.graph.hostingView.transform = newTrans;
     return YES;
     */
}

- (void) beginRotation:(UIEvent *)event
{
    /*
     UITouch *touch=[[event allTouches] anyObject];
     
     CGPoint relPoint = [ touch locationInView:self.chart.graph.hostingView];
     
     CGFloat dis= [self calculateDistanceFromCenter:relPoint];
     
     NSLog(@"distance:%f",dis);
     
     NSLog(@"touchdown x:%f,y:%f",relPoint.x,relPoint.y);
     
     self.transform=  self.chart.graph.hostingView.transform;
     
     NSLog(@"center x:%f,y:%f",self.chart.graph.hostingView.center.x,self.chart.graph.hostingView.center.y);
     
     float dx = relPoint.x  - self.chart.graph.hostingView.center.x+100;
     float dy = relPoint.y  - self.chart.graph.hostingView.center.y-100;
     self.deltaAngle = atan2(dy,dx);
     */
}

- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(UIEvent *)event
{
    // NSNumber *number= [self.data[idx] objectForKey:@"value"];
     
     //[self.dataLabel setText: [number stringValue]];
     self.currentSelectedIndex= [NSNumber numberWithInteger:idx];
     //plot.pieRadius+=10;
     [plot setDataNeedsReloading];
     
     //[self beginRotation:event];
     
    
}

- (CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    if (self.currentSelectedIndex != nil) {
        if([self.currentSelectedIndex isEqualToNumber:[NSNumber numberWithInteger:idx]] == YES)
        {
            return 5;
        }
    }
    return 1;
}

#pragma mark -
#pragma mark PieDataSource

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    //NSLog(@"numberOfRecordsForPlot");
    //return self.data.count;
    return self.data.targetEnergyData.count;
}



- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    //NSLog(@"numberForPlot");
    if (fieldEnum == CPTPieChartFieldSliceWidth) {
        REMTargetEnergyData *item=self.data.targetEnergyData[idx];
        if(item.energyData!=nil && item.energyData.count==1)
        {
            REMEnergyData *dataItem= item.energyData[0];
            return dataItem.dataValue;
        }
        else
        {
            return [[NSDecimalNumber alloc] initWithInt: 0];
        }
        //NSNumber *value= [item objectForKey:@"value"];
        
        //return value;
    }
    else
    {
        return [NSNumber numberWithInt:idx];
    }
}


@end
