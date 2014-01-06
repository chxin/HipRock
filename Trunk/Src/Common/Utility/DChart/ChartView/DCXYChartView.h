//
//  DCXYChartView.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCContext.h"
#import "DCAxis.h"
#import "DCXYSeries.h"
#import "DCXYChartViewDelegate.h"

@interface DCXYChartView : UIView<DCContextHRangeObserverProtocal>
@property (nonatomic, assign) BOOL acceptPan;
@property (nonatomic, assign) BOOL acceptPinch;
@property (nonatomic, assign) BOOL acceptTap;
@property (nonatomic, strong) DCAxis* xAxis;
//@property (nonatomic, strong) DCAxis* yAxis0;
//@property (nonatomic, strong) DCAxis* yAxis1;
//@property (nonatomic, strong) DCAxis* yAxis2;
@property (nonatomic, strong) NSArray* yAxisList;

@property (nonatomic, strong) DCContext* graphContext;

@property (nonatomic, assign) BOOL hasVGridlines;

@property (nonatomic,assign) float hGridlineWidth;
@property (nonatomic) UIColor* hGridlineColor;
@property (nonatomic,assign) DCLineType hGridlineStyle;
@property (nonatomic,assign) float vGridlineWidth;
@property (nonatomic) UIColor* vGridlineColor;
@property (nonatomic,assign) DCLineType vGridlineStyle;
@property (nonatomic, assign) CGFloat plotPaddingTop;
@property (nonatomic, assign) CGFloat plotPaddingLeft;
@property (nonatomic, assign) CGFloat plotPaddingRight;
@property (nonatomic, assign) CGFloat plotPaddingBottom;

@property (nonatomic, assign) CGFloat focusSymbolLineWidth;
@property (nonatomic, assign) DCLineType focusSymbolLineStyle;
@property (nonatomic, strong) UIColor* focusSymbolLineColor;
@property (nonatomic, assign) CGFloat focusSymbolIndicatorSize;

@property (nonatomic, weak) id<DCXYChartViewDelegate> delegate;

@property (nonatomic, strong) NSArray* seriesList;
@property (nonatomic, assign) NSUInteger visableYAxisAmount;

@property (nonatomic, strong) UIFont* backgroundBandFont;
@property (nonatomic, strong) UIColor* backgroundBandFontColor;

@property (nonatomic, assign) BOOL blockReboundAnimation;   // YES的时候禁止回弹动画
@property (nonatomic, assign) BOOL xAxisLabelClipToBounds;

-(DCRange*)getRangeOfAxis:(DCAxis*)axis;

- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange stacked:(BOOL)stacked;

- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden;

-(void)setXLabelFormatter:(NSFormatter*)formatter;
//@property (nonatomic) NSArray* axis;
//@property (nonatomic, readonly) DCContext* graphContext;
-(double)getXLocationForPoint:(CGPoint)point;
-(void)focusAroundX:(double)x;
-(void)defocus;
-(void)relabelX;
-(void)setBackgoundBands:(NSArray*)bands;
-(void)reloadData;
@end
