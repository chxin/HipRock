//
//  REMChartStrategyFactor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import "REMChartStrategyFactor.h"

@interface REMChartStrategyFactor()
@property (nonatomic, strong) NSDictionary* defaultStrategyConfig;
@property (nonatomic, strong) NSDictionary* storeConfigs;
@end

@implementation REMChartStrategyFactor

static REMChartStrategyFactor *singleTon = nil;

-(REMChartStrategyFactor*)init {
    self = [super init];
    if (self) {
        self.defaultStrategyConfig = @{
                                       @"seriesAvalibleTypeBuildGen": @"REMSeriesAvalibleTypeDefaultGen",
                                       @"seriesDefaultVisibleGen": @"REMSeriesAllVisableGen",
                                       @"seriesGroupingGen": @"REMSeriesGroupingCommodityGen"
                                       };
        self.storeConfigs =
        @{
          @"energy.CarbonDistribution": @{@"seriesGroupingGen": @"REMSeriesGroupingUomGen"},
          @"energy.CarbonUsage": @{@"seriesGroupingGen": @"REMSeriesGroupingUomGen"},
          
          @"energy.CostElectricityUsage": @{ @"seriesAvalibleTypeBuildGen": @"REMSeriesAvalibleTypeStableTypeGen", @"seriesGroupingGen": @"REMSeriesGroupingUomGen" },
          @"energy.CostUsage": @{@"seriesGroupingGen": @"REMSeriesGroupingUomGen"},
          @"energy.CostUsageDistribution": @{@"seriesGroupingGen": @"REMSeriesGroupingUomGen"},
          @"energy.CostElectricityDistribution": @{@"seriesGroupingGen": @"REMSeriesGroupingUomGen"},
          
          
          @"energy.Distribution": @{},
          @"energy.Energy": @{},
          @"energy.MultiIntervalDistribution": @{},
          
          
          @"energy.Labeling": @{},
          
          
          @"energy.RankUsage": @{ @"seriesAvalibleTypeBuildGen": @"REMSeriesAvalibleTypeColumnOnlyGen" },
          
          
          @"energy.RatioUsage": @{@"seriesDefaultVisibleGen": @"REMSeriesTargetBaselineVisableGen"},
          
          
          
          @"energy.UnitCarbonUsage": @{ @"seriesAvalibleTypeBuildGen": @"REMSeriesAvalibleTypeLineColumnGen", @"seriesDefaultVisibleGen": @"REMSeriesTargetBaselineVisableGen" },
          @"energy.UnitCostUsage": @{ @"seriesAvalibleTypeBuildGen": @"REMSeriesAvalibleTypeLineColumnGen", @"seriesDefaultVisibleGen": @"REMSeriesTargetBaselineVisableGen", @"seriesGroupingGen": @"REMSeriesGroupingUomGen" },
          @"energy.UnitEnergyUsage": @{ @"seriesAvalibleTypeBuildGen": @"REMSeriesAvalibleTypeLineColumnGen", @"seriesDefaultVisibleGen": @"REMSeriesTargetBaselineVisableGen" }
          
        };
    }
    return self;
}

+(REMChartStrategy*)getStrategyByStoreType:(NSString*)storeType {
    REMChartStrategyFactor* instance = [REMChartStrategyFactor getInstance];
    NSDictionary* defaultStrategyConfig = instance.defaultStrategyConfig;
    NSMutableDictionary* storeConfig = REMIsNilOrNull(storeType) ? nil : instance.storeConfigs[storeType];
    REMChartStrategy* strategy = [[REMChartStrategy alloc]init];
    for (NSString* key in defaultStrategyConfig.allKeys) {
        NSString* genName = nil;
        if (storeConfig == nil || ![storeConfig.allKeys containsObject:key]) {
            genName = defaultStrategyConfig[key];
        } else {
            genName = storeConfig[key];
        }
        id gen = [[[[NSBundle mainBundle] classNamed:genName] alloc] init];
        
        if ([key isEqualToString:@"seriesAvalibleTypeBuildGen"]) {
            strategy.avalibleTypeGen = gen;
        } else if ([key isEqualToString:@"seriesDefaultVisibleGen"]) {
            strategy.defaultVisibleGen = gen;
        } else if ([key isEqualToString:@"seriesGroupingGen"]) {
            strategy.groupingGen = gen;
        }
    }
    return strategy;
}

+(REMChartStrategyFactor *)getInstance {
    if(singleTon == nil){
        @synchronized(self){
            singleTon = [[REMChartStrategyFactor alloc] init];
        }
    }
    
    return singleTon;
}
@end
