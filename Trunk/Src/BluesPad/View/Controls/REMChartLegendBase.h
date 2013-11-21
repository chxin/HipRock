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
#import "REMLegendFormatorBase.h"
#import "REMChartLegendItem.h"

@interface REMChartLegendBase : UIScrollView

@property (nonatomic,weak) REMEnergyViewData *data;
@property (nonatomic,weak) REMWidgetObject *widget;
@property (nonatomic,weak) REMWidgetSearchModelBase *parameters;

@property (nonatomic,weak) NSObject<REMChartLegendItemDelegate> *itemDelegate;

@property (nonatomic,strong) REMLegendFormatorBase *formator;
@property (nonatomic,strong) NSArray *itemModels;

+(REMChartLegendBase *)legendWithData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget parameters:(REMWidgetSearchModelBase *)parameters andHiddenIndexes:(NSArray *)hiddenIndexes;

-(REMChartLegendBase *)initWithData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget parameters:(REMWidgetSearchModelBase *)parameters andHiddenIndexes:(NSArray *)hiddenIndexes;

-(NSArray *)convertItemModels;

@end
