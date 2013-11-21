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
#import "REMColor.h"

@implementation REMChartLegendBase


-(REMChartLegendBase *)initWithData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget parameters:(REMWidgetSearchModelBase *)parameters andHiddenIndexes:(NSArray *)hiddenIndexes
{
    self = [super initWithFrame:kDMChart_ToolbarHiddenFrame];
    
    if(self){
        self.data = data;
        self.widget = widget;
        self.parameters = parameters;
        
        self.formator = [REMLegendFormatorBase formatorWidthData:data widget:widget andParameters:parameters];
        self.itemModels = [self convertItemModels];
        
        [self render:hiddenIndexes];
    }
    
    return self;
}

//@virtual
-(NSArray *)convertItemModels
{
    return nil;
}

//@private
-(void)render:(NSArray *)hiddenIndexes
{
    CGFloat scrollViewContentWidth = (kDMChart_LegendItemWidth + kDMChart_LegendItemLeftOffset) * self.itemModels.count + kDMChart_LegendItemLeftOffset;
    
    self.backgroundColor = [REMColor colorByHexString:kDMChart_BackgroundColor];
    self.contentSize = CGSizeMake(scrollViewContentWidth, kDMChart_ToolbarHeight);
    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    for(int i=0;i<self.itemModels.count; i++){
        REMChartLegendItemModel *model = self.itemModels[i];
        
        CGFloat x = i * (kDMChart_LegendItemWidth + kDMChart_LegendItemLeftOffset) + kDMChart_LegendItemLeftOffset;
        CGFloat y = (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2;
        
        REMChartLegendItem *legend = [[REMChartLegendItem alloc] initWithModel:model];
        legend.frame = CGRectMake(x, y, kDMChart_LegendItemWidth, kDMChart_LegendItemHeight);
        
        if(hiddenIndexes != nil && hiddenIndexes.count > 0 && [hiddenIndexes containsObject:@(i)]){
            [legend setSelected:YES];
        }
        
        [self addSubview:legend];
    }
}


//switch (widget.contentSyntax.dataStoreType) {
//    case REMDSEnergyTagsTrendUnit:
//    case REMDSEnergyCarbonUnit:
//    case REMDSEnergyCostUnit:
//    case REMDSEnergyMultiTimeTrend:
//    case REMDSEnergyMultiTimeDistribute:
//    case REMDSEnergyCarbon:
//    case REMDSEnergyCarbonDistribute:
//    case REMDSEnergyCost:
//    case REMDSEnergyCostDistribute:
//    case REMDSEnergyCostElectricity:
//    case REMDSEnergyRatio:
//    case REMDSEnergyRankingEnergy:
//    case REMDSEnergyRankingCost:
//    case REMDSEnergyRankingCarbon:
//    case REMDSEnergyLabeling:
//    case REMDSEnergyTagsTrend:
//    case REMDSEnergyTagsDistribute:
//}
//
//switch (target.type) {
//    case REMEnergyTargetTarget:
//    case REMEnergyTargetBaseline:
//    case REMEnergyTargetPlain:
//    case REMEnergyTargetPeak:
//    case REMEnergyTargetValley:
//    case REMEnergyTargetCarbon:
//    case REMEnergyTargetCost:
//    case REMEnergyTargetBenchmarkValue:
//    case REMEnergyTargetTag:
//    case REMEnergyTargetKpi:
//    case REMEnergyTargetCalcValue:
//    case REMEnergyTargetOrigValue:
//    case REMEnergyTargetTargetValue:
//    case REMEnergyTargetBaseValue:
//    case REMEnergyTargetHierarchy:
//}

@end
