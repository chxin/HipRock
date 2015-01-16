//
//  DCXYChartView.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCChartStyle.h"
#import "DCContext.h"
#import "DCAxis.h"
#import "DCXYSeries.h"
#import "DCXYChartViewDelegate.h"

@interface DCXYChartView : UIView<DCContextHRangeObserverProtocal,UIGestureRecognizerDelegate>
@property (nonatomic, strong) DCChartStyle* chartStyle;
@property (nonatomic, assign) BOOL acceptPan;
@property (nonatomic, assign) BOOL acceptPinch;
@property (nonatomic, assign) BOOL acceptTap;
@property (nonatomic, strong) DCAxis* xAxis;

@property (nonatomic, strong) DCContext* graphContext;

@property (nonatomic, weak) id<DCXYChartViewDelegate> delegate;

@property (nonatomic, strong) NSArray* seriesList;
@property (nonatomic, assign) NSUInteger visableYAxisAmount;

- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange;

- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden;  // Hide or show a series

-(void)setXLabelFormatter:(NSFormatter*)formatter;  // Set xLabel formatter. Will affect x-axis label in next draw
-(double)getXLocationForPoint:(CGPoint)point;
-(void)focusAroundX:(double)x;  // Highlight all points around specificied x
-(void)defocus; // de-highlight
-(void)setBackgoundBands:(NSArray*)bands;   // Set background band. Will be drawn immedietely.
-(void)reloadData;
-(void)subLayerGrowthAnimationDone;
-(_DCCoordinateSystem*)findCoordinateByYAxis:(DCAxis *)yAxis;
-(NSArray*)getYAxes;

-(void)updateSeries:(DCXYSeries*)series type:(DCSeriesType)type coordinateName:(NSString*)coordinateName stacked:(BOOL)stacked;
@end
