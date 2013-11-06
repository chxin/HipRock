/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMaxView.h
 * Created      : TanTan on 7/2/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMModalView.h"
#import "REMDashboardCollectionCellView.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMPieChartWrapper.h"
#import "REMRankingWidgetWrapper.h"
#import "REMStackColumnWidgetWrapper.h"

@interface REMWidgetMaxView : REMModalView<UIGestureRecognizerDelegate>

@property (nonatomic) REMDashboardCollectionCellView* currentWidgetCell;

@property (nonatomic, readonly) REMWidgetObject *widgetInfo;

-(REMModalView*)initWithSuperView:(UIView*)superView widgetCell:(REMDashboardCollectionCellView*)widgetCell;

@end
