/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetDetailViewController.h
 * Created      : tantan on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMEnum.h"


@interface REMWidgetDetailViewController : UIViewController

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,weak) REMEnergyViewData *energyData;


- (void)showChart;
-(void)releaseChart;
@end
