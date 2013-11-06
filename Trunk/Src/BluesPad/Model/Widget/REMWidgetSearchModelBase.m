//
//  REMWidgetSearchModelBase.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetTagSearchModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMWidgetRankingSearchModel.h"

@implementation REMWidgetSearchModelBase

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType withParam:(NSDictionary *)param
{
    REMWidgetSearchModelBase *model=nil;
    if(dataStoreType == REMDSEnergyTagsTrend ||
       dataStoreType == REMDSEnergyTagsTrendUnit ||
       dataStoreType == REMDSEnergyTagsDistribute ||
       dataStoreType ==REMDSEnergyMultiTimeTrend ||
       dataStoreType == REMDSEnergyMultiTimeDistribute){
        model = [[REMWidgetTagSearchModel alloc]init];
    }
    else if(dataStoreType ==REMDSEnergyCarbon ||
            dataStoreType ==REMDSEnergyCarbonDistribute ||
            dataStoreType == REMDSEnergyCarbonUnit ||
            dataStoreType == REMDSEnergyCost ||
            dataStoreType ==REMDSEnergyCostDistribute ||
            dataStoreType == REMDSEnergyCostElectricity ||
            dataStoreType == REMDSEnergyCostUnit)
    {
        model = [[REMWidgetCommoditySearchModel alloc]init];
    }
    else if(dataStoreType == REMDSEnergyRankingCarbon ||
            dataStoreType == REMDSEnergyRankingCost ||
            dataStoreType == REMDSEnergyRankingEnergy){
        model=[[REMWidgetRankingSearchModel alloc]init];
    }
    else if(dataStoreType == REMDSEnergyLabeling){
        
    }
    [model setModelBySearchParam:param];
    
    return model;
}

- (NSArray *)timeRangeToDictionaryArray
{
    NSMutableArray *newTimeRangeArray=[[NSMutableArray alloc]initWithCapacity:self.timeRangeArray.count];
    
    for (int i=0; i<self.timeRangeArray.count; ++i) {
        REMTimeRange *range= self.timeRangeArray[i];
        [newTimeRangeArray addObject:@{@"StartTime":[REMTimeHelper jsonStringFromDate:range.startTime],@"EndTime":[REMTimeHelper jsonStringFromDate:range.endTime]}];
    }
    
    return newTimeRangeArray;
}

- (void)setTimeRangeItem:(REMTimeRange *)range AtIndex:(NSUInteger)index
{
    NSMutableArray *newArray=[self.timeRangeArray mutableCopy];
    newArray[index]=range;
    self.timeRangeArray=newArray;
}

- (NSArray *)timeRangeToModelArray:(NSArray *)array
{
    NSMutableArray *newArray=[[NSMutableArray alloc]initWithCapacity:array.count];
    for (int i=0; i<array.count; ++i) {
        REMTimeRange *range=[[REMTimeRange alloc]initWithDictionary:array[i]];
        [newArray addObject:range];
    }
    
    return newArray;
}


- (id)copyWithZone:(NSZone *)zone
{
    REMWidgetSearchModelBase *base=[[[self class]allocWithZone:zone]init];
    base.timeRangeArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                         [NSKeyedArchiver archivedDataWithRootObject:self.timeRangeArray]];
    
    return base;
}


@end
