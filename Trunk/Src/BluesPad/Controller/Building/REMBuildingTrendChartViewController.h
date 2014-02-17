/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTrendChartHandler.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMBuildingChartBaseViewController.h"
#import "REMEnergyViewData.h"
#import "REMToggleButtonGroup.h"

@interface REMBuildingTrendChartViewController : REMBuildingChartBaseViewController<REMToggleButtonGroupDelegate>

@property (nonatomic,strong) REMEnergyViewData *data;
@property (nonatomic,strong) NSMutableArray *chartData;
@property (nonatomic) double maxEnergyValue;
@property (nonatomic) NSInteger maxDateIndex;

@end
