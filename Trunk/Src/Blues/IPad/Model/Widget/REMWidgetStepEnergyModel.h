//
//  REMWidgetStepEnergyModel.h
//  Blues
//
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetSearchModelBase.h"

@interface REMWidgetStepEnergyModel : REMWidgetSearchModelBase


- (NSNumber *)stepNumberByStep:(REMEnergyStep)stepType;

- (REMEnergyStep)stepTypeByNumber:(NSNumber *)stepNumber;

- (void)resetStepByTimeRange:(REMTimeRange *)range;

@property (nonatomic) REMEnergyStep step;
@property (nonatomic,strong) NSNumber *zoneId;
@property (nonatomic,strong) NSNumber *industryId;
@property (nonatomic,strong) NSNumber *customizedId;
@property (nonatomic,strong) NSString *benchmarkText;



@property (nonatomic) REMRatioType ratioType;
@property (nonatomic) REMUnitType unitType;
@property (nonatomic) REMRankingType rankingType;
@property (nonatomic) REMLabellingType labellingType;

@end
