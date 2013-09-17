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

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(REMError *))loadCompleted
{
    NSDictionary *param = [self assembleRequestParametersWithBuildingId:buildingId WithCommodityId:commodityID WithMetadata:averageUsageData];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:self.requestUrl parameter:param];
    store.isAccessLocal = YES;
    store.isStoreLocal = YES;
    store.maskContainer = nil;
    store.groupName = [NSString stringWithFormat:@"b-%lld-%lld", buildingId, commodityID];
    
    
    [self startLoadingActivity];
    [REMDataAccessor access:store success:^(id data) {
        
        [self loadDataSuccessWithData:data];
        
        loadCompleted(nil);
        
        
        
        [self stopLoadingActivity];
    } error:^(NSError *error, id response) {
        [self stopLoadingActivity];
        loadCompleted(nil);
        REMError *remerror=(REMError *)error;
        if(remerror!=nil){
            [self loadDataFailureWithError:remerror withResponse:response];
        }
    }];

}

- (void)loadDataSuccessWithData:(id)data
{
    
}

- (void)loadDataFailureWithError:(REMError *)error withResponse:(id)response
{
    
}

- (void)prepareShare{
    
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
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    double numberValue = [number doubleValue];
    
    NSString* text = nil;
    if (numberValue > 1000000) {
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        
        text = [NSString stringWithFormat:@"%@M", [formatter stringFromNumber:[NSNumber numberWithDouble:numberValue / 1000000]]];
    }
    else if (numberValue > 1000) {
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        
        text = [NSString stringWithFormat:@"%@K", [formatter stringFromNumber:[NSNumber numberWithDouble:numberValue / 1000]]];
    }
    else if(numberValue > 10){
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        
        text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:numberValue]]];
    }
    else if (numberValue > 1) {
        [formatter setMaximumFractionDigits:1];
        [formatter setMinimumFractionDigits:1];
        
        text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:numberValue]]];
    }
    else if (numberValue == 0){
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        
        text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:numberValue]]];
    }
    else{
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        
        text = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:numberValue]]];
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
