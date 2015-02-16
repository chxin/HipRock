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
#import "REMDataRange.h"
#import "REMBuildingChartSeriesIndicator.h"
#import "REMBuildingAverageWrapper.h"
#import "REMCommodityModel.h"
#import "DCXYSeries.h"



@interface REMBuildingAverageViewController ()

@property (nonatomic) long long commodityId;
@end

@implementation REMBuildingAverageViewController


//static NSString *kBenchmarkTitle = @"目标值";
//static NSString *kAverageDataTitle = @"单位面积用%@";

- (void)purgeMemory{
    [super purgeMemory];
//    self.chartView=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.requestUrl=REMDSBuildingAverageDataWithBaseline;
}

//- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
//{
//    self = [super initWithViewFrame:frame];
//    if (self) {
//        self.requestUrl=REMDSBuildingAverageData;
//    }
//    return self;
//}

-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]init];
    wrapperConfig.step = REMEnergyStepMonth;
    DCChartStyle* style = [DCChartStyle getCoverStyle];
    REMBuildingAverageWrapper* wrapper = [[REMBuildingAverageWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig style:style];
    return wrapper;
}

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    self.commodityId = commodityID;
    
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong:buildingId], @"commodityId":[NSNumber numberWithLongLong:commodityID]};
    
    return parameter;
}

-(BOOL)isSeriesHasLegend:(DCXYSeries*)series index:(NSUInteger)index {
    return series.datas.count != 0;
}

-(NSString*)getLegendText:(DCXYSeries*)series index:(NSUInteger)index {
    if (series.type == DCSeriesTypeLine) {
        return series.target.name;//kBenchmarkTitle;
    } else {
        NSString *commodityKey = REMCommodities[@(self.commodityId)];
        return [NSString stringWithFormat:REMIPadLocalizedString(@"Building_MonthlyAverageUsageChartAverageSeriesLegend"),REMIPadLocalizedString(commodityKey)];
    }
    return series.target.name;
}



@end
