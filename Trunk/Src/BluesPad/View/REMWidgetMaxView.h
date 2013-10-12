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

@interface REMWidgetMaxView : REMModalView
@property (nonatomic, readonly) CGRect startFrame; // 最大化最小化动画的起止
-(REMModalView*)initWithSuperView:(UIView*)superView widgetCell:(REMDashboardCollectionCellView*)widgetCell;
@end
