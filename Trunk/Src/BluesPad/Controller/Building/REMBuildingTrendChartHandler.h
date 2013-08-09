//
//  REMBuildingTrendChartHandler.h
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingChartHandler.h"
#import "REMEnergyViewData.h"
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetAxisHelper.h"

@interface REMBuildingTrendChartHandler : REMBuildingChartHandler<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate,CPTAxisDelegate>

@property (nonatomic,strong) REMEnergyViewData *data;
@property (nonatomic,strong) CPTXYGraph *graph;
@property (nonatomic,strong) NSMutableArray *chartData;
@property (nonatomic) double maxEnergyValue;
@property (nonatomic) NSInteger maxDateIndex;
@property  (nonatomic,strong) NSMutableArray *datasource;

- (void)changeData:(REMEnergyViewData *)data;

@end
