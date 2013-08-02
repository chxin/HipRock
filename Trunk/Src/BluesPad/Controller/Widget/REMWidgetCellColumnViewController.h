//
//  REMWidgetCellColumnViewController.h
//  Blues
//
//  Created by zhangfeng on 7/11/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetCellViewController.h"
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"

@interface REMWidgetCellColumnViewController :REMWidgetCellViewController<CPTBarPlotDataSource,CPTBarPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>

@end
