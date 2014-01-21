/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartHandler.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingChartBaseViewController.h"
#import "REMBuildingChartSeriesIndicator.h"
#import "DCDataPoint.h"


@interface REMBuildingChartBaseViewController ()

@property (nonatomic,weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) UIView* legendContainer;

@end

@implementation REMBuildingChartBaseViewController

- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        
        self.legendContainer = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-kBuildingTrendChartLegendHeight, frame.size.width, kBuildingTrendChartLegendHeight)];
        [self.view addSubview:self.legendContainer];
    }
    return self;
}

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(id,REMBusinessErrorInfo *))loadCompleted
{
    NSDictionary *param = [self assembleRequestParametersWithBuildingId:buildingId WithCommodityId:commodityID WithMetadata:averageUsageData];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:self.requestUrl parameter:param accessCache:YES andMessageMap:nil];
    //store.isAccessLocal = YES;
    store.maskContainer = nil;
    store.groupName = [NSString stringWithFormat:@"building-data-%@", @(buildingId)];
    
    store.disableAlert=YES;
    [self startLoadingActivity];
    [store access:^(id data) {
        if(self.view==nil)return ;
        [self loadDataSuccessWithData:data];
        
        loadCompleted(data,nil);
        
        
        
        [self stopLoadingActivity];
    } error:^(NSError *remError, REMDataAccessErrorStatus status, REMBusinessErrorInfo *bizError) {
        [self stopLoadingActivity];
        loadCompleted(nil,bizError);
        
        [self loadDataFailureWithError:bizError];
        
    }];

}


- (void)loadDataSuccessWithData:(id)data {
    self.energyViewData = [self convertData:data];
}

/*
 * 更新Legend，当chartWrapper为隐藏时，所有的Legend都会被移除
 */
-(void)updateLegendView {
    for (UIView* sub in self.legendContainer.subviews) {
        [sub removeFromSuperview];
    }
    if (!REMIsNilOrNull(self.chartWrapper) && !self.chartWrapper.view.hidden) {
        CGFloat labelTopOffset = 10;
        CGFloat labelLeftOffset = 57;
        CGFloat labelDistance = 18;
        UIFont* legendFont = [UIFont systemFontOfSize:kCoverLegendFontSize];
        
        for (NSUInteger i = 0; i < self.chartWrapper.view.seriesList.count; i++) {
            DCXYSeries* series = self.chartWrapper.view.seriesList[i];
            if (![self isSeriesHasLegend:series index:i]) continue;
            NSString* legendText = [self getLegendText:series index:i];
            UIColor* legendColor = [self getLegendColor:series index:i];
            if (REMIsNilOrNull(legendText) || REMIsNilOrNull(legendColor)) continue;
            CGSize textSize = [legendText sizeWithFont:legendFont];
            CGFloat averageDataWidth = textSize.width + 26;
            if (averageDataWidth < 180) averageDataWidth = 180;
            CGRect legendFrame = CGRectMake(labelLeftOffset, labelTopOffset, averageDataWidth, textSize.height);
            if (legendFrame.size.width + legendFrame.origin.x > self.legendContainer.bounds.size.width) {
                labelLeftOffset = 57;
                labelTopOffset += 20;
                legendFrame = CGRectMake(labelLeftOffset, labelTopOffset, averageDataWidth, textSize.height);
            }
            REMBuildingChartSeriesIndicator *averageDataIndicator = [[REMBuildingChartSeriesIndicator alloc] initWithFrame:CGRectMake(labelLeftOffset, labelTopOffset, averageDataWidth, textSize.height) title:legendText andColor:legendColor];
            labelLeftOffset=labelLeftOffset+averageDataWidth+labelDistance;
            [self.legendContainer addSubview:averageDataIndicator];
        }
    }
}

-(void)setEnergyViewData:(REMEnergyViewData *)energyViewData {
    _energyViewData = energyViewData;
    
    if (REMIsNilOrNull(self.chartWrapper)) {
        // add 22 into width to show the xLabel which is outside of view bounds
        _chartWrapper = [self constructWrapperWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+22, self.view.bounds.size.height-kBuildingTrendChartLegendHeight)];
        if (!REMIsNilOrNull(self.chartWrapper)) {
            [self.view addSubview:self.chartWrapper.view];
        }
    } else {
        [self.chartWrapper redraw:self.energyViewData step:[self getEnergyStep]];
    }
    [self updateLegendView];
    
    BOOL hasPoint = NO;
    for (DCXYSeries* s in self.chartWrapper.view.seriesList) {
        for (DCDataPoint* point in s.datas) {
            if (point.pointType == DCDataPointTypeNormal) {
                hasPoint = YES;
                break;
            }
        }
    }
    if (hasPoint) {
        self.chartWrapper.view.hidden = NO;
        self.textLabel.hidden = YES;
        self.legendContainer.hidden = NO;
    } else {
        [self drawLabelWithText:NSLocalizedString(@"BuildingChart_NoData", @"")];
        self.chartWrapper.view.hidden = YES;
        self.legendContainer.hidden = YES;
    }
}

-(BOOL)isSeriesHasLegend:(DCXYSeries*)series index:(NSUInteger)index {
    return YES;
}

-(NSString*)getLegendText:(DCXYSeries*)series index:(NSUInteger)index {
    return series.target.name;
}

-(UIColor*)getLegendColor:(DCXYSeries*)series index:(NSUInteger)index {
    [REMColor makeTransparent:1 withColor:series.color];
    return series.color;
}

-(REMEnergyViewData*)convertData:(id)data {
    return [[REMEnergyViewData alloc] initWithDictionary:data];
}

-(REMEnergyStep)getEnergyStep {
    return REMEnergyStepNone;
}

-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    return nil;
}

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error {
    [self drawLabelWithText:NSLocalizedString(@"BuildingChart_DataError", @"")];
}

- (void)prepareShare{
    
}

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    return nil;
}


-(void)drawLabelWithText:(NSString *)text
{
    if (REMIsNilOrNull(self.textLabel)) {
        CGFloat fontSize = 36;
        CGSize labelSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize]];
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, labelSize.width, labelSize.height)];
        noDataLabel.textColor = [UIColor whiteColor];
        noDataLabel.textAlignment = NSTextAlignmentLeft;
        noDataLabel.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:noDataLabel];
        _textLabel = noDataLabel;
    }
    self.textLabel.hidden = NO;
    self.textLabel.text = text;
}


//- (NSDate*)getXDate:(CPTPlot*)plot hostingView:(CPTGraphHostingView*)hostingView gest:(UILongPressGestureRecognizer*) gest {
//    CGPoint touchPoint = [gest locationInView: hostingView];
//    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)hostingView.hostedGraph.defaultPlotSpace;
//    NSDecimal plotPoint[2];
//    
//    CGPoint pointInPlotArea = [plot convertPoint:touchPoint fromLayer:hostingView.hostedGraph];
//    [plotSpace plotPoint:plotPoint forPlotAreaViewPoint:pointInPlotArea];
//    return [NSDate dateWithTimeIntervalSince1970:[NSDecimalNumber decimalNumberWithDecimal:plotPoint[0]].floatValue];
//}


//-(CPTLineStyle *)axisLineStyle
//{
//    if(axisLineStyle == nil){
//        axisLineStyle = [[CPTMutableLineStyle alloc] init];
//        
//        CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
//        style.lineWidth = 1;
//        style.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithWhite:1 alpha:0.8].CGColor];
//        
//        axisLineStyle = style;
//    }
//    
//    return axisLineStyle;
//}
//
//-(CPTLineStyle *)gridLineStyle
//{
//    if(gridLineStyle==nil){
//        CPTMutableLineStyle *style=[[CPTMutableLineStyle alloc] init];
//        style.lineWidth = 1.0f;
//        style.lineColor = [CPTColor colorWithCGColor:[UIColor colorWithWhite:1 alpha:0.4].CGColor];
//        style.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:2],[NSDecimalNumber numberWithInt:2],nil];
//        
//        gridLineStyle = style;
//    }
//    
//    return gridLineStyle;
//}

//-(CPTLineStyle *)hiddenLineStyle
//{
//    if(hiddenLineStyle == nil){
//        CPTMutableLineStyle *style = [CPTMutableLineStyle lineStyle];
//        style.lineWidth = 0;
//        
//        hiddenLineStyle = style;
//    }
//    
//    return hiddenLineStyle;
//}
//
//-(CPTTextStyle *)xAxisLabelStyle
//{
//    //text styles
//    if(xAxisLabelStyle == nil){
//        CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
//        style.fontSize = 11.0;
//        style.color = [CPTColor whiteColor];
//        
//        xAxisLabelStyle = style;
//    }
//    
//    return xAxisLabelStyle;
//}
//
//-(CPTTextStyle *)yAxisLabelStyle
//{
//    //text styles
//    if(yAxisLabelStyle == nil){
//        CPTMutableTextStyle *style = [CPTMutableTextStyle textStyle];
//        style.fontSize = 12.0;
//        style.color = [CPTColor whiteColor];
//        
//        yAxisLabelStyle = style;
//    }
//    
//    return yAxisLabelStyle;
//}

//-(NSString *)formatDataValue:(NSNumber *)number
//{
//    double numberValue = [number doubleValue];
//    
//    if(numberValue == 0){
//        return @"0";
//    }
//    if(numberValue < 1000){
//        return [self formatNumber:number withMinDigits:2 andMaxDigits:2];
//    }
//    if(numberValue < 1000000){
//        return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
//    }
//    if(numberValue < 100000000){
//        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000] withMinDigits:0 andMaxDigits:0];
//        return [NSString stringWithFormat:@"%@k", text];
//    }
//    if(numberValue < 100000000000){
//        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000] withMinDigits:0 andMaxDigits:0];
//        return [NSString stringWithFormat:@"%@M", text];
//    }
//    if(numberValue < 100000000000000){
//        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000000] withMinDigits:0 andMaxDigits:0];
//        return [NSString stringWithFormat:@"%@G", text];
//    }
//    if(numberValue < 100000000000000000){
//        NSString *text = [self formatNumber:[NSNumber numberWithDouble:numberValue/1000000000000] withMinDigits:0 andMaxDigits:0];
//        return [NSString stringWithFormat:@"%@T", text];
//    }
//        
//    return [self formatNumber:number withMinDigits:0 andMaxDigits:0];
//}

//static NSNumberFormatter* formatter;
//-(NSString *)formatNumber:(NSNumber *)number withMinDigits:(int) minDigits andMaxDigits:(int)maxDigits
//{
//    if(formatter == nil){
//        formatter = [[NSNumberFormatter alloc] init];
//    }
//    
//    formatter.numberStyle = NSNumberFormatterDecimalStyle;
//    [formatter setMinimumFractionDigits:minDigits];
//    [formatter setMaximumFractionDigits:maxDigits];
//    
//    return [formatter stringFromNumber:number];
//}

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
    [self.view removeFromSuperview];
    _energyViewData = nil;
    self.view = nil;
    _chartWrapper = nil;
}



@end
