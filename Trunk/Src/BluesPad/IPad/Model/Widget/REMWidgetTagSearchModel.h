/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetTagSearchModel.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetSearchModelBase.h"
#import "REMWidgetStepEnergyModel.h"

@interface REMWidgetTagSearchModel : REMWidgetStepEnergyModel

@property (nonatomic,strong) NSArray *tagIdArray;

@end
