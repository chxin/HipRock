/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetSearchModelBase.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetTagSearchModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMWidgetRankingSearchModel.h"
#import "REMWidgetMultiTimespanSearchModel.h"
#import "REMWidgetLabellingSearchModel.h"


@interface REMWidgetSearchModelBase(){
    REMRelativeTimeRangeType _relativeType;
}

@end

@implementation REMWidgetSearchModelBase

+ (REMWidgetSearchModelBase *)searchModelByDataStoreType:(REMDataStoreType)dataStoreType withParam:(NSDictionary *)param
{
    REMWidgetSearchModelBase *model=nil;
    if(dataStoreType == REMDSEnergyTagsTrend ||
       dataStoreType == REMDSEnergyTagsTrendUnit ||
       dataStoreType == REMDSEnergyTagsDistribute ||
       dataStoreType == REMDSEnergyRatio){
        model = [[REMWidgetTagSearchModel alloc]init];
    }
    else if( dataStoreType ==REMDSEnergyMultiTimeTrend ||
            dataStoreType == REMDSEnergyMultiTimeDistribute){
        model =[[REMWidgetMultiTimespanSearchModel alloc]init];
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
        model = [[REMWidgetLabellingSearchModel alloc]init];
    }
    [model setModelBySearchParam:param];
    
    return model;
}

- (NSDictionary *)toSearchParam{
    return nil;
}

- (void)setModelBySearchParam:(NSDictionary *)param{}

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
    
    if(array.count > 0){
        REMTimeRange *baseTime = [[REMTimeRange alloc] initWithDictionary:array[0]];
        
        for (int i=0; i<array.count; ++i) {
            if(i == 0){
                [newArray addObject:baseTime];
                continue;
            }
                
            REMTimeRange *range=[[REMTimeRange alloc] initWithDictionary:array[i] andBaseTime:baseTime];
            [newArray addObject:range];
        }
    }
    
    return newArray;
}

- (void)setRelativeDateType:(REMRelativeTimeRangeType)relativeDateType{
    if(relativeDateType!=_relativeType){
        if(relativeDateType!=REMRelativeTimeRangeTypeNone){
            REMTimeRange *range= [REMTimeHelper relativeDateFromType:relativeDateType];
            [self setTimeRangeItem:range AtIndex:0];
        }
        _relativeType=relativeDateType;
        self.relativeDateComponent=[REMTimeHelper relativeDateComponentFromType:_relativeType];
    }
    if(self.relativeDateComponent==nil){
        self.relativeDateComponent=[REMTimeHelper relativeDateComponentFromType:relativeDateType];
    }
}

- (REMRelativeTimeRangeType)relativeDateType{
    return _relativeType;
}


- (id)copyWithZone:(NSZone *)zone
{
    REMWidgetSearchModelBase *base=[[[self class]allocWithZone:zone]init];
    base.timeRangeArray=[self.timeRangeArray copyWithZone:zone];
    base.searchTimeRangeArray=[self.timeRangeArray copyWithZone:zone];
    base.relativeDateComponent=[self.relativeDateComponent copyWithZone:zone];
    base.relativeDateType=self.relativeDateType;
    return base;
}


@end
