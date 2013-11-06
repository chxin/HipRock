//
//  REMWidgetRankingSearchModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetRankingSearchModel.h"

@implementation REMWidgetRankingSearchModel

- (NSDictionary *)toSearchParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    dic[@"commodityIds"]=self.commodityIdArray;
    dic[@"hierarchyIds"]=self.hierarchyIdArray;
    dic[@"viewOption"]=@{@"IncludeNavigatorData":@(1),@"TimeRanges":[self timeRangeToDictionaryArray]};
    if(self.industryId!=nil || self.zoneId!=nil){
        dic[@"benchmarkOption"]=@{@"IndustryId":self.industryId,@"ZoneId":self.zoneId};
    }
    NSMutableDictionary *viewAssociation=[[NSMutableDictionary alloc]initWithCapacity:3];
    if(self.systemDimensionTemplateItemId!=nil){
        [viewAssociation setObject:self.systemDimensionTemplateItemId forKey:@"systemDimensionTemplateId"];
    }
    if(self.areaDimensionId!=nil){
        [viewAssociation setObject:self.areaDimensionId forKey:@"areaDimensionId"];
    }

    return dic;
}

- (void)setModelBySearchParam:(NSDictionary *)param
{
    NSArray *hierIds=param[@"hierarchyIds"];
    NSDictionary *viewOption=param[@"viewOption"];
    self.timeRangeArray=[self timeRangeToModelArray: viewOption[@"TimeRanges"]];
    self.hierarchyIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                           [NSKeyedArchiver archivedDataWithRootObject:hierIds]];
    
    NSDictionary *viewAssocation=param[@"viewAssociation"];
    
    if(viewAssocation!=nil&&[viewAssocation isEqual:[NSNull null]]==NO){
        NSNumber *sysId=viewAssocation[@"SystemDimensionTemplateItemId"];
        NSNumber *areaId=viewAssocation[@"AreaDimensionId"];
        if(sysId!=nil && [sysId isEqual:[NSNull null]]==NO){
            self.systemDimensionTemplateItemId=[sysId copy];
        }
        if(areaId!=nil && [areaId isEqual:[NSNull null]]==NO){
            self.areaDimensionId=[areaId copy];
        }
    }

    
}

- (id)copyWithZone:(NSZone *)zone
{
    REMWidgetRankingSearchModel *model=[super copyWithZone:zone];
    model.hierarchyIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:self.hierarchyIdArray]];
    
    model.systemDimensionTemplateItemId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.areaDimensionId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    return model;
}

@end
