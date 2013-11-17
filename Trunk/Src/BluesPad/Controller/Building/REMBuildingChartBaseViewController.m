/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartHandler.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingChartBaseViewController.h"


@interface REMBuildingChartBaseViewController ()

@property (nonatomic,weak) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation REMBuildingChartBaseViewController


static CPTLineStyle *axisLineStyle;
static CPTLineStyle *gridLineStyle;
static CPTLineStyle *hiddenLineStyle;
static CPTTextStyle *xAxisLabelStyle;
static CPTTextStyle *yAxisLabelStyle;


- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        // Custom initialization
        //[self.view setFrame:frame];
        //[self viewDidLoad];
    }
    return self;
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(id,REMBusinessErrorInfo *))loadCompleted
{
    
    NSDictionary *param = [self assembleRequestParametersWithBuildingId:buildingId WithCommodityId:commodityID WithMetadata:averageUsageData];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:self.requestUrl parameter:param];
    //store.isAccessLocal = YES;
    store.maskContainer = nil;
    store.groupName = [NSString stringWithFormat:@"b-%lld-%lld", buildingId, commodityID];
    
    
    [self startLoadingActivity];
    [REMDataAccessor access:store success:^(id data) {
        if(self.view==nil)return ;
        [self loadDataSuccessWithData:data];
        
        loadCompleted(data,nil);
        
        
        
        [self stopLoadingActivity];
    } error:^(NSError *remError, REMBusinessErrorInfo *bizError) {
        [self stopLoadingActivity];
        loadCompleted(nil,bizError);
        if(bizError!=nil){
            [self loadDataFailureWithError:bizError ];
        }
    }];

}

- (void)loadDataSuccessWithData:(id)data
{
    
}

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error
{
    
}

- (void)prepareShare{
    
}

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    return nil;
}


-(void)drawLabelWithText:(NSString *)text
{
    CGFloat fontSize = 36;
    CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, labelSize.width, labelSize.height)];
    noDataLabel.text = text;
    noDataLabel.textColor = [UIColor whiteColor];
    noDataLabel.textAlignment = NSTextAlignmentLeft;
    noDataLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:noDataLabel];
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

- (CABasicAnimation *) plotAnimation
{
    //adding animation here
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [animation setDuration:0.5f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.removedOnCompletion = NO;
    //animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
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
    double numberValue = [number doubleValue];
    
    if(numberValue == 0){
        return @"0";
    }
    if(numberValue < 1000){
        return [self formatNumber:number withMinDigits:2 andMaxDigits:2];
    }
    if(numberValue < 1000000){
        return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
    }
    if(numberValue < 100000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@k", text];
    }
    if(numberValue < 100000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@M", text];
    }
    if(numberValue < 100000000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@G", text];
    }
    if(numberValue < 100000000000000000){
        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000000000] withMinDigits:0 andMaxDigits:0];
        return [NSString stringWithFormat:@"%@T", text];
    }
        
    return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
}

static NSNumberFormatter* formatter;
-(NSString *)formatNumber:(NSNumber *)number withMinDigits:(int) minDigits andMaxDigits:(int)maxDigits
{
    if(formatter == nil){
        formatter = [[NSNumberFormatter alloc] init];
    }
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    [formatter setMinimumFractionDigits:minDigits];
    [formatter setMaximumFractionDigits:maxDigits];
    
    return [formatter stringFromNumber:number];
}

-(void)startLoadingActivity
{
    if(self.activityIndicatorView == nil){
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        //self.activityIndicatorView.backgroundColor = [UIColor clearColor];
        view.frame = self.view.bounds;
        
        [self.view addSubview:view];
        self.activityIndicatorView=view;
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

-(void)purgeMemory{
//    axisLineStyle=nil;
//    gridLineStyle=nil;
//    hiddenLineStyle=nil;
//    xAxisLabelStyle=nil;
//    yAxisLabelStyle=nil;
    CPTGraphHostingView *hostView=[self getHostView];
    [hostView.hostedGraph removeAllAnimations];
    [hostView.hostedGraph removeAllAnnotations];
    for (CPTAxis *axis in hostView.hostedGraph.axisSet.axes) {
        axis.majorTickLocations=nil;
        axis.minorTickAxisLabels=nil;
        [axis removeFromSuperlayer];
    }
    [hostView.hostedGraph.axisSet removeFromSuperlayer];
    hostView.hostedGraph.axisSet.axes=nil;
    
    [hostView.hostedGraph.plotAreaFrame removeFromSuperlayer];
    [hostView.hostedGraph removeFromSuperlayer];
    hostView.hostedGraph=nil;
    [hostView removeFromSuperview];
    //hostView = nil;
    [self.view removeFromSuperview];
    self.view = nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
    // Dispose of any resources that can be recreated.
    if(self.isViewLoaded==YES){
        if (self.view.superview == nil) {
            self.view=nil;
        }
    }
    
}
@end
