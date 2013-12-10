//
//  DChartLinerWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "DCLineWrapper.h"

@implementation DCLineWrapper
@synthesize defaultSeriesClass = _defaultSeriesClass;

-(id)init {
    self = [super init];
    if (self) {
        _defaultSeriesClass = @"DCLineSeries";
    }
    return self;
}

//-(DCLineWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
//    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
//    return self;
//}

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(REMChartStyle*)style {
    if ([self.defaultSeriesClass isEqualToString:NSStringFromClass([series class])]) {
        ((DCLineSeries*)series).symbolType = index % 5;
        ((DCLineSeries*)series).symbolSize = style.symbolSize;
    }
    [super customizeSeries:series seriesIndex:index chartStyle:style];
}
-(void)customizeView:(DCXYChartView*)view {
    view.graphContext.showIndicatorOnFocus = YES;
}
@end
