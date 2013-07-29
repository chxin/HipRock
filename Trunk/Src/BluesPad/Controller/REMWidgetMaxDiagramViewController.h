//
//  REMWidgetMaxDiagramViewController.h
//  Blues
//
//  Created by 谭 坦 on 7/17/13.
//
//

#import <UIKit/UIKit.h>
#import "REMEnergyViewData.h"
#import "REMWidgetMaxView.h"
#import "CorePlot-CocoaTouch.h"
#import "REMWidgetObject.h"

@interface REMWidgetMaxDiagramViewController : NSObject

@property (nonatomic,strong) CPTGraph *graph;
@property (nonatomic,strong) REMWidgetMaxView *chartView;
@property (nonatomic,strong) REMEnergyViewData *data;
@property (nonatomic,strong) NSMutableArray *hiddenTargets;
@property (nonatomic,strong) REMWidgetObject *widgetModel;
@property (nonatomic,strong) id maxViewController;


- (void) initDiagram;
- (void)hidePlots;
- (void) reloadChart;
@end
