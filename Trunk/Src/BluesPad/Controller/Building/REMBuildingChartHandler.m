//
//  REMBuildingChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingChartHandler.h"

@interface REMBuildingChartHandler ()

@end

@implementation REMBuildingChartHandler


- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self.view setFrame:frame];
        //[self viewDidLoad];
    }
    return self;
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMEnergyViewData *)buildingOverall :(void (^)(void))loadCompleted
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CPTGraphHostingView* hostView = [self getHostView];
    if (hostView != nil) {
        // Do any additional setup after loading the view.
        UILongPressGestureRecognizer* gest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        //[gest setNumberOfTouchesRequired:100];
        [hostView addGestureRecognizer: gest];
    }
}

- (CPTGraphHostingView*) getHostView  {
    return nil;
}
-(void) longPress:(UILongPressGestureRecognizer*) gest {
    if (gest.state == UIGestureRecognizerStateBegan) {
        CPTGraphHostingView* hostingView = [self getHostView];
        NSDate* touchedX = [self getXDate:[[hostingView.hostedGraph allPlots] objectAtIndex: 0] hostingView:hostingView gest:gest];
        
        [self longPressedAt:touchedX];
    }
}

-(void)longPressedAt:(NSDate*)x {
    
}

- (NSDate*)getXDate:(CPTPlot*)plot hostingView:(CPTGraphHostingView*)hostingView gest:(UILongPressGestureRecognizer*) gest {
    CGPoint touchPoint = [gest locationInView: hostingView];
    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)hostingView.hostedGraph.defaultPlotSpace;
    NSDecimal plotPoint[2];
    
    CGPoint pointInPlotArea = [plot convertPoint:touchPoint fromLayer:hostingView.hostedGraph];
    [plotSpace plotPoint:plotPoint forPlotAreaViewPoint:pointInPlotArea];
    return [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithDecimal:plotPoint[0]].floatValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
