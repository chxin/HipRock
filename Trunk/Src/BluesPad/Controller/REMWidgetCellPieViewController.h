//
//  REMWidgetCellPieViewControllerViewController.h
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMWidgetCellViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"



@interface REMWidgetCellPieViewController: REMWidgetCellViewController<CPTPieChartDataSource,CPTPieChartDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>

@end
