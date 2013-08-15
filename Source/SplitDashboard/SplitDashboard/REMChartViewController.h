//
//  REMDetailViewController.h
//  Dashboard
//
//  Created by TanTan on 6/19/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface REMChartViewController : UIViewController<CPTScatterPlotDataSource,CPTScatterPlotDelegate, CPTPlotSpaceDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
