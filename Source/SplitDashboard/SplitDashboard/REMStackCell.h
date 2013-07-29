//
//  REMViewController.h
//  StackChartDemo
//
//  Created by TanTan on 6/6/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface REMStackCell : UICollectionViewCell<CPTBarPlotDataSource,CPTBarPlotDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartView;


@end
