//
//  DChartLinerWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "DChartLineChartWrapper.h"

@implementation DChartLineChartWrapper
@synthesize defaultSeriesClass = _defaultSeriesClass;

-(id)init {
    self = [super init];
    if (self) {
        _defaultSeriesClass = @"DCLineSeries";
    }
    return self;
}

//-(DChartLineChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
//    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
//    return self;
//}

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index {
    if ([self.defaultSeriesClass isEqualToString:NSStringFromClass([series class])]) {
        ((DCLineSeries*)series).symbol = index % 5;
    }
}
@end
