//
//  REMBuildingTrendChartController.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/8/13.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "REMWidgetCellViewController.h"
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetAxisHelper.h"

@interface REMBuildingTrendChartController :UIViewController<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate,CPTAxisDelegate>

@property (nonatomic,strong) REMEnergyViewData *data;
@property (nonatomic,strong) CPTXYGraph *graph;
@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) NSMutableArray *chartData;
@property (nonatomic) double maxEnergyValue;
@property (nonatomic) NSInteger maxDateIndex;
@property  (nonatomic,strong) NSMutableArray *datasource;
- (void)initLineChart:(CGRect)frame;
- (void)changeData:(REMEnergyViewData *)data;
@end
