//
//  REMEnergyViewData.h
//  Blues
//
//  Created by TanTan on 7/11/13.
//
//

#import "REMJSONObject.h"

#import "REMTargetEnergyData.h"
#import "REMEnergyCalendarData.h"
#import "REMEnergyError.h"


@interface REMEnergyViewData : REMJSONObject


@property (nonatomic,strong) REMTargetEnergyData *targetGlobalData;
@property (nonatomic,strong) NSArray *targetEnergyData;
@property (nonatomic,strong) NSArray *calendarData;
@property (nonatomic,strong) NSArray *error;


@end
