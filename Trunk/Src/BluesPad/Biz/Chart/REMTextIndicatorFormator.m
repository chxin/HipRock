/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTextIndicatorFormator.m
 * Date Created : 张 锋 on 11/21/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMTextIndicatorFormator.h"
#import "REMEnergyTargetModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMWidgetObject.h"
#import "REMWidgetTagSearchModel.h"

@implementation REMTextIndicatorFormator

+(NSString *)formatTargetName:(REMEnergyTargetModel *)target withWidget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
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
            if([parameters isKindOfClass:[REMWidgetCommoditySearchModel class]]){
                REMWidgetCommoditySearchModel *commodityParameters = (REMWidgetCommoditySearchModel *)parameters;
                
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
            return [parameters respondsToSelector:@selector(benchmarkText)] ? [(id)parameters benchmarkText] : nil;
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
            if([parameters isKindOfClass:[REMWidgetTagSearchModel class]]){ //tag
                return [NSString stringWithFormat:format, target.name];
            }
            else if([parameters isKindOfClass:[REMWidgetCommoditySearchModel class]]){ //carbon cost
                NSArray *commodityIdArray = ((REMWidgetCommoditySearchModel *)parameters).commodityIdArray;
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