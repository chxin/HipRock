//
//  REMEnergyTargetObj.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"
@class REMTimeRange;

typedef enum _REMEnergyTargetType
{
    REMTargetTag,
    REMTargetCarbon,
    REMTargetCost,
} REMEnergyTargetType;

@interface REMEnergyTargetModel : REMJSONObject

@property (nonatomic) long long targetId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;
@property (nonatomic) REMEnergyTargetType type;
@property (nonatomic,strong) REMTimeRange *timeRange;
@property (nonatomic,strong) REMTimeRange *globalTimeRange;
@property (nonatomic) long long commodityId;
@property (nonatomic) long long uomId;
@property (nonatomic,strong) NSString * commodityName;
@property (nonatomic,strong) NSString * uomName;

@end
