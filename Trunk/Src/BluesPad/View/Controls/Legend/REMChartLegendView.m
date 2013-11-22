/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendView.m
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMChartLegendView.h"
#import "REMChartLegendItem.h"
#import "REMColor.h"
#import "REMWidgetStepEnergyModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMWidgetTagSearchModel.h"
#import "REMTextIndicatorFormator.h"

@implementation REMChartLegendView

-(NSArray *)convertItemModels
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.data.targetEnergyData.count; i++){
        REMTargetEnergyData *targetData = self.data.targetEnergyData[i];
        
        REMChartLegendItemModel *model = [[REMChartLegendItemModel alloc] init];
        
        model.index = i;
        model.type = [REMChartSeriesIndicator indicatorTypeWithDiagramType:self.widget.diagramType];
        model.title = [self format:targetData.target];
        model.delegate = self.itemDelegate;
        model.tappable = NO;
        
        [models addObject:model];
    }
    
    return models;
}

-(NSString *)format:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target withWidget:self.widget andParameters:self.parameters];
}

@end
