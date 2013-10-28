//
//  REMAbstractChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMAbstractChartWrapper.h"

@implementation REMAbstractChartWrapper
-(REMAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax  styleDictionary:(NSDictionary*)style{
    self = [super init];
    if (self) {
        _energyViewData = energyViewData;
        _widgetSyntax = widgetSyntax;
        _view = [self renderContentView:frame chartConfig:[self getChartConfig:style]];
    }
    return self;
}

-(void)destroyView {
    if ([self.view isKindOfClass:[CPTGraphHostingView class]]) {
        CPTGraphHostingView *hostView=(CPTGraphHostingView*)self.view;
        [hostView.hostedGraph removeAllAnimations];
        [hostView.hostedGraph removeAllAnnotations];
        for (CPTAxis *axis in hostView.hostedGraph.axisSet.axes) {
            axis.majorTickLocations=nil;
            axis.minorTickAxisLabels=nil;
            [axis removeFromSuperlayer];
        }
        [hostView.hostedGraph.axisSet removeFromSuperlayer];
        hostView.hostedGraph.axisSet.axes=nil;
        
        [hostView.hostedGraph.plotAreaFrame removeFromSuperlayer];
        [hostView.hostedGraph removeFromSuperlayer];
        hostView.hostedGraph=nil;
        [hostView removeFromSuperview];
        hostView = nil;
    }
    _view = nil;
}

-(REMChartConfig*)getChartConfig:(NSDictionary*)style {
    return nil;
}

-(UIView*)renderContentView:(CGRect)frame chartConfig:(REMChartConfig*)chartConfig {
    return nil;
}
@end
