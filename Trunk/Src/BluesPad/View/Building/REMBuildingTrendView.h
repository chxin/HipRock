//
//  REMBuildingTrendView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/8/13.
//
//

#import <UIKit/UIKit.h>
#import "REMBuildingTrendChartController.h"
#import "REMBuildingOverallModel.h"

@interface REMBuildingTrendView : UIView

@property (nonatomic,strong) UIButton *todayButton;
@property (nonatomic,strong) UIButton *yestodayButton;
@property (nonatomic,strong) UIButton *thisMonthButton;
@property (nonatomic,strong) UIButton *lastMonthButton;
@property (nonatomic,strong) UIButton *thisYearButton;
@property (nonatomic,strong) UIButton *lastYearButton;
@property (nonatomic,strong) REMBuildingTrendChartController *chartController;
@property (nonatomic,strong) REMBuildingOverallModel *buildingInfo;

@end
