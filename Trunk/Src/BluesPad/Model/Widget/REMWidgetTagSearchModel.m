/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetTagSearchModel.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetTagSearchModel.h"



@implementation REMWidgetTagSearchModel


- (NSDictionary *)toSearchParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    dic[@"tagIds"]=self.tagIdArray;
    NSNumber *step=[self stepNumberByStep:self.step];
    
    NSArray *newTimeRangeArray=[self timeRangeToDictionaryArray];
    
    
    if(self.industryId!=nil || self.zoneId!=nil){
        dic[@"benchmarkOption"]=@{@"IndustryId":self.industryId,@"ZoneId":self.zoneId};
    }
    NSMutableDictionary *dataOption=[[NSMutableDictionary alloc]initWithCapacity:4];
    if(self.ratioType!=REMRatioTypeNone ){
        dataOption[@"RatioType"]=@(self.ratioType);
        dic[@"ratioType"]=@(self.ratioType);
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
    NSArray *tagIds=param[@"tagIds"];
    NSDictionary *viewOption=param[@"viewOption"];
    NSNumber *step=viewOption[@"Step"];
    
    self.timeRangeArray= [self timeRangeToModelArray: viewOption[@"TimeRanges"]];
    self.tagIdArray= [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:tagIds]];
    self.step=[self stepTypeByNumber:step];
    
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
    NSNumber *ratioType=param[@"ratioType"];
    if(ratioType!=nil){
        self.ratioType=(REMRatioType)[ratioType intValue];
    }
    
    
}




- (id)copyWithZone:(NSZone *)zone{
    REMWidgetTagSearchModel *model=[super copyWithZone:zone];
    model.tagIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                         [NSKeyedArchiver archivedDataWithRootObject:self.tagIdArray]];
    
    return model;
}



@end
