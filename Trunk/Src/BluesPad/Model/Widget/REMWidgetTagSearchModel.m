/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetTagSearchModel.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetTagSearchModel.h"

@interface REMWidgetTagSearchModel(){
    REMRelativeTimeRangeType _relativeType;
}

@end

@implementation REMWidgetTagSearchModel


- (NSDictionary *)toSearchParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    dic[@"tagIds"]=self.tagIdArray;
    NSNumber *step=[self stepNumberByStep:self.step];
    
    NSArray *newTimeRangeArray=[self timeRangeToDictionaryArray];
    
    dic[@"viewOption"]=@{@"Step":step,@"IncludeNavigatorData":@(1),@"TimeRanges":newTimeRangeArray};
    if(self.industryId!=nil || self.zoneId!=nil){
        dic[@"benchmarkOption"]=@{@"IndustryId":self.industryId,@"ZoneId":self.zoneId};
    }
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
}


- (void)setRelativeDateType:(REMRelativeTimeRangeType)relativeDateType{
    REMTimeRange *range= [REMTimeHelper relativeDateFromType:relativeDateType];
    [self setTimeRangeItem:range AtIndex:0];
    _relativeType=relativeDateType;
}

- (REMRelativeTimeRangeType)relativeDateType{
    return _relativeType;
}

- (id)copyWithZone:(NSZone *)zone{
    REMWidgetTagSearchModel *model=[super copyWithZone:zone];
    model.tagIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                         [NSKeyedArchiver archivedDataWithRootObject:self.tagIdArray]];
    
    return model;
}



@end
