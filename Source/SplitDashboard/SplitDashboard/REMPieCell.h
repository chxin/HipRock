//
//  REMPieCell.h
//  SplitDashboard
//
//  Created by TanTan on 6/19/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface REMPieCell : UICollectionViewCell<CPTPieChartDataSource,CPTPlotSpaceDelegate, CPTPieChartDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *chartView;
- (void) initChart;


- (BOOL) isInitialized;

@end
