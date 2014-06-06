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

+(NSString *)seriesKeyWithEnergyTarget:(REMEnergyTargetModel *)target energyData:(REMEnergyViewData *)energyData andWidgetContentSyntax:(DWrapperConfig *)syntax
{
    REMDataStoreType storeType = syntax.storeType;
    
    NSString *targetType=@"%", *targetId=@"%", *sourceType=@"%", *seriesType=@"%", *timeType=@"%", *offset=@"%";
    NSString *targetPath = [REMSeriesKeyFormattor getTargetPath:target];
    
    //    REMDSEnergyTagsTrend                = 106001,
    //    REMDSEnergyTagsDistribute           = 106003,
    
    //    REMDSEnergyMultiTimeTrend           = 106004,
    //    REMDSEnergyMultiTimeDistribute      = 106005,
    
    //    REMDSEnergyCarbon                   = 106006,
    //    REMDSEnergyCarbonDistribute         = 106008,
    //    REMDSEnergyCost                     = 106009,
    //    REMDSEnergyCostDistribute           = 106011,
    //    REMDSEnergyCostElectricity          = 106012,
    
    //    REMDSEnergyTagsTrendUnit            = 106002,
    //    REMDSEnergyCarbonUnit               = 106007,
    //    REMDSEnergyCostUnit                 = 106010,
    //    REMDSEnergyRatio                    = 106013,
    
    
//    REMDSEnergyRankingEnergy            = 106014,
//    REMDSEnergyRankingCost              = 106015,
//    REMDSEnergyRankingCarbon            = 106016,
//    REMDSEnergyLabeling                 = 106017,
    
    if(storeType == REMDSEnergyTagsTrend || storeType == REMDSEnergyTagsDistribute){
        targetType = @"0";
        targetId = [NSString stringWithFormat:@"%llu", [target.targetId longLongValue]];
        sourceType = @"%";
        seriesType = @"%";
    }
    else if(storeType == REMDSEnergyMultiTimeTrend || storeType == REMDSEnergyMultiTimeDistribute){
        targetType = @"0";
        targetId = [NSString stringWithFormat:@"%llu", [target.targetId longLongValue]];
        sourceType = @"%";
        seriesType = @"%";
        
        int targetIndex = 0;
        for (int i=0;i<energyData.targetEnergyData.count;i++) {
            if([[energyData.targetEnergyData[i] target] isEqual:target]){
                targetIndex = i;
                break;
            }
        }
        
        REMTimeRange *timeRange = syntax.timeRanges[targetIndex];
        if(REMIsNilOrNull(timeRange)){
            timeType=@"0";
            offset=@"0";
        }
        else{
            timeType = [NSString stringWithFormat:@"%d", timeRange.timeType];
            offset = [NSString stringWithFormat:@"%llu", timeRange.offset];
        }
    }
    else if(storeType == REMDSEnergyCarbon || storeType == REMDSEnergyCarbonDistribute || storeType == REMDSEnergyCost || storeType == REMDSEnergyCostDistribute || storeType == REMDSEnergyCostElectricity){
        targetType = @"1";
        targetId = [NSString stringWithFormat:@"%llu", target.commodityId];
        sourceType = @"%";
        
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
            targetType = @"2";
            targetId = @""; //industryId+zoneId?
            sourceType = @"4";
        }
        else{
        }
        
        seriesType = @"%";
    }

    NSString *key = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@", targetType, targetId, targetPath, sourceType, seriesType, timeType, offset];
    
    return key;
}

+(NSString *)getTargetPath:(REMEnergyTargetModel *)target
{
    REMTargetAssociationModel *association = target.association;
    
    NSString *targetPath = @"%";
    NSNumber *hierarchyId = association.hierarchyId;
    
    //what if both systemDimensionId and areaDimensionId are not nil?
    //default think target is associated on system, add assert to ensure
    
    NSAssert(hierarchyId!=nil, @"hierarchyid should not be nil");
    
    if(REMIsNilOrNull(association.systemDimensionId) && REMIsNilOrNull(association.areaDimensionId) && !REMIsNilOrNull(association.hierarchyId)){ //hierarchy
        targetPath = [NSString stringWithFormat:@"0/%llu", [hierarchyId longLongValue]];
    }
    
    if(!REMIsNilOrNull(association.systemDimensionId)){ //system dimension
        targetPath = [NSString stringWithFormat:@"1/%llu/%llu", [hierarchyId longLongValue], [association.systemDimensionId longLongValue]];
    }
    
    if(!REMIsNilOrNull(association.areaDimensionId)){ //area dimension
        targetPath = [NSString stringWithFormat:@"2/%llu/%llu", [hierarchyId longLongValue], [association.areaDimensionId longLongValue]];
    }
    
    return targetPath;
}

@end
