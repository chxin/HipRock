/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetRankingSearchModel.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetRankingSearchModel.h"



@implementation REMWidgetRankingSearchModel

- (NSDictionary *)toSearchParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    dic[@"commodityIds"]=self.commodityIdArray;
    dic[@"hierarchyIds"]=self.hierarchyIdArray;
    dic[@"viewOption"]=@{@"IncludeNavigatorData":@(1),@"TimeRanges":[self timeRangeToDictionaryArray]};
    if(self.destination!=nil){
        dic[@"destination"]=self.destination;
    }
    if(self.industryId!=nil || self.zoneId!=nil){
        dic[@"benchmarkOption"]=@{@"IndustryId":self.industryId,@"ZoneId":self.zoneId};
    }
    dic[@"rankType"]=self.rankType;
    NSMutableDictionary *viewAssociation=[[NSMutableDictionary alloc]initWithCapacity:3];
    if(self.systemDimensionTemplateItemId!=nil){
        [viewAssociation setObject:self.systemDimensionTemplateItemId forKey:@"systemDimensionTemplateId"];
    }
    if(self.areaDimensionId!=nil){
        [viewAssociation setObject:self.areaDimensionId forKey:@"areaDimensionId"];
    }

    return dic;
}

- (NSArray *)timeRangeToDictionaryArray{
    //[self fixTimeRange];
    return [super timeRangeToDictionaryArray];
}

- (void)setModelBySearchParam:(NSDictionary *)param
{
    NSArray *hierIds=param[@"hierarchyIds"];
    NSArray *commodityIds=param[@"commodityIds"];
    
    NSDictionary *viewOption=param[@"viewOption"];
    self.timeRangeArray=[self timeRangeToModelArray: viewOption[@"TimeRanges"]];
    self.searchTimeRangeArray=[self.timeRangeArray copy];
    self.hierarchyIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                           [NSKeyedArchiver archivedDataWithRootObject:hierIds]];
    self.commodityIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                           [NSKeyedArchiver archivedDataWithRootObject:commodityIds]];
    self.rankType=param[@"rankType"];
    NSDictionary *viewAssocation=param[@"viewAssociation"];
    
    self.destination=param[@"destination"];
    
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

- (void)fixTimeRange{
    REMTimeRange *timeRange=self.timeRangeArray[0];
    NSCalendar *calendar=[REMTimeHelper currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *components=[calendar components:unitFlags fromDate:timeRange.startTime];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    timeRange.startTime=[calendar dateFromComponents:components];
    components=[calendar components:unitFlags fromDate:timeRange.endTime];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    timeRange.endTime=[calendar dateFromComponents:components];
}
/*
- (void)setRelativeDateType:(REMRelativeTimeRangeType)relativeDateType{
    [super setRelativeDateType:relativeDateType];
    if(relativeDateType!=REMRelativeTimeRangeTypeNone){
        [self fixTimeRange];
    }
}
*/
- (id)copyWithZone:(NSZone *)zone
{
    REMWidgetRankingSearchModel *model=[super copyWithZone:zone];
    model.hierarchyIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:self.hierarchyIdArray]];
    model.commodityIdArray=[NSKeyedUnarchiver unarchiveObjectWithData:
                            [NSKeyedArchiver archivedDataWithRootObject:self.commodityIdArray]];
    model.rankType=[self.rankType copyWithZone:zone];
    model.systemDimensionTemplateItemId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.areaDimensionId=[self.systemDimensionTemplateItemId copyWithZone:zone];
    model.destination=[self.destination copyWithZone:zone];
    
    return model;
}

@end
