/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyViewData.h
 * Created      : TanTan on 7/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"

#import "REMTargetEnergyData.h"
#import "REMEnergyCalendarData.h"
#import "REMEnergyError.h"
#import "REMEnergyLabellingLevelData.h"
#import "REMCommonHeaders.h"

@interface REMEnergyViewData : REMJSONObject


@property (nonatomic,strong) NSArray *targetEnergyData;
@property (nonatomic,strong) NSArray *calendarData;
@property (nonatomic,strong) NSArray *error;
@property (nonatomic,strong) REMTimeRange *visibleTimeRange;
@property (nonatomic,strong) REMTimeRange *globalTimeRange;
@property (nonatomic,strong) NSArray *labellingLevelArray;


@end
