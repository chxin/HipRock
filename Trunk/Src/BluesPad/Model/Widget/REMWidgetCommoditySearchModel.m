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
    dic[@"viewOption"]=@{@"Step":step,@"IncludeNavigatorData":@(1),@"TimeRanges":self.timeRangeArray};
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
    if(self.hierarchyId!=nil){
        [viewAssociation setObject:self.hierarchyId forKey:@"hierarchy"];
    }
    return dic;
}

- (void)setModelBySearchParam:(NSDictionary *)param
{
    NSArray *commodityIds=param[@"commodityIds"];
    NSDictionary *viewOption=param[@"viewOption"];
    NSNumber *step=viewOption[@"Step"];
    self.timeRangeArray=[self timeRangeToModelArray: viewOption[@"TimeRanges"]];
    self.commodityIdArray= [NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:commodityIds]];
    self.step=[self stepTypeByNumber:step];
    
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
}

- (id)copyWithZone:(NSZone *)zone{
    REMWidgetCommoditySearchModel *model=[super copyWithZone:zone];
    model.commodityIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                      [NSKeyedArchiver archivedDataWithRootObject:self.commodityIdArray]];
    model.systemDimensionTemplateItemId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.areaDimensionId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.hierarchyId=[self.hierarchyId copyWithZone:zone];
    
    return model;
}


@end
