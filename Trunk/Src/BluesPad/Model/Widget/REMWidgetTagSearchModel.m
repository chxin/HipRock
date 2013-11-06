//
//  REMWidgetTagSearchModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetTagSearchModel.h"

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

- (id)copyWithZone:(NSZone *)zone{
    REMWidgetTagSearchModel *model=[super copyWithZone:zone];
    model.tagIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                         [NSKeyedArchiver archivedDataWithRootObject:self.tagIdArray]];
    
    return model;
}



@end
