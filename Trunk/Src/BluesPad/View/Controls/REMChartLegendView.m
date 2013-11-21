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
    switch (target.type) {
        case REMEnergyTargetTag:
            return target.name;
            
        case REMEnergyTargetTarget:
            return REMLocalizedString(@"Chart_TargetValue");
        case REMEnergyTargetBaseline:
            return REMLocalizedString(@"Chart_BaselineValue");
            
        case REMEnergyTargetPlain:
            return REMLocalizedString(@"Chart_TOUPlain");
        case REMEnergyTargetPeak:
            return REMLocalizedString(@"Chart_TOUPeak");
        case REMEnergyTargetValley:
            return REMLocalizedString(@"Chart_TOUValley");
            
        case REMEnergyTargetCarbon:
        case REMEnergyTargetCost:
        {
            //total or commodity
            if([self.parameters isKindOfClass:[REMWidgetCommoditySearchModel class]]){
                REMWidgetCommoditySearchModel *commodityParameters = (REMWidgetCommoditySearchModel *)self.parameters;
                
                if(commodityParameters.commodityIdArray.count>0){
                    return REMCommodities[@(target.commodityId)];
                }
                else{
                    return target.type == REMEnergyTargetCarbon ? REMLocalizedString(@"Chart_CarbonTotal") : REMLocalizedString(@"Chart_CostTotal");
                }
            }
            
            return nil;
        }
            
        case REMEnergyTargetBenchmarkValue:
        {
            return [self.parameters respondsToSelector:@selector(benchmarkText)] ? [(id)self.parameters benchmarkText] : nil;
        }
            
        case REMEnergyTargetCalcValue:
        case REMEnergyTargetOrigValue:
        case REMEnergyTargetTargetValue:
        case REMEnergyTargetBaseValue:
        {
            NSString *format = nil;
            if(target.type == REMEnergyTargetCalcValue){ format = REMLocalizedString(@"Chart_TargetCalcValue"); }
            else if(target.type == REMEnergyTargetOrigValue){ format = REMLocalizedString(@"Chart_TargetOrigValue"); }
            else if(target.type == REMEnergyTargetTargetValue){ format = REMLocalizedString(@"Chart_TargetTargetValue"); }
            else if(target.type == REMEnergyTargetBaseValue){ format = REMLocalizedString(@"Chart_TargetBaseValue"); }
            else{format = nil;}
            
            if(format == nil)
                return nil;
            
            //commodity or tag?
            if([self.parameters isKindOfClass:[REMWidgetTagSearchModel class]]){ //tag
                return [NSString stringWithFormat:format, target.name];
            }
            else if([self.parameters isKindOfClass:[REMWidgetCommoditySearchModel class]]){ //carbon cost
                NSArray *commodityIdArray = ((REMWidgetCommoditySearchModel *)self.parameters).commodityIdArray;
                NSString *prefix = nil;
                
                if(commodityIdArray.count>0){
                    prefix = REMCommodities[@(target.commodityId)];
                }
                else{
                    prefix = REMLocalizedString(@"Chart_CarbonTotal");
                }
                
                [NSString stringWithFormat:format, prefix];
            }
            else{
                return nil;
            }
        }
            
        case REMEnergyTargetHierarchy:
        case REMEnergyTargetKpi:
        case REMEnergyTargetAreaConsumption:
        default:
        {
            return target.name;
        }
    }
}

@end
