//
//  REMWidgetCellLineViewController.h
//  Blues
//
//  Created by 徐 子龙 on 13-7-15.
//
//

#import <Foundation/Foundation.h>
#import "REMWidgetCellViewController.h"
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetAxisHelper.h"

@interface REMWidgetCellLineViewController :REMWidgetCellViewController<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate,CPTAxisDelegate>

@end
