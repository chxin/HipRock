/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAverageChartHandler.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <QuartzCore/QuartzCore.h>
#import "REMBuildingAverageChartViewController.h"
#import "REMEnergyViewData.h"
#import "REMCommodityUsageModel.h"
#import "REMDataRange.h"
#import "REMBuildingChartSeriesIndicator.h"
#import "REMBuildingAverageWrapper.h"
#import "REMCommodityModel.h"
#import "DCXYSeries.h"



@interface REMBuildingAverageViewController ()

@property (nonatomic) CGRect viewFrame;
@property (nonatomic) long long commodityId;
@property (nonatomic,strong) NSArray *chartData;
@property (nonatomic,strong) REMEnergyViewData *averageData;



@property (nonatomic,strong) REMChartHorizonalScrollDelegator *scrollManager;

@end

@implementation REMBuildingAverageViewController


static NSString *kBenchmarkTitle = @"目标值";
static NSString *kAverageDataTitle = @"单位面积用%@";

- (void)purgeMemory{
    [super purgeMemory];
    self.averageData=nil;
    self.chartData=nil;
//    self.chartView=nil;
    self.scrollManager=nil;
}


- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super initWithViewFrame:frame];
    if (self) {
        // Custom initialization
        self.viewFrame = frame;
        self.scrollManager = [[REMChartHorizonalScrollDelegator alloc]init];
        self.requestUrl=REMDSBuildingAverageData;
    }
    return self;
}

-(void)prepareShare {
    
}

//- (void)loadView
//{
//    //[super loadView];
//    
//    self.view = [[REMBuildingAverageChart alloc] initWithFrame:self.viewFrame];
//    self.chartView = (REMBuildingAverageChart *)self.view;
//    
//    //[self viewDidLoad];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self loadChart];
}


-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.step = @(REMEnergyStepMonth);
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    style.userInteraction = YES;
    REMBuildingAverageWrapper* wrapper = [[REMBuildingAverageWrapper alloc]initWithFrame:frame data:self.energyViewData widgetContext:syntax style:style];
    return wrapper;
}

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    self.commodityId = commodityID;
    
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong:buildingId], @"commodityId":[NSNumber numberWithLongLong:commodityID]};
    
    return parameter;
}

//- (void)loadChart
//{
//    if(REMIsNilOrNull(self.averageData)) return;
//    
//    [self.chartView initializeGraphWithEnergyData:self.averageData];
//    BOOL hasData = NO;
//    for(DCXYSeries* s in self.chartView.wrapper.view.seriesList) {
//        if (s.datas.count > 0) {
//            hasData = YES;
//            break;
//        }
//    }
//    if(hasData) {
//        self.textLabel.hidden = YES;
//        self.chartView.wrapper.view.hidden = NO;
//        [self drawChartLabels];
//    } else {
//        [self drawLabelWithText:NSLocalizedString(@"BuildingChart_NoData", @"")];
//        self.chartView.wrapper.view.hidden = YES;
//    }
//}

-(BOOL)isSeriesHasLegend:(DCXYSeries*)series index:(NSUInteger)index {
    return series.datas.count != 0;
}

-(NSString*)getLegendText:(DCXYSeries*)series index:(NSUInteger)index {
    if (series.type == DCSeriesTypeLine) {
        return kBenchmarkTitle;
    } else {
        REMCommodityModel *commodity = [[REMCommodityModel systemCommodities] objectForKey:[NSNumber numberWithLongLong:self.commodityId]];
        return [NSString stringWithFormat:kAverageDataTitle,commodity.comment];
    }
    return series.target.name;
}

//-(void)drawChartLabels {
//    CGFloat legendLeft = 57;
//    CGFloat labelDistance = 18;
//    CGFloat legendTop = 0;
//    for (DCXYSeries* series in myView.chartView.seriesList) {
//        CGFloat fontSize = 14;
//        // Draw legend
//        NSString* legendText = series.target.name;
//        CGSize textSize = [legendText sizeWithFont:[UIFont systemFontOfSize:fontSize]];
//        CGFloat benchmarkWidth = textSize.width + 26;
//        CGRect benchmarkFrame = CGRectMake(legendLeft, legendTop, benchmarkWidth, MAX(textSize.height, 15));
//        legendLeft = legendLeft + benchmarkWidth + labelDistance;
//        if (legendLeft > myView.legendView.bounds.size.width) {
//            legendLeft = 57;
//            legendTop += 14*2;
//        }
//        REMBuildingChartSeriesIndicator *benchmarkIndicator = [[REMBuildingChartSeriesIndicator alloc] initWithFrame:benchmarkFrame title:legendText andColor:series.color];
//        [self.view addSubview:benchmarkIndicator];
//    }
//    self.view.backgroundColor = [UIColor grayColor];
//    CGFloat fontSize = 14;
//    CGFloat labelTopOffset = self.chartView.wrapper.view.bounds.size.height+18;
//    CGFloat labelLeftOffset = 57;
//    CGFloat labelDistance = 18;
//    
//    for (DCXYSeries* series in self.chartView.wrapper.view.seriesList) {
//        NSString* legendText = nil;
//        UIColor* legendColor = nil;
//        if (series.type == DCSeriesTypeLine) {
//            if (series.datas.count == 0) continue;
//            legendText = kBenchmarkTitle;
//            legendColor = series.color;
//        } else {
//            REMCommodityModel *commodity = [[REMCommodityModel systemCommodities] objectForKey:[NSNumber numberWithLongLong:self.commodityId]];
//            legendText = [NSString stringWithFormat:kAverageDataTitle,commodity.comment];
//            legendColor = [UIColor whiteColor];
//        }
//        CGFloat averageDataWidth = [legendText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width + 26;
//        REMBuildingChartSeriesIndicator *averageDataIndicator = [[REMBuildingChartSeriesIndicator alloc] initWithFrame:CGRectMake(labelLeftOffset, labelTopOffset, averageDataWidth, fontSize) title:legendText andColor:legendColor];
//        [self.view addSubview:averageDataIndicator];
//    }
//}



@end
