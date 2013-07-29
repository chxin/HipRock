//
//  REMPieCell.m
//  SplitDashboard
//
//  Created by TanTan on 6/19/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import "REMPieCell.h"

@interface REMPieCell()
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) CPTPieChart *chart;
@property (nonatomic,strong) NSNumber *currentSelectedIndex;
@property  BOOL hasInit;

@end

@implementation REMPieCell

- (BOOL)isInitialized
{
    return self.hasInit;
}

- (void)initChart
{
    [self initData];
    [self initPieChart];
    self.hasInit=YES;
}

- (void)initData
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
    
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:hexColor.count];
    for(NSString *str in hexColor)
    {
        unsigned rgbValue=0;
        NSScanner *scanner = [NSScanner scannerWithString:str];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        [colors addObject:[CPTColor colorWithComponentRed:
                           ((rgbValue & 0xFF0000)>>16)/255.00
                                                    green:((rgbValue & 0xFF00) >> 8)/255.00
                                                     blue:((rgbValue & 0xFF)/255.00) alpha:1.0]];
    }
    
    self.data = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (int i=1; i<=10;i++) {
        NSString *uid= [NSString stringWithFormat:@"plot%d",i];
        NSNumber *value= [NSNumber numberWithInt:i*10];
        NSDictionary *item=@{@"uid": uid,@"color":colors[i-1],@"value": value};
        [self.data addObject:item];
    }
}

- (void)initPieChart
{
    
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc]initWithFrame:self.bounds];
    
    CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:hostView.bounds];
    hostView.hostedGraph=graph;
    hostView.allowPinchScaling=YES;
    graph.plotAreaFrame.masksToBorder=NO;
    graph.paddingLeft=10.0f;
    graph.paddingRight=10.0f;
    graph.paddingTop=0.0f;
    graph.paddingBottom=10.0f;
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
    /*CPTGradient *overlayGradient = [[CPTGradient alloc] init];
     overlayGradient.gradientType = CPTGradientTypeRadial;
     overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
     overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
     pie.overlayFill = [CPTFill fillWithGradient:overlayGradient];*/
    self.chart=pie;
    [graph addPlot:pie];
    pie.plotSpace.delegate=self;
    
    
    CABasicAnimation *rotation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.removedOnCompletion=YES;
    rotation.fromValue=[NSNumber numberWithFloat:M_PI*2];
    rotation.toValue=[NSNumber numberWithFloat:0.0f];
    rotation.duration=1.0f;
    rotation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    rotation.delegate=self;
    //[pie addAnimation:rotation forKey:@"rotation"];
    
   /* [CPTAnimation animate:pie
                 property:@"pieRadius"
                     from:0
                       to:60
                 duration:1
                withDelay:0
           animationCurve:CPTAnimationCurveBounceOut
                 delegate:nil];
    */
    
    
    
    [CPTAnimation animate:pie
                 property:@"pieInnerRadius"
                     from: 0
                       to:10
                 duration:0.25
                withDelay:0.5
           animationCurve:CPTAnimationCurveLinear
                 delegate:nil
     ];
    
    [CPTAnimation animate:pie
                 property:@"pieRadius"
                     from: 0
                       to: 60
                 duration:0.5
                withDelay:0
           animationCurve:CPTAnimationCurveBounceOut
                 delegate:nil];
    
    
    [CPTAnimation animate:pie
                 property:@"startAngle"
                     from: M_PI_4
                       to: M_PI_4 * 4
                 duration:1
                withDelay:1
           animationCurve:CPTAnimationCurveCubicInOut
                 delegate:nil];
    
    
    [self.chartView addSubview:hostView];
    
    
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchPie:)];
    
    pinch.delegate=self;
    
    [hostView addGestureRecognizer:pinch];
    
    
}

- (void) pinchPie:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
        
        
        self.chart.pieRadius*=sender.scale;
        
        
        [sender setScale:1];
        
        [self.chart reloadData];
    }
    
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //[self.chart performSelector:@selector(reloadData) withObject:nil afterDelay:0.4];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    
    if (fieldEnum == CPTPieChartFieldSliceWidth) {
        NSDictionary *item=self.data[idx];
        NSNumber *value= [item objectForKey:@"value"];
        
        return value;
    }
    else
    {
        return [NSNumber numberWithInt:idx];
    }
}

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    
    NSDictionary *item =self.data[idx];
    
    CPTFill *fill = [CPTFill fillWithColor:[item objectForKey:@"color"]];
    
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
   /* NSNumber *number= [self.data[idx] objectForKey:@"value"];
    
    [self.dataLabel setText: [number stringValue]];
    self.currentSelectedIndex= [NSNumber numberWithInteger:idx];
    //plot.pieRadius+=10;
    [plot setDataNeedsReloading];
    
    [self beginRotation:event];
    */
    
}

- (CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    if (self.currentSelectedIndex != nil) {
        if([self.currentSelectedIndex isEqualToNumber:[NSNumber numberWithInteger:idx]] == YES)
        {
            return 5;
        }
    }
    return 0;
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    
    return self.data.count;
}


@end
