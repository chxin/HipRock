//
//  REMWidgetCommoditySearchModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetCommoditySearchModel.h"

@implementation REMWidgetCommoditySearchModel


- (NSDictionary *)toSearchParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    dic[@"commodityIds"]=self.commodityIdArray;
    NSNumber *step=[self stepNumberByStep:self.step];
    dic[@"viewOption"]=@{@"Step":step,@"IncludeNavigatorData":@(1),@"TimeRanges":self.timeRangeArray};
    if(self.industryId!=nil || self.zoneId!=nil){
        dic[@"benchmarkOption"]=@{@"IndustryId":self.industryId,@"ZoneId":self.zoneId};
    }
    return dic;
}

- (void)setModelBySearchParam:(NSDictionary *)param
{
    NSArray *tagIds=param[@"commodityIds"];
    NSDictionary *viewOption=param[@"viewOption"];
    NSNumber *step=viewOption[@"Step"];
    NSArray *timeRanges=viewOption[@"TimeRanges"];
    self.commodityIdArray= [NSArray arrayWithArray:tagIds];
    self.step=[self stepTypeByNumber:step];
    self.timeRangeArray=[NSArray arrayWithArray:timeRanges];
    
    
}

@end
