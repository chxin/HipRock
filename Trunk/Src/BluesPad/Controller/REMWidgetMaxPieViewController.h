//
//  REMWidgetMaxPieViewController.h
//  Blues
//
//  Created by 谭 坦 on 7/17/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetMaxViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetMaxDiagramViewController.h"

@interface REMWidgetMaxPieViewController : REMWidgetMaxDiagramViewController<CPTPieChartDataSource,CPTPieChartDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>

@end
