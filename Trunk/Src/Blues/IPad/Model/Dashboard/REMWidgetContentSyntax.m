/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetContentSyntax.m
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetContentSyntax.h"

@implementation REMWidgetContentSyntax

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *p = dictionary[@"params"];
    self.params= p[@"submitParams"];
    //self.relativeDate=p[@"relativeDate"];
    self.calendar=p[@"calendar"];
    self.config = p[@"config"];
    self.storeType=self.config[@"storeType"];
    
    NSDictionary* diagramConfig = p[@"diagramConfig"];
    if (diagramConfig != NULL && diagramConfig != Nil && diagramConfig != nil && ![diagramConfig isEqual:[NSNull null]]) {
        NSNumber* order = diagramConfig[@"orderCode"];
        if (order == nil || order == NULL || [order isEqual:[NSNull null]]) {
            self.rankingSortOrder = NSOrderedSame;
        } else if (order.intValue == 2) {
            self.rankingSortOrder = NSOrderedAscending;
        } else {
            self.rankingSortOrder = NSOrderedDescending;
        }
        NSNumber* rangeCode = diagramConfig[@"rangeCode"];
        if (rangeCode == nil || rangeCode == NULL || [rangeCode isEqual:[NSNull null]]) {
            self.rankingRangeCode = REMRankingRangeAll;
        } else {
            self.rankingRangeCode = rangeCode.intValue;
        }
        self.rankingMinPosition = diagramConfig[@"minPosition"];
    }
    if([self.calendar isEqual:[NSNull null]]==YES){
        self.calendarType=REMCalendarTypeNone;
    }
    else if([self.calendar isEqualToString:@"hc"]==YES){
        self.calendarType=REMCalendarTypeHCSeason;
    }
    else if([self.calendar isEqualToString:@"work"]==YES){
        self.calendarType=REMCalenderTypeHoliday;
    }
    else{
        self.calendarType=REMCalendarTypeNone;
    }
    
//    NSString *relativeDate=p[@"relativeDate"];
//    if(!REMIsNilOrNull(relativeDate)){
//        self.relativeDateType = [REMTimeHelper relativeTimeTypeByName:relativeDate];
//    }
    
    NSDictionary *viewOption=self.params[@"viewOption"];
    
    self.step = viewOption[@"Step"];
    
    if([self.step isEqualToNumber:@(0)]==YES){
        self.stepType = REMEnergyStepRaw;
    }
    else if ([self.step isEqualToNumber:@(1)]==YES) {
        self.stepType = REMEnergyStepHour;
    }
    else if([self.step isEqualToNumber:@(2)]==YES){
        self.stepType = REMEnergyStepDay;
    }
    else if([self.step isEqualToNumber:@(3)]==YES){
        self.stepType = REMEnergyStepMonth;
    }
    else if([self.step isEqualToNumber:@(4)]==YES){
        self.stepType = REMEnergyStepYear;
    }
    else if([self.step isEqualToNumber:@(5)]==YES){
        self.stepType = REMEnergyStepWeek;
    }
    _contentSyntaxWidgetType = REMWidgetContentSyntaxWidgetTypeNone;
    NSString* typeCode = self.config[@"type"];
    if ([typeCode isEqualToString:@"line"]) {
        _contentSyntaxWidgetType = REMWidgetContentSyntaxWidgetTypeLine;
    } else if ([typeCode isEqualToString:@"column"]) {
        _contentSyntaxWidgetType = REMWidgetContentSyntaxWidgetTypeColumn;
    } else if ([typeCode isEqualToString:@"stack"] || [typeCode isEqualToString:@"stacking"]) {
        _contentSyntaxWidgetType = REMWidgetContentSyntaxWidgetTypeStack;
    } else if ([typeCode isEqualToString:@"pie"]) {
        _contentSyntaxWidgetType = REMWidgetContentSyntaxWidgetTypePie;
    } else if ([typeCode isEqualToString:@"grid"]) {
        _contentSyntaxWidgetType = REMWidgetContentSyntaxWidgetTypeGrid;
    }
    
    NSArray *origTimeRanges = viewOption[@"TimeRanges"];
    NSMutableArray* newTimeRanges = [[NSMutableArray alloc]initWithCapacity:origTimeRanges.count];
    
    if(origTimeRanges.count > 0){
        REMTimeRange *baseTime = [[REMTimeRange alloc] initWithDictionary:origTimeRanges[0]];

        for(NSDictionary *dic in origTimeRanges)
        {
            [newTimeRanges addObject: [[REMTimeRange alloc] initWithDictionary:dic andBaseTime:baseTime]];
        }
    }
    
    self.timeRanges = newTimeRanges;
    self.relativeDateType = REMRelativeTimeRangeTypeNone;
    if(self.timeRanges.count > 0){
        self.relativeDateType = ((REMTimeRange *)self.timeRanges[0]).relativeTimeType;
    }
    self.relativeDateComponent=[REMTimeHelper relativeDateComponentFromType:self.relativeDateType];
    
    
    if([self.storeType isEqualToString:@"energy.Energy"] == YES){
        if(self.timeRanges.count>1){
            self.dataStoreType =  REMDSEnergyMultiTimeTrend;
        }
        else{
            self.dataStoreType=REMDSEnergyTagsTrend;
        }
    }
    else if([self.storeType isEqualToString:@"energy.UnitEnergyUsage"]==YES){
        self.dataStoreType = REMDSEnergyTagsTrendUnit;
    }
    else if([self.storeType isEqualToString:@"energy.UnitCarbonUsage"]==YES){
        self.dataStoreType = REMDSEnergyCarbonUnit;
    }
    else if([self.storeType isEqualToString:@"energy.UnitCostUsage"]==YES){
        self.dataStoreType = REMDSEnergyCostUnit;
    }
    else if([self.storeType isEqualToString:@"energy.Distribution"]==YES){
        self.dataStoreType = REMDSEnergyTagsDistribute;
    }
    else if([self.storeType isEqualToString:@"energy.MultiIntervalDistribution"]==YES){
        self.dataStoreType = REMDSEnergyMultiTimeDistribute;
    }
    else if([self.storeType isEqualToString:@"energy.CarbonUsage"]==YES){
        self.dataStoreType = REMDSEnergyCarbon;
    }
    else if([self.storeType isEqualToString:@"energy.CarbonDistribution"]==YES){
        self.dataStoreType = REMDSEnergyCarbonDistribute;
    }
    else if([self.storeType isEqualToString:@"energy.CostUsage"]==YES){
        self.dataStoreType = REMDSEnergyCost;
    }
    else if([self.storeType isEqualToString:@"energy.CostUsageDistribution"]==YES){
        self.dataStoreType = REMDSEnergyCostDistribute;
    }
    else if([self.storeType isEqualToString:@"energy.CostElectricityUsage"]==YES){
        self.dataStoreType = REMDSEnergyCostElectricity;
    }
    else if([self.storeType isEqualToString:@"energy.RatioUsage"]==YES){
        self.dataStoreType = REMDSEnergyRatio;
    }
    else if([self.storeType isEqualToString:@"energy.Labeling"]==YES){
        self.dataStoreType = REMDSEnergyLabeling;
    }
    else if([self.storeType isEqualToString:@"energy.RankUsage"]==YES){
        NSString *api=[self.params objectForKey:@"api"];
        if([api isEqualToString:@"RankingEnergyUsageData"]==YES){
            self.dataStoreType = REMDSEnergyRankingEnergy;
        }
        else if([api isEqualToString:@"RankingCarbonData"]==YES){
            self.dataStoreType = REMDSEnergyRankingCarbon;
        }
        else{
            self.dataStoreType = REMDSEnergyRankingCost;
        }
    }
    
    NSArray *seriesStates = p[@"seriesStates"];
    if(!REMIsNilOrNull(seriesStates)){
        self.seriesStates = seriesStates;
    }

}

-(BOOL)isHourSupported {
    return self.dataStoreType != REMDSEnergyRatio;
}

@end
