/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendBase.h
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMEnergyViewData.h"
#import "REMWidgetSearchModelBase.h"
#import "REMChartLegendItem.h"
#import "DAbstractChartWrapper.h"
#import "REMManagedWidgetModel.h"

@interface REMChartLegendBase : UIScrollView

@property (nonatomic,weak) DAbstractChartWrapper *chartWrapper;
@property (nonatomic,weak) REMEnergyViewData *data;
@property (nonatomic,weak) REMManagedWidgetModel *widget;
@property (nonatomic,weak) REMWidgetSearchModelBase *parameters;

@property (nonatomic,weak) NSObject<REMChartLegendItemDelegate> *itemDelegate;

@property (nonatomic,strong) NSArray *itemModels;

+(REMChartLegendBase *)legendViewChartWrapper:(DAbstractChartWrapper *)chartWrapper data:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget parameters:(REMWidgetSearchModelBase *)parameters delegate:(id<REMChartLegendItemDelegate>)delegate;

-(REMChartLegendBase *)initWithChartWrapper:(DAbstractChartWrapper *)chartWrapper data:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget parameters:(REMWidgetSearchModelBase *)parameters delegate:(id<REMChartLegendItemDelegate>)delegate;

-(NSArray *)convertItemModels;

-(void)refreshItemStatus;

@end


