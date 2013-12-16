//
//  DAbstractChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DAbstractChartWrapper.h"

@implementation DAbstractChartWrapper

-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
    self = [self init];
    if (self) {
        _energyViewData = energyViewData;
        _style = style;
        _chartStatus = DChartStatusNormal;
    }
    return self;
}
-(void)cancelToolTipStatus {
    _chartStatus = DChartStatusNormal;
}

-(void)redraw:(REMEnergyViewData *)energyViewData {
    _energyViewData = energyViewData;
    
    _chartStatus = DChartStatusNormal;
}

-(UIView*)getView {
    return nil;
}

@end
