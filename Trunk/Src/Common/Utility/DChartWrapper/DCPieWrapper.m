//
//  DCPieWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/28/13.
//
//

#import "DCPieWrapper.h"
@interface DCPieWrapper()
@property (nonatomic,assign) int focusIndex;
@end

@implementation DCPieWrapper
-(DCPieWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*)widgetSyntax style:(REMChartStyle*)style {
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
    if (self && energyViewData.targetEnergyData.count != 0) {
        [self createView:frame data:energyViewData style:style];
    }
    return self;
}

-(void)createView:(CGRect)frame data:(REMEnergyViewData*)energyViewData style:(REMChartStyle*)style {
    NSMutableArray* series0Data = [[NSMutableArray alloc]init];
    int seriesCount = 0;
    if (self.energyViewData != nil && self.energyViewData.targetEnergyData != NULL) seriesCount =self.energyViewData.targetEnergyData.count;
    for (uint i = 0; i < seriesCount; i++) {
        REMTargetEnergyData* seriesData = [self.energyViewData.targetEnergyData objectAtIndex:i];
        DCPieDataPoint* p = [[DCPieDataPoint alloc]init];
        if (seriesData.energyData != nil && seriesData.energyData.count > 0) {
            REMEnergyData* point = seriesData.energyData[0];
            p.energyData = point;
            p.value = point.dataValue;
        } else {
        }
        p.color = [REMColor colorByIndex:i].uiColor;
        p.target = seriesData.target;
        [series0Data addObject:p];
    }
    DCPieSeries* series = [[DCPieSeries alloc]initWithEnergyData:series0Data];
    
    _view = [[DCPieChartView alloc]initWithFrame:frame series:series];
    self.view.delegate = self;
    self.view.playBeginAnimation = self.style.playBeginAnimation;
    self.view.userInteractionEnabled = self.style.userInteraction;
    self.view.radius = style.pieRadius;
    self.view.radiusForShadow = style.pieShadowRadius;
    self.focusIndex = INT32_MIN;
}

-(void)pieRotated {
    if (self.view.focusPointIndex < self.view.series.datas.count && self.view.focusPointIndex != self.focusIndex && self.chartStatus == DChartStatusFocus) {
        self.focusIndex = self.view.focusPointIndex;
        DCPieDataPoint* piePoint = self.view.series.datas[self.view.focusPointIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoint:color:name:direction:)]) {
            [((id<REMTPieChartDelegate>)self.delegate) highlightPoint:piePoint.energyData color:piePoint.color name:piePoint.target.name direction:self.view.rotateDirection];
        }
    }
}

-(void)touchBegan {
    self.chartStatus = DChartStatusFocus;
}

-(void)cancelToolTipStatus {
    [super cancelToolTipStatus];
    self.focusIndex = INT32_MIN;
}

-(void)redraw:(REMEnergyViewData *)energyViewData {
    [super redraw:energyViewData];
    UIView* superView = self.view.superview;
    CGRect frame = self.view.frame;
    [self.view removeFromSuperview];
    [self createView:frame data:energyViewData style:self.style];
    [superView addSubview:self.view];
}


-(UIView*)getView {
    return self.view;
}
@end
