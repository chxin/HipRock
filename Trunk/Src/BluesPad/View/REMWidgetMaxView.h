//
//  REMWidgetMaxView.h
//  Blues
//
//  Created by TanTan on 7/2/13.
//
//

#import <UIKit/UIKit.h>
#import "REMModalView.h"
#import "REMDashboardCollectionCellView.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMPieChartWrapper.h"

@interface REMWidgetMaxView : REMModalView<UIGestureRecognizerDelegate>

@property (nonatomic, readonly) CGRect startFrame; // 最大化最小化动画的起止

@property (nonatomic, readonly) REMWidgetObject *widgetInfo;

-(REMModalView*)initWithSuperView:(UIView*)superView widgetCell:(REMDashboardCollectionCellView*)widgetCell;

@end
