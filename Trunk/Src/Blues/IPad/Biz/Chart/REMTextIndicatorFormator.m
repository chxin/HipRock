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
#import "REMWidgetTagSearchModel.h"
#import "REMWidgetMultiTimespanSearchModel.h"
#import "REMEnergyViewData.h"
#import "REMTargetEnergyData.h"
#import "REMWidgetContentSyntax.h"
#import "REMDataStore.h"

@implementation REMTextIndicatorFormator

+(NSString *)formatTargetName:(REMEnergyTargetModel *)target inEnergyData:(REMEnergyViewData *)data withWidget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    switch (target.type) {
        case REMEnergyTargetTag:
            if([parameters isKindOfClass:[REMWidgetMultiTimespanSearchModel class]]){
                int index = (int)[data.targetEnergyData indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if([((REMTargetEnergyData *)obj).target isEqual:target]){
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                //TODO: move time forward
//                REMEnergyStep step = ((REMWidgetMultiTimespanSearchModel *)parameters).step;
//                NSDate *start1 = [REMTimeHelper add:-1 steps:step onTime:[parameters.searchTimeRangeArray[index] startTime]];
//                NSDate *end1 = [REMTimeHelper add:-1 steps:step onTime:[parameters.searchTimeRangeArray[index] endTime]];
//                REMTimeRange *newRange = [[REMTimeRange alloc] initWithStartTime:start1 EndTime:end1];
                
                NSString *timeString = [REMTimeHelper formatTimeRangeFullHour: parameters.searchTimeRangeArray[index]];
//                NSString *timeString = [REMTimeHelper formatTimeRangeFullHour: newRange];
                
                return timeString;
            }
            else{
                return target.name;
            }
            
        case REMEnergyTargetTarget:
            return REMIPadLocalizedString(@"Chart_TargetValue");
        case REMEnergyTargetBaseline:
            return REMIPadLocalizedString(@"Chart_BaselineValue");
            
        case REMEnergyTargetPlain:
            return REMIPadLocalizedString(@"Chart_TOUPlain");
        case REMEnergyTargetPeak:
            return REMIPadLocalizedString(@"Chart_TOUPeak");
        case REMEnergyTargetValley:
            return REMIPadLocalizedString(@"Chart_TOUValley");
            
        case REMEnergyTargetHierarchy:
        case REMEnergyTargetCarbon:
        case REMEnergyTargetCost:
        {
            //total or commodity
            if([parameters isKindOfClass:[REMWidgetCommoditySearchModel class]]){
                REMWidgetCommoditySearchModel *commodityParameters = (REMWidgetCommoditySearchModel *)parameters;
                
                REMWidgetContentSyntaxWidgetType contentSyntaxWidgetType = [widget getSyntax].contentSyntaxWidgetType;
                if(commodityParameters.commodityIdArray.count>0 || contentSyntaxWidgetType == REMWidgetContentSyntaxWidgetTypePie){
                    //return REMCommodities[@(target.commodityId)];
                    NSString *commodityKey = REMCommodities[@(target.commodityId)];
                    return REMIPadLocalizedString(commodityKey);
                }
                else{
                    return target.type == REMEnergyTargetCarbon ? REMIPadLocalizedString(@"Chart_CarbonTotal") : REMIPadLocalizedString(@"Chart_CostTotal");
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
            REMDataStoreType store = [widget getSyntax].dataStoreType;
            
            switch (target.type) {
                case REMEnergyTargetCalcValue:
                    format = REMIPadLocalizedString(@"Chart_TargetCalcValue");
                    break;
                case REMEnergyTargetOrigValue:
                    format = REMIPadLocalizedString(@"Chart_TargetOrigValue");
                    break;
                case REMEnergyTargetTargetValue:{
                    if(store == REMDSEnergyTagsTrendUnit || store==REMDSEnergyRatio){
                        return target.name;
                    }
                    
                    format = REMIPadLocalizedString(@"Chart_TargetTargetValue");
                    break;
                }
                case REMEnergyTargetBaseValue:
                    if(store == REMDSEnergyTagsTrendUnit || store==REMDSEnergyRatio){
                        return target.name;
                    }
                    
                    format = REMIPadLocalizedString(@"Chart_TargetBaseValue");
                    break;
                    
                default:
                    format = nil;
                    break;
            }
            
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
                    //prefix = REMCommodities[@(target.commodityId)];
                    NSString *commodityKey=REMCommodities[@(target.commodityId)];
                    prefix = REMIPadLocalizedString(commodityKey);
                }
                else{
                    prefix = REMIPadLocalizedString(@"Chart_CarbonTotal");
                }
                
                return [NSString stringWithFormat:format, prefix];
            }
            else{
                return nil;
            }
        }
            
        case REMEnergyTargetKpi:
        case REMEnergyTargetAreaConsumption:
        default:
        {
            return target.name;
        }
    }
}
@end
