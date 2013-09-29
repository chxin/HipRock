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
@property (nonatomic,strong,readonly) UIView *legendView;
@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic,strong) REMToggleButtonGroup* toggleGroup;
//@property (nonatomic,strong) CPTScatterPlot *scatterPlot;
@end
