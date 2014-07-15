/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendBase.m
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMChartLegendBase.h"
#import "REMEnergyViewData.h"
#import "REMEnergyTargetModel.h"
#import "REMChartLegendItem.h"
#import "REMColor.h"
#import "REMWidgetMultiTimespanSearchModel.h"
#import "REMStackChartLegendView.h"
#import "REMTrendChartLegendView.h"
#import "REMPieChartLegendView.h"

@implementation REMChartLegendBase

#define REMSeriesIsMultiTime [self.parameters isKindOfClass:[REMWidgetMultiTimespanSearchModel class]]


+(REMChartLegendBase *)legendViewChartWrapper:(DAbstractChartWrapper *)chartWrapper data:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget parameters:(REMWidgetSearchModelBase *)parameters delegate:(id<REMChartLegendItemDelegate>)delegate
{
    REMDiagramType diagramType = (REMDiagramType)[widget.diagramType intValue];
    if(diagramType == REMDiagramTypePie){
        return [[REMPieChartLegendView alloc] initWithChartWrapper:chartWrapper data:data widget:widget parameters:parameters delegate:delegate];
    }
//    else if(diagramType == REMDiagramTypeStackColumn){
//        return [[REMStackChartLegendView alloc] initWithChartWrapper:chartWrapper data:data widget:widget parameters:parameters delegate:delegate];
//    }
    else{
        return [[REMTrendChartLegendView alloc] initWithChartWrapper:chartWrapper data:data widget:widget parameters:parameters delegate:delegate];
    }
}

-(REMChartLegendBase *)initWithChartWrapper:(DAbstractChartWrapper *)chartWrapper data:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget parameters:(REMWidgetSearchModelBase *)parameters delegate:(id<REMChartLegendItemDelegate>)delegate
{
    self = [super initWithFrame:kDMChart_ToolbarHiddenFrame];
    
    if(self){
        _itemDelegate = delegate;
        self.chartWrapper = chartWrapper;
        self.widget = widget;
        self.parameters = parameters;
        self.data = data;
        
        self.itemModels = [self convertItemModels];
        
        [self render];
    }
    
    return self;
}

//@virtual
-(NSArray *)convertItemModels
{
    return nil;
}


-(void)render
{
    CGFloat width = REMSeriesIsMultiTime ? 320 : kDMChart_LegendItemWidth;
    
    CGFloat scrollViewContentWidth = (width + kDMChart_LegendItemLeftOffset) * self.itemModels.count + kDMChart_LegendItemLeftOffset;
    
    self.backgroundColor = [REMColor colorByHexString:kDMChart_BackgroundColor];
    self.contentSize = CGSizeMake(scrollViewContentWidth, kDMChart_ToolbarHeight);
    self.pagingEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    for(int i=0;i<self.itemModels.count; i++){
        REMChartLegendItemModel *model = self.itemModels[i];
        
        CGFloat x = i * (width + kDMChart_LegendItemLeftOffset);
        CGFloat y = (kDMChart_ToolbarHeight - kDMChart_LegendItemHeight) / 2;
        
        REMChartLegendItem *legend = [[REMChartLegendItem alloc] initWithFrame:CGRectMake(x, y, width, kDMChart_LegendItemHeight) andModel:model];
        
        [self addSubview:legend];
    }
}

@end
