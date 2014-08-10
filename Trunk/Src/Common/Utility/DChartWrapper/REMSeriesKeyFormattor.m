/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSeriesKeyFormattor.m
 * Date Created : 张 锋 on 5/29/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSeriesKeyFormattor.h"
#import "REMTargetAssociationModel.h"
#import "REMDataStore.h"

@implementation REMSeriesKeyFormattor

+(NSString *)seriesKeyWithEnergyTarget:(REMEnergyTargetModel *)target energyData:(REMEnergyViewData *)energyData andWidgetContentSyntax:(REMWidgetContentSyntax *)syntax
{
    REMDataStoreType storeType = syntax.dataStoreType;
    
    NSString *targetType=@"%", *targetId=@"%", *sourceType=@"%", *seriesType=@"%", *timeType=@"%", *offset=@"%";
    NSString *targetPath = [REMSeriesKeyFormattor getTargetPath:target withSyntax:syntax];
    
    if(storeType == REMDSEnergyTagsTrend || storeType == REMDSEnergyTagsDistribute){
        targetType = @"0";
        targetId = [NSString stringWithFormat:@"%llu", [target.targetId longLongValue]];
        sourceType = @"0";
        seriesType = @"%";
        timeType = @"0";
        offset = @"0";
    }
    else if(storeType == REMDSEnergyMultiTimeTrend || storeType == REMDSEnergyMultiTimeDistribute){
        targetType = @"0";
        targetId = [NSString stringWithFormat:@"%llu", [target.targetId longLongValue]];
        sourceType = @"0";
        seriesType = @"%";
        
        int targetIndex = 0;
        for (int i=0;i<energyData.targetEnergyData.count;i++) {
            if([[energyData.targetEnergyData[i] target] isEqual:target]){
                targetIndex = i;
                break;
            }
        }
        
        timeType = @"0";
        offset = @"0";
        REMTimeRange *baseRange = syntax.timeRanges[0];
        if(targetIndex != 0){
            REMTimeRange *timeRange = syntax.timeRanges[targetIndex];
            
            if(!REMIsNilOrNull(timeRange.timeType) && !REMIsNilOrNull(timeRange.offset)){
                timeType = [NSString stringWithFormat:@"%d", [timeRange.timeType intValue] ];
                offset = [NSString stringWithFormat:@"%lld", [timeRange.offset longLongValue]];
            }
            else {
                timeType = @"1";
                offset = [NSString stringWithFormat:@"%0.0f", [baseRange.startTime timeIntervalSinceDate:timeRange.startTime]];
            }
        }
    }
    else if(storeType == REMDSEnergyCarbon || storeType == REMDSEnergyCarbonDistribute || storeType == REMDSEnergyCost || storeType == REMDSEnergyCostDistribute || storeType == REMDSEnergyCostElectricity){
        targetType = @"1";
        targetId = [NSString stringWithFormat:@"%llu", target.commodityId];
        sourceType = @"0";
        timeType=@"0";
        offset=@"0";
        
        if(target.type == REMEnergyTargetPlain){
            seriesType = @"2";
        }
        else if(target.type == REMEnergyTargetPeak){
            seriesType = @"0";
        }
        else if(target.type == REMEnergyTargetValley){
            seriesType = @"1";
        }
        else{}
    }
    else if(storeType == REMDSEnergyTagsTrendUnit || storeType == REMDSEnergyCarbonUnit || storeType == REMDSEnergyCostUnit || storeType == REMDSEnergyRatio){
        if(storeType == REMDSEnergyTagsTrendUnit || storeType == REMDSEnergyRatio){
            targetType = @"0";
            //if target is benchmark, targetid is null
            
            targetId = REMIsNilOrNull(target.targetId) ? @"%" : [NSString stringWithFormat:@"%llu", [target.targetId longLongValue]];
        }
        else{ //(storeType == REMDSEnergyCarbonUnit || storeType == REMDSEnergyCostUnit){
            targetType = @"1";
            targetId = [NSString stringWithFormat:@"%llu", target.commodityId];
        }
        
        if(target.type == REMEnergyTargetCalcValue){
            sourceType = @"3";
        }
        else if(target.type == REMEnergyTargetOrigValue){
            sourceType = @"0";
        }
        else if(target.type == REMEnergyTargetTargetValue){
            sourceType = @"2";
        }
        else if(target.type == REMEnergyTargetBaseValue){
            sourceType = @"1";
        }
        else if(target.type == REMEnergyTargetBenchmarkValue){
            NSNumber *industryId = syntax.params[@"benchmarkOption"][@"IndustryId"];
            NSNumber *zoneId = syntax.params[@"benchmarkOption"][@"ZoneId"];
            targetType = @"2";
            targetId = [NSString stringWithFormat: @"%llu+%llu",[industryId longLongValue],[zoneId longLongValue]]; //industryId+zoneId?
            sourceType = @"4";
        }
        else{
        }
        
        seriesType = @"%";
        timeType=@"0";
        offset=@"0";
    }

    NSString *key = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@_%@", targetType, targetId, targetPath, sourceType, seriesType, timeType, offset];
    
    return key;
}

+(NSString *)getTargetPath:(REMEnergyTargetModel *)target withSyntax:(REMWidgetContentSyntax *)syntax
{
    REMTargetAssociationModel *association = target.association;
    
    NSNumber *hierarchyId = @(-1);
    NSString *targetPath = @"%";
    if(target.type == REMEnergyTargetBenchmarkValue){
        return targetPath;
    }
    
    if(association == nil){
        if(syntax.dataStoreType == REMDSEnergyTagsTrend ||
           syntax.dataStoreType == REMDSEnergyTagsDistribute ||
           syntax.dataStoreType == REMDSEnergyMultiTimeTrend ||
           syntax.dataStoreType == REMDSEnergyMultiTimeDistribute ||
           syntax.dataStoreType == REMDSEnergyRatio ||
           syntax.dataStoreType == REMDSEnergyTagsTrendUnit ||
           syntax.dataStoreType == REMDSEnergyMultiTimeTrend ||
           syntax.dataStoreType == REMDSEnergyMultiTimeDistribute){
            
            if(!REMIsNilOrNull(syntax.params[@"options"]) && [syntax.params[@"options"] count] > 0){
                if([syntax.params[@"options"] count] == 1){
                    hierarchyId = syntax.params[@"options"][0][@"HierId"];
                }
                else{
                    //NSLog(syntax.params[@"options"]);
                    int index = -1;
                    for (int i=0;i<[syntax.params[@"options"] count];i++) {// NSDictionary *item in syntax.params[@"options"]){
                        NSDictionary *item = syntax.params[@"options"][i];
                        if(!REMIsNilOrNull(item) && !REMIsNilOrNull(item[@"Id"]) && [item[@"Id"] isEqualToNumber:target.targetId]){
                            index = i;
                            break;
                        }
                    }
                    hierarchyId = [syntax.params[@"options"][index] objectForKey:@"HierId"];
                }
            }
        }
        else if(syntax.dataStoreType == REMDSEnergyCarbon || syntax.dataStoreType == REMDSEnergyCarbonDistribute || syntax.dataStoreType == REMDSEnergyCarbonUnit){
            if(!REMIsNilOrNull(syntax.params[@"hierarchyId"])){
                hierarchyId = syntax.params[@"hierarchyId"];
            }
        }
        else{
            hierarchyId = @(-1);
        }
        
        targetPath = [NSString stringWithFormat:@"0/%llu", [hierarchyId longLongValue]];
    }
    else{
        hierarchyId = association.hierarchyId;
        
        if(REMIsNilOrNull(association.systemDimensionId) && REMIsNilOrNull(association.areaDimensionId) && !REMIsNilOrNull(association.hierarchyId)){ //hierarchy
            targetPath = [NSString stringWithFormat:@"0/%llu", [hierarchyId longLongValue]];
        }
        
        if(!REMIsNilOrNull(association.systemDimensionId)){ //system dimension
            targetPath = [NSString stringWithFormat:@"1/%llu/%llu", [hierarchyId longLongValue], [association.systemDimensionId longLongValue]];
        }
        
        if(!REMIsNilOrNull(association.areaDimensionId)){ //area dimension
            targetPath = [NSString stringWithFormat:@"2/%llu/%llu", [hierarchyId longLongValue], [association.areaDimensionId longLongValue]];
        }
    }
    
    NSAssert(hierarchyId!=nil, @"hierarchyid should not be nil");
    
    return targetPath;
}

@end
