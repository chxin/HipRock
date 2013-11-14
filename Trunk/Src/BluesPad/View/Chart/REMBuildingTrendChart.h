/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTrendChart.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMTimeRange.h"
#import "REMEnergyViewData.h"
#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingOverallModel.h"
#import "REMToggleButton.h"
#import "REMToggleButtonGroup.h"

@interface REMBuildingTrendChart : UIView
@property (nonatomic,strong) REMToggleButton *todayButton;
@property (nonatomic,strong) REMToggleButton *yestodayButton;
@property (nonatomic,strong) REMToggleButton *thisMonthButton;
@property (nonatomic,strong) REMToggleButton *lastMonthButton;
@property (nonatomic,strong) REMToggleButton *thisYearButton;
@property (nonatomic,strong) REMToggleButton *lastYearButton;
@property (nonatomic,strong) REMBuildingOverallModel *buildingInfo;
@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic,strong) REMToggleButtonGroup* toggleGroup;
//@property (nonatomic,strong) CPTScatterPlot *scatterPlot;
@end
