//
//  REMEnergyTargetObj.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"
@class REMTimeRange;

typedef enum _REMEnergyTargetType : NSUInteger
{
    REMEnergyTargetTag = 1,
    REMEnergyTargetKpi = 2,
    REMEnergyTargetTarget = 3,
    REMEnergyTargetBaseline = 4,
    REMEnergyTargetHierarchy = 5,
    REMEnergyTargetPlain = 6,
    REMEnergyTargetPeak = 7,
    REMEnergyTargetValley = 8,
    REMEnergyTargetCarbon = 9,
    REMEnergyTargetCost = 10,
    
    REMEnergyTargetCalcValue=11,
    REMEnergyTargetOrigValue=12,
    REMEnergyTargetTargetValue=13,
    REMEnergyTargetBaseValue = 14,
    
    REMEnergyTargetBenchmarkValue = 15,
} REMEnergyTargetType;

@interface REMEnergyTargetModel : REMJSONObject

@property (nonatomic,strong) NSNumber *targetId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic) REMEnergyTargetType type;
@property (nonatomic,strong) REMTimeRange *visiableTimeRange;
@property (nonatomic,strong) REMTimeRange *globalTimeRange;
@property (nonatomic) long long commodityId;
@property (nonatomic) long long uomId;
@property (nonatomic,strong) NSString * commodityName;
@property (nonatomic,strong) NSString * uomName;

@end
