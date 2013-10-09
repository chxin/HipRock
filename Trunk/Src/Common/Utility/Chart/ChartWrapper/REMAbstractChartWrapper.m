//
//  REMAbstractChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMAbstractChartWrapper.h"

@implementation REMAbstractChartWrapper
-(REMAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    self = [super init];
    if (self) {
        _dataProcessor = [self initializeProcessor];
        _energyViewData = energyViewData;
        _widgetSyntax = widgetSyntax;
        _view = [self renderContentView:frame data:energyViewData widgetContext:widgetSyntax];
    }
    return self;
}

-(void)destroyView {
    _view = nil;
}

-(UIView*)renderContentView:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    return nil;
}
-(REMChartDataProcessor*)initializeProcessor {
    return nil;
}
@end
