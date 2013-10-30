//
//  REMEnergyViewData.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
