//
//  REMWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/11/13.
//
//

#import "REMWidgetWrapper.h"

@implementation REMWidgetWrapper

-(REMWidgetWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    return [self initWithFrame:frame data:energyViewData widgetContext:widgetSyntax status:REMWidgetStatusMinimized];
}
-(REMWidgetWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax status:(REMWidgetStatus)status {
    _status = status;
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax];
    return self;
}
-(void)destroyView {
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
    [super destroyView];
}
@end
