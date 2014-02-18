//
//  DCPieWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/28/13.
//
//

#import "DCPieWrapper.h"
#import "DCUtility.h"
@interface DCPieWrapper()
@property (nonatomic,assign) int focusIndex;
@end

@implementation DCPieWrapper
-(DCPieWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig *)wrapperConfig style:(REMChartStyle *)style {
    self = [super initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];
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
        p.color = [REMColor colorByIndex:i];
        p.target = seriesData.target;
        [series0Data addObject:p];
    }
    DCPieSeries* series = [[DCPieSeries alloc]initWithEnergyData:series0Data];
    for(NSUInteger i = 0; i < series.datas.count; i++) {
        DCPieDataPoint* slice = series.datas[i];
        if (REMIsNilOrNull(slice.target)) continue;
        slice.hidden = [self isTargetHidden:slice.target index:i];
    }
    _view = [[DCPieChartView alloc]initWithFrame:frame series:series];
    self.view.chartStyle = style;
    self.view.delegate = self;
//    self.view.radius = style.pieRadius;
//    self.view.radiusForShadow = style.pieShadowRadius;
    self.focusIndex = INT32_MIN;
}

-(void)pieRotated {
    if (self.view.focusPointIndex < self.view.series.datas.count && self.view.focusPointIndex != self.focusIndex && self.chartStatus == DChartStatusFocus) {
        self.focusIndex = self.view.focusPointIndex;
        DCPieDataPoint* piePoint = self.view.series.datas[self.view.focusPointIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoint:direction:)]) {
            [((id<REMTPieChartDelegate>)self.delegate) highlightPoint:piePoint direction:self.view.rotateDirection];
        }
    }
}

-(void)touchBegan {
    self.chartStatus = DChartStatusFocus;
    [DCUtility runFunction:^(void){
        [self.view setIndicatorHidden:NO];
    } withDelay:0.3];
    
}

-(void)cancelToolTipStatus {
    [super cancelToolTipStatus];
    self.focusIndex = INT32_MIN;
    [self.view setIndicatorHidden:YES];
}

-(NSUInteger)getVisableSeriesCount {
    NSUInteger count = 0;
    for (DCPieDataPoint* s in self.view.series.datas) {
        if (!s.hidden) count++;
    }
    return count;
}

-(void)redraw:(REMEnergyViewData *)energyViewData {
    [super redraw:energyViewData];
    UIView* superView = self.view.superview;
    CGRect frame = self.view.frame;
    [self.view removeFromSuperview];
    [self createView:frame data:energyViewData style:self.style];
    [superView addSubview:self.view];
}

-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    if (seriesIndex >= self.view.series.datas.count) return;
    DCPieDataPoint* slice = self.view.series.datas[seriesIndex];
    [self.view setSlice:slice hidden:hidden];
    if (REMIsNilOrNull(slice.target)) return;
    if (hidden) {
        [self addHiddenTarget:slice.target index:seriesIndex];
    } else {
        [self removeHiddenTarget:slice.target index:seriesIndex];
    }
}

-(UIView*)getView {
    return self.view;
}
@end