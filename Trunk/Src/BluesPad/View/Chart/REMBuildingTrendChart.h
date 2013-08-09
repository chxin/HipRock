//
//  REMBuildingTrendChart.h
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "REMTimeRange.h"
#import "REMEnergyViewData.h"
#import "REMBuildingTrendChartHandler.h"
#import "REMBuildingOverallModel.h"

@interface REMBuildingTrendChart : UIView
@property (nonatomic,strong) UIButton *todayButton;
@property (nonatomic,strong) UIButton *yestodayButton;
@property (nonatomic,strong) UIButton *thisMonthButton;
@property (nonatomic,strong) UIButton *lastMonthButton;
@property (nonatomic,strong) UIButton *thisYearButton;
@property (nonatomic,strong) UIButton *lastYearButton;
@property (nonatomic,strong) REMBuildingOverallModel *buildingInfo;
@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) CPTScatterPlot *scatterPlot;
@end
