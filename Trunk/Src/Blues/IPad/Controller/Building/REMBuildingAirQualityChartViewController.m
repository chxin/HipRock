/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityChartHandler.m
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingAirQualityChartViewController.h"
#import "REMAirQualityDataModel.h"
#import "REMCommonHeaders.h"
#import "REMDataRange.h"
#import "REMBuildingChartSeriesIndicator.h"
#import "REMBuildingConstants.h"
#import "REMBuildingAirQualityWrapper.h"
#import "DCXYChartBackgroundBand.h"

@interface REMBuildingAirQualityChartViewController ()

@property (nonatomic,strong) REMAirQualityDataModel *airQualityData;

@end

@implementation REMBuildingAirQualityChartViewController

#define kTagCodeSuffixOutdoor @"Outdoor"
#define kTagCodeSuffixHoneywell @"Honeywell"
#define kTagCodeSuffixMayAir @"MayAir"
#define kAmericanStandardCode @"美国标准"
#define kChinaStandardCode @"中国标准"

#define kWordAirQualityOutdoor REMIPadLocalizedString(@"Building_AirQualityOutdoor")
#define kWordAirQualityHoneywell REMIPadLocalizedString(@"Building_AirQualityHoneywell")
#define kWordAirQualityMayair REMIPadLocalizedString(@"Building_AirQualityMayair")
#define kWordAirQualityAmericanStandard REMIPadLocalizedString(@"Building_AirQualityAmericanStandard")
#define kWordAirQualityChinaStandard REMIPadLocalizedString(@"Building_AirQualityChinaStandard")


static NSDictionary *codeNameMap;

//- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
//{
//    self = [super initWithViewFrame:frame];
//    if (self) {
//        // Custom initialization
//        
//        self.requestUrl=REMDSBuildingAirQuality;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.requestUrl=REMDSBuildingAirQuality;
}


-(NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    NSDictionary *parameter = @{@"buildingId":[NSNumber numberWithLongLong: buildingId]};
    
    return parameter;
}

-(REMEnergyViewData*)convertData:(id)data {
    self.airQualityData = [[REMAirQualityDataModel alloc] initWithDictionary:data];
    if(self.airQualityData!=nil){
        return self.airQualityData.airQualityData;
    }
    return nil;
}

-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]init];
    wrapperConfig.step = [self getEnergyStep];
    DCChartStyle* style = [DCChartStyle getCoverStyle];
    REMBuildingAirQualityWrapper* wrapper = [[REMBuildingAirQualityWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig style:style];
    [wrapper setStandardsBands:self.airQualityData.standards];
    return wrapper;
}

-(REMEnergyStep)getEnergyStep {
    return REMEnergyStepDay;
}

-(NSString*)getLegendText:(DCXYSeries*)series index:(NSUInteger)index {
    REMEnergyTargetModel* target = series.target;
    if([target.code hasSuffix:kTagCodeSuffixHoneywell]){
        return kWordAirQualityHoneywell;
    }
    else if([target.code hasSuffix:kTagCodeSuffixMayAir]){
        return kWordAirQualityMayair;
    }
    else if([target.code hasSuffix:kTagCodeSuffixOutdoor]){
        return kWordAirQualityOutdoor;
    }
    return REMEmptyString;
}

-(void)purgeMemory {
    self.airQualityData = nil;
    [super purgeMemory];
}

@end
