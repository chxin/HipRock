//
//  REMWidgetMaxLineViewController.h
//  Blues
//
//  Created by 谭 坦 on 7/18/13.
//
//

#import "REMWidgetMaxDiagramViewController.h"
#import "REMWidgetCellViewController.h"
#import "CPTBarPlot.h"
#import "CPTPlotSpace.h"
#import "CorePlot-CocoaTouch.h"
#import "REMColor.h"
#import "REMWidgetAxisHelper.h"
@interface REMWidgetMaxLineViewController : REMWidgetMaxDiagramViewController<CPTScatterPlotDataSource,CPTScatterPlotDelegate,CPTPlotSpaceDelegate,UIGestureRecognizerDelegate,CPTAxisDelegate>

@end
