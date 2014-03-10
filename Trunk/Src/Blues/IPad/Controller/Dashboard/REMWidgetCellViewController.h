/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCellViewController.h
 * Created      : tantan on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMDashboardController.h"

@interface REMWidgetCellViewController : UIViewController<REMChartDelegate>

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic) NSUInteger currentIndex;


@property (nonatomic,strong) REMEnergyViewData *chartData;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic,strong) REMBusinessErrorInfo *serverError;
@property (nonatomic) BOOL isServerTimeout;
@end
