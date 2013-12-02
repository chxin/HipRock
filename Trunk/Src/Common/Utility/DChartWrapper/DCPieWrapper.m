//
//  DCPieWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/28/13.
//
//

#import "DCPieWrapper.h"

@implementation DCPieWrapper
-(DCPieWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*)widgetSyntax style:(REMChartStyle*)style {
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
    if (self && energyViewData.targetEnergyData.count != 0) {
        
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
            p.target = seriesData.target;
            [series0Data addObject:p];
        }
        DCPieSeries* series = [[DCPieSeries alloc]initWithEnergyData:series0Data];
        
        _view = [[DCPieChartView alloc]initWithFrame:frame series:series];
        self.view.userInteractionEnabled = self.style.userInteraction;
        self.view.radius = style.pieRadius;
        self.view.radiusForShadow = style.pieShadowRadius;
    }
    return self;
}

-(UIView*)getView {
    return self.view;
}
@end
