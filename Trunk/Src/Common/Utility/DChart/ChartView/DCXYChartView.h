//
//  DCXYChartView.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMChartStyle.h"
#import "DCContext.h"
#import "DCAxis.h"
#import "DCXYSeries.h"
#import "DCXYChartViewDelegate.h"

@interface DCXYChartView : UIView<DCContextHRangeObserverProtocal,UIGestureRecognizerDelegate>
@property (nonatomic, strong) REMChartStyle* chartStyle;
@property (nonatomic, assign) BOOL acceptPan;
@property (nonatomic, assign) BOOL acceptPinch;
@property (nonatomic, assign) BOOL acceptTap;
@property (nonatomic, strong) DCAxis* xAxis;
@property (nonatomic, strong) NSArray* yAxisList;

@property (nonatomic, strong) DCContext* graphContext;

@property (nonatomic, assign) BOOL hasVGridlines;

@property (nonatomic, weak) id<DCXYChartViewDelegate> delegate;

@property (nonatomic, strong) NSArray* seriesList;
@property (nonatomic, assign) NSUInteger visableYAxisAmount;

-(DCRange*)getRangeOfAxis:(DCAxis*)axis;

- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange stacked:(BOOL)stacked;

- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden;

-(void)setXLabelFormatter:(NSFormatter*)formatter;
//@property (nonatomic) NSArray* axis;
//@property (nonatomic, readonly) DCContext* graphContext;
-(double)getXLocationForPoint:(CGPoint)point;
-(void)focusAroundX:(double)x;
-(void)defocus;
-(void)setBackgoundBands:(NSArray*)bands;
-(void)reloadData;
-(void)subLayerGrowthAnimationDone;
-(_DCCoordinateSystem*)findCoordinateByYAxis:(DCAxis *)yAxis;
@end
