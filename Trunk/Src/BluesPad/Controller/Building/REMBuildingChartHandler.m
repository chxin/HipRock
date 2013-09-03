//
//  REMBuildingChartHandler.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingChartHandler.h"

@interface REMBuildingChartHandler ()

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation REMBuildingChartHandler



static CPTLineStyle *axisLineStyle;
static CPTLineStyle *gridLineStyle;
static CPTLineStyle *hiddenLineStyle;
static CPTTextStyle *xAxisLabelStyle;
static CPTTextStyle *yAxisLabelStyle;


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
//        // Do any additional setup after loading the view.
//        UILongPressGestureRecognizer* gest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
//        //[gest setNumberOfTouchesRequired:100];
//        [hostView addGestureRecognizer: gest];
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


-(CPTLineStyle *)axisLineStyle
{
    if(axisLineStyle == nil){
        axisLineStyle = [[CPTMutableLineStyle alloc] init];
        
        CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
        style.lineWidth = 1;
        style.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithWhite:1 alpha:0.8].CGColor];
        
        axisLineStyle = style;
    }
    
    return axisLineStyle;
}

-(CPTLineStyle *)gridLineStyle
{
    if(gridLineStyle==nil){
        CPTMutableLineStyle *style=[[CPTMutableLineStyle alloc] init];
        style.lineWidth = 1.0f;
        style.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithWhite:1 alpha:0.4].CGColor];
        style.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:2],[NSDecimalNumber numberWithInt:2],nil];
        
        gridLineStyle = style;
    }
    
    return gridLineStyle;
}

-(CPTLineStyle *)hiddenLineStyle
{
    if(hiddenLineStyle == nil){
        CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
        style.lineWidth = 0;
        
        hiddenLineStyle = style;
    }
    
    return hiddenLineStyle;
}

-(CPTTextStyle *)xAxisLabelStyle
{
    //text styles
    if(xAxisLabelStyle == nil){
        CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
        style.fontSize = 11.0;
        style.color = [CPTColor whiteColor];
        
        xAxisLabelStyle = style;
    }
    
    return xAxisLabelStyle;
}

-(CPTTextStyle *)yAxisLabelStyle
{
    //text styles
    if(yAxisLabelStyle == nil){
        CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
        style.fontSize = 12.0;
        style.color = [CPTColor whiteColor];
        
        yAxisLabelStyle = style;
    }
    
    return yAxisLabelStyle;
}

-(NSString *)formatDataValue:(NSNumber *)number
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    double numberValue = [number doubleValue];
    
    NSString* text = nil;
    if (numberValue > 1000000) {
        text = [NSString stringWithFormat:@"%@M", [formatter stringFromNumber:[NSNumber numberWithInt:numberValue / 1000000]]];
    } else if (numberValue > 1000) {
        text = [NSString stringWithFormat:@"%@K", [formatter stringFromNumber:[NSNumber numberWithInt:numberValue / 1000]]];
    } else {
        text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithInt:numberValue]]];
    }
    
    return text;
}



-(void)startLoadingActivity
{
    if(self.activityIndicatorView == nil){
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //self.activityIndicatorView.backgroundColor = [UIColor clearColor];
        self.activityIndicatorView.frame = self.view.bounds;
        
        [self.view addSubview:self.activityIndicatorView];
    }
    
    [self.activityIndicatorView startAnimating];
}

-(void)stopLoadingActivity
{
    if(self.activityIndicatorView != nil){
        [self.activityIndicatorView stopAnimating];
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
