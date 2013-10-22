//
//  REMWidgetContentSyntax.m
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMWidgetContentSyntax.h"

@implementation REMWidgetContentSyntax

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *p = dictionary[@"params"];
    self.params= p[@"submitParams"];
    self.relativeDate=p[@"relativeDate"];
    self.calendar=p[@"calendar"];
    self.config = p[@"config"];
    self.storeType=self.config[@"storeType"];
    self.type=self.config[@"type"];
    
    
    if([self.calendar isEqual:[NSNull null]]==YES){
        self.calendarType=REMCalendarTypeNone;
    }
    else if([self.calendar isEqualToString:@"hc"]==YES){
        self.calendarType=REMCalendarTypeHCSeason;
    }
    else if([self.calendar isEqualToString:@"work"]==YES){
        self.calendarType=REMCalenderTypeWorkDay;
    }
    else{
        self.calendarType=REMCalendarTypeNone;
    }
    
    if([self.relativeDate isEqual:[NSNull null]]==YES){
        self.relativeDateType = REMRelativeTimeRangeTypeNone;
    }
    else if([self.relativeDate isEqualToString:@"Last7Day"]==YES){
        self.relativeDateType = REMRelativeTimeRangeTypeLast7Days;
        self.relativeDateComponent=@"之前七天";
    }
    else if([self.relativeDate isEqualToString:@"Today"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeToday;
        self.relativeDateComponent=@"今天";
    }
    else if([self.relativeDate isEqualToString:@"Yesterday"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeYesterday;
        self.relativeDateComponent=@"昨天";
    }
    else if([self.relativeDate isEqualToString:@"ThisMonth"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeThisMonth;
        self.relativeDateComponent=@"本月";
    }
    else if([self.relativeDate isEqualToString:@"LastMonth"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeLastMonth;
        self.relativeDateComponent=@"上月";
    }
    else if([self.relativeDate isEqualToString:@"ThisWeek"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeThisWeek;
        self.relativeDateComponent=@"本周";
    }
    else if([self.relativeDate isEqualToString:@"LastWeek"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeLastWeek;
        self.relativeDateComponent=@"上周";
    }
    else if([self.relativeDate isEqualToString:@"ThisYear"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeThisYear;
        self.relativeDateComponent=@"今年";
    }
    else if([self.relativeDate isEqualToString:@"LastYear"]==YES){
        self.relativeDateType=REMRelativeTimeRangeTypeLastYear;
        self.relativeDateComponent=@"去年";
    }
    else{
        self.relativeDateType=REMRelativeTimeRangeTypeNone;
    }
    
    
    
    NSDictionary *viewOption=self.params[@"viewOption"];
    
    self.step = viewOption[@"Step"];
    
    if ([self.step isEqualToNumber:@(1)]==YES) {
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
    
    
    NSArray *origTimeRanges = viewOption[@"TimeRanges"];
    NSMutableArray* newTimeRanges = [[NSMutableArray alloc]initWithCapacity:origTimeRanges.count];
    for(NSDictionary *dic in origTimeRanges)
    {
        [newTimeRanges addObject: [[REMTimeRange alloc]initWithDictionary:dic]];
    }
    
    self.timeRanges = newTimeRanges;
    
    
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
    else if([self.storeType isEqualToString:@"energy.CarbonUage"]==YES){
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

}

@end
