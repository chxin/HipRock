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

@property (nonatomic) REMEnergyStep step;
@property (nonatomic,strong) NSNumber *zoneId;
@property (nonatomic,strong) NSNumber *industryId;

@property (nonatomic,strong) NSString *relativeDateComponent;
@property (nonatomic) REMRelativeTimeRangeType relativeDateType;

@end
