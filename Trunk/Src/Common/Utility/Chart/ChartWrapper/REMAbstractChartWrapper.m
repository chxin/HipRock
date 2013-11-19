/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAbstractChartWrapper.m
 * Created      : Zilong-Oscar.Xu on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMAbstractChartWrapper.h"

@implementation REMAbstractChartWrapper {
    REMChartStyle* myStyle;
}
-(REMAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax  style:(REMChartStyle*)style{
    self = [super init];
    if (self) {
        _energyViewData = energyViewData;
        [self extraSyntax:widgetSyntax];
        myStyle = style;
        _view = [self renderContentView:frame chartConfig:[self getChartConfig:style]];
    }
    return self;
}

-(void)extraSyntax:(REMWidgetContentSyntax*)widgetSyntax {
    
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

-(REMChartConfig*)getChartConfig:(REMChartStyle*)style {
    return nil;
}

-(UIView*)renderContentView:(CGRect)frame chartConfig:(REMChartConfig*)chartConfig {
    return nil;
}

-(void)redraw:(REMEnergyViewData *)energyViewData {
    CGRect frame = self.view.frame;
    UIView* superView = self.view.superview;
    [self.view removeFromSuperview];
    [self destroyView];
    
    _energyViewData = energyViewData;
    _view = [self renderContentView:frame chartConfig:[self getChartConfig:myStyle]];
//    myStyle = nil;
    if (superView) [superView addSubview:self.view];
}
@end
