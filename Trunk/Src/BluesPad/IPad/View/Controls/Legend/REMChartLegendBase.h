/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendBase.h
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMWidgetSearchModelBase.h"
#import "REMChartLegendItem.h"
#import "DAbstractChartWrapper.h"


@interface REMChartLegendBase : UIScrollView

@property (nonatomic,weak) DAbstractChartWrapper *chartWrapper;
@property (nonatomic,weak) REMEnergyViewData *data;
@property (nonatomic,weak) REMWidgetObject *widget;
@property (nonatomic,weak) REMWidgetSearchModelBase *parameters;

@property (nonatomic,weak) NSObject<REMChartLegendItemDelegate> *itemDelegate;

@property (nonatomic,strong) NSArray *itemModels;

+(REMChartLegendBase *)legendViewChartWrapper:(DAbstractChartWrapper *)chartWrapper data:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget parameters:(REMWidgetSearchModelBase *)parameters;

-(REMChartLegendBase *)initWithChartWrapper:(DAbstractChartWrapper *)chartWrapper data:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget parameters:(REMWidgetSearchModelBase *)parameters;

-(NSArray *)convertItemModels;

@end

