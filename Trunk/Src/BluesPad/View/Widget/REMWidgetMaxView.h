//
//  REMWidgetMaxView.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/2/13.
//
//

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
