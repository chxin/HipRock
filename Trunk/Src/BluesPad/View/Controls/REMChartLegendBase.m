/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendBase.m
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMChartLegendBase.h"
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMEnergyTargetModel.h"
#import "REMChartLegendItem.h"

@implementation REMChartLegendBase

+ (REMChartLegendBase *)legendWithEnergyData:(REMEnergyViewData *)data andWidgetInfo:(REMWidgetObject *)widget
{
    switch (widget.contentSyntax.dataStoreType) {
        case REMDSEnergyTagsTrendUnit:
        case REMDSEnergyCarbonUnit:
        case REMDSEnergyCostUnit:
            break;
            break;
        case REMDSEnergyMultiTimeTrend:
        case REMDSEnergyMultiTimeDistribute:
            break;
        case REMDSEnergyCarbon:
        case REMDSEnergyCarbonDistribute:
            break;
            break;
            break;
        case REMDSEnergyCost:
        case REMDSEnergyCostDistribute:
            break;
            break;
            break;
        case REMDSEnergyCostElectricity:
            break;
        case REMDSEnergyRatio:
            break;
        case REMDSEnergyRankingEnergy:
            break;
        case REMDSEnergyRankingCost:
            break;
        case REMDSEnergyRankingCarbon:
            break;
        case REMDSEnergyLabeling:
            break;
            
        case REMDSEnergyTagsTrend:
        case REMDSEnergyTagsDistribute:
        default:
            break;
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


+(REMChartLegendItemModel *)legendItemWithTarget:(REMEnergyTargetModel *)target
{
    REMChartLegendItemModel *model = [[REMChartLegendItemModel alloc] init];
    
    switch (target.type) {
        case REMEnergyTargetTarget:
            model.title = REMLocalizedString(@"Chart_TargetValue");
            break;
        case REMEnergyTargetBaseline:
            model.title = REMLocalizedString(@"Chart_BaselineValue");
            break;
            
        case REMEnergyTargetPlain:
            model.title = REMLocalizedString(@"Chart_TOUPeak");
            break;
        case REMEnergyTargetPeak:
            model.title = REMLocalizedString(@"Chart_TOUValley");
            break;
        case REMEnergyTargetValley:
            model.title = REMLocalizedString(@"Chart_TOUPlain");
            break;
            
        case REMEnergyTargetCarbon:
        case REMEnergyTargetCost:
            model.title = REMCommodities[@(target.commodityId)];
            break;

        case REMEnergyTargetBenchmarkValue:
            break;
            
        case REMEnergyTargetTag:
        case REMEnergyTargetKpi:
        case REMEnergyTargetCalcValue:
        case REMEnergyTargetOrigValue:
        case REMEnergyTargetTargetValue:
        case REMEnergyTargetBaseValue:
        case REMEnergyTargetHierarchy:
            model.title = target.name;
            break;
        default:
            break;
    }
    
    return model;
}

@end
