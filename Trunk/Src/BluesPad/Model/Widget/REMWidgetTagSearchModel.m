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
    dic[@"viewOption"]=@{@"Step":step,@"IncludeNavigatorData":@(1),@"TimeRanges":self.timeRangeArray};
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
    NSArray *timeRanges=viewOption[@"TimeRanges"];
    self.tagIdArray= [NSArray arrayWithArray:tagIds];
    self.step=[self stepTypeByNumber:step];
    self.timeRangeArray=[NSArray arrayWithArray:timeRanges];
    
    
}

@end
