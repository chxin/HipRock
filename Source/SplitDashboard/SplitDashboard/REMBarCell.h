//
//  REMCell.h
//  Dashboard
//
//  Created by TanTan on 6/18/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"


@interface REMBarCell : UICollectionViewCell<CPTPlotSpaceDelegate,CPTBarPlotDataSource,CPTBarPlotDelegate>

@property (weak, nonatomic) IBOutlet UIView *chartView;



- (void) initChart;


- (BOOL) isInitialized;

@end
