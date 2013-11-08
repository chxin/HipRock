/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTestChartView.h
 * Created      : Zilong-Oscar.Xu on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "CPTGraphHostingView.h"
#import "REMChartHeader.h"

@interface REMTestChartView : CPTGraphHostingView<CPTBarPlotDataSource,CPTPlotSpaceDelegate, CPTBarPlotDelegate, CPTScatterPlotDataSource, CPTScatterPlotDelegate>

@end
