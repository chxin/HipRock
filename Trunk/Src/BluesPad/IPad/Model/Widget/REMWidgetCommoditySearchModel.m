/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCommoditySearchModel.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetCommoditySearchModel.h"



@implementation REMWidgetCommoditySearchModel


- (NSDictionary *)toSearchParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    dic[@"commodityIds"]=self.commodityIdArray;
    NSNumber *step=[self stepNumberByStep:self.step];
    NSArray *newTimeRangeArray=[self timeRangeToDictionaryArray];
    if(self.industryId!=nil || self.zoneId!=nil){
        dic[@"benchmarkOption"]=@{@"IndustryId":self.industryId,@"ZoneId":self.zoneId};
    }
    NSMutableDictionary *viewAssociation=[[NSMutableDictionary alloc]initWithCapacity:3];
    if(self.systemDimensionTemplateItemId!=nil){
        [viewAssociation setObject:self.systemDimensionTemplateItemId forKey:@"SystemDimensionTemplateItemId"];
    }
    if(self.areaDimensionId!=nil){
        [viewAssociation setObject:self.areaDimensionId forKey:@"AreaDimensionId"];
    }
    if(self.hierarchyId!=nil){
        [viewAssociation setObject:self.hierarchyId forKey:@"HierarchyId"];
    }
    dic[@"viewAssociation"]=viewAssociation;
    if(self.carbonUnit!=REMCarbonUnitNone){
        dic[@"destination"]=@(self.carbonUnit);
    }
    if(self.hierarchyId!=nil){
        dic[@"hierarchyId"]=self.hierarchyId;
    }
    NSMutableDictionary *dataOption=[[NSMutableDictionary alloc]initWithCapacity:4];
    if(self.ratioType!=REMRatioTypeNone ){
        dataOption[@"RatioType"]=@(self.ratioType);
    }
    if(self.unitType!=REMUnitTypeNone){
        dataOption[@"UnitType"]=@(self.unitType);
    }
    if(self.rankingType!=REMRankingTypeNone)
    {
        dataOption[@"RankType"]=@(self.rankingType);
    }
    if(self.labellingType!=REMLabellingTypeNone){
        dataOption[@"LabelingType"]=@(self.labellingType);
    }
    dic[@"viewOption"]=@{@"Step":step,@"IncludeNavigatorData":@(1),@"TimeRanges":newTimeRangeArray,@"DataOption":dataOption};

    return dic;
}

- (void)setModelBySearchParam:(NSDictionary *)param
{
    NSArray *commodityIds=param[@"commodityIds"];
    NSDictionary *viewOption=param[@"viewOption"];
    NSNumber *step=viewOption[@"Step"];
    self.timeRangeArray=[self timeRangeToModelArray: viewOption[@"TimeRanges"]];
    self.searchTimeRangeArray=[self.timeRangeArray copy];
    self.commodityIdArray= [NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:commodityIds]];
    self.step=[self stepTypeByNumber:step];
    

    
    NSNumber *destination=param[@"destination"];
    if(destination!=nil){
        self.carbonUnit=(REMCarbonUnit)[destination intValue];
    }
    
    NSDictionary *viewAssocation=param[@"viewAssociation"];
    
    if(viewAssocation!=nil&&[viewAssocation isEqual:[NSNull null]]==NO){
        NSNumber *sysId=viewAssocation[@"SystemDimensionTemplateItemId"];
        NSNumber *areaId=viewAssocation[@"AreaDimensionId"];
        NSNumber *hierId=viewAssocation[@"HierarchyId"];
        if(sysId!=nil && [sysId isEqual:[NSNull null]]==NO){
            self.systemDimensionTemplateItemId=[sysId copy];
        }
        if(areaId!=nil && [areaId isEqual:[NSNull null]]==NO){
            self.areaDimensionId=[areaId copy];
        }
        if(hierId!=nil && [hierId isEqual:[NSNull null]]==NO){
            self.hierarchyId=[hierId copy];
        }
    }
    NSNumber *hierId=param[@"hierarchyId"];
    if(hierId!=nil){
        self.hierarchyId=hierId;
    }
    
    
    NSDictionary *bench=param[@"benchmarkOption"];
    if(bench!=nil && [bench isEqual:[NSNull null]]==NO){
        self.industryId=bench[@"IndustryId"];
        self.zoneId=bench[@"ZoneId"];
        self.benchmarkText=bench[@"benchmarkText"];
    }
    
    NSDictionary *dataOption=viewOption[@"DataOption"];
    
    if(dataOption!=nil){
        NSNumber *ratioType=dataOption[@"RatioType"];
        NSNumber *unitType=dataOption[@"UnitType"];
        NSNumber *rankingType=dataOption[@"RankingType"];
        NSNumber *labellingType=dataOption[@"LabelingType"];
        
        self.ratioType=(REMRatioType)[ratioType intValue];
        self.unitType=(REMUnitType)[unitType intValue];
        self.rankingType=(REMRankingType)[rankingType intValue];
        self.labellingType=(REMLabellingType)[labellingType intValue];
    }
    else{
        self.ratioType=REMRatioTypeNone;
        self.unitType=REMUnitTypeNone;
        self.rankingType=REMRankingTypeNone;
        self.labellingType=REMLabellingTypeNone;
    }
}



- (id)copyWithZone:(NSZone *)zone{
    REMWidgetCommoditySearchModel *model=[super copyWithZone:zone];
    model.commodityIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                      [NSKeyedArchiver archivedDataWithRootObject:self.commodityIdArray]];
    model.systemDimensionTemplateItemId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.areaDimensionId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.hierarchyId=[self.hierarchyId copyWithZone:zone];
    model.carbonUnit=self.carbonUnit;
    
    return model;
}


@end
