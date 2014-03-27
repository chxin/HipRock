/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipViewBase.h
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMEnergyViewData.h"
#import "REMWidgetSearchModelBase.h"
#import "DAbstractChartWrapper.h"
#import "REMManagedWidgetModel.h"

@protocol REMChartTooltipDelegate <NSObject>

-(void)tooltipWillDisapear;

@end


@interface REMTooltipViewBase : UIView

// Properties
@property (nonatomic) NSArray *highlightedPoints; //array of DCChartPoint
@property (nonatomic,weak) DAbstractChartWrapper *chartWrapper;
@property (nonatomic,weak) REMEnergyViewData *data;
@property (nonatomic,weak) REMManagedWidgetModel *widget;
@property (nonatomic,weak) REMWidgetSearchModelBase *parameters;
@property (nonatomic) id x;

@property (nonatomic,weak) NSObject<REMChartTooltipDelegate> *tooltipDelegate;

@property (nonatomic,strong) NSArray *itemModels;

@property (nonatomic,weak) UIView *contentView;
@property (nonatomic,weak) UIScrollView *scrollView;

// Methods
+ (REMTooltipViewBase *)tooltipWithHighlightedPoints:(NSArray *)points atX:(id)x chartWrapper:(DAbstractChartWrapper *)chartWrapper inEnergyData:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters;

-(REMTooltipViewBase *)initWithDefaults;
- (REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points atX:(id)x chartWrapper:(DAbstractChartWrapper *)chartWrapper  inEnergyData:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters;

//- (void)updateHighlightedData:(id)data;

- (NSArray *)convertItemModels;

- (UIView *)renderCloseView;

-(UIScrollView *)renderScrollView;

@end
