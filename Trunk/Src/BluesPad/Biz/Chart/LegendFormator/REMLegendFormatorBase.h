/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLegendFormatorBase.h
 * Date Created : 张 锋 on 11/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"
#import "REMWidgetSearchModelBase.h"

@interface REMLegendFormatorBase : NSObject

@property (nonatomic,weak) REMEnergyViewData *data;
@property (nonatomic,weak) REMWidgetObject *widget;
@property (nonatomic,weak) REMWidgetSearchModelBase *parameters;

+ (REMLegendFormatorBase *)formatorWidthData:(REMEnergyViewData *)data widget:(REMWidgetObject *) widget andParameters:(REMWidgetSearchModelBase *)parameters;


- (NSArray *)format;
- (NSString *)format:(int)index;

@end

@interface REMCommonLegendFormator : REMLegendFormatorBase

@end

@interface REMTimeSliceLegendFormator : REMLegendFormatorBase

@end

@interface REMCarbonLegendFormator : REMLegendFormatorBase

@end

@interface REMCostLegendFormator : REMLegendFormatorBase

@end

@interface REMUnitLegendFormator : REMLegendFormatorBase

@end

@interface REMRatioLegendFormator : REMLegendFormatorBase

@end
