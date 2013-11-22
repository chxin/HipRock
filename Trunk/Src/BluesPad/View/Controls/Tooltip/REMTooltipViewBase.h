/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipViewBase.h
 * Date Created : 张 锋 on 11/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"
#import "REMWidgetSearchModelBase.h"

@protocol REMChartTooltipDelegate <NSObject>

-(void)tooltipWillDisapear;

@end


@interface REMTooltipViewBase : UIView

// Properties
@property (nonatomic) NSArray *highlightedPoints;
@property (nonatomic,weak) REMEnergyViewData *data;
@property (nonatomic,weak) REMWidgetObject *widget;
@property (nonatomic,weak) REMWidgetSearchModelBase *parameters;

@property (nonatomic,weak) NSObject<REMChartTooltipDelegate> *tooltipDelegate;

@property (nonatomic,strong) NSArray *itemModels;
@property (nonatomic,weak) UIScrollView *scrollView;

// Methods
+(REMTooltipViewBase *)tooltipWithHighlightedData:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters;

-(REMTooltipViewBase *)initWithHighlightedData:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters;

- (void)updateHighlightedData:(id)data;

- (NSArray *)convertItemModels;

- (UIView *)pointerView;

@end
