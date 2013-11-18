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

@interface DCXYChartView : UIView
@property (nonatomic, strong) DCAxis* xAxis;
@property (nonatomic, strong) DCAxis* yAxis0;
@property (nonatomic, strong) DCAxis* yAxis1;
@property (nonatomic, strong) DCAxis* yAxis2;

@property (nonatomic, strong) DCContext* graphContext;


@property (nonatomic,assign) float hGridlineWidth;
@property (nonatomic) UIColor* hGridlineColor;
@property (nonatomic,assign) DCLineType hGridlineStyle;
@property (nonatomic,strong) DCRange* globalHRange;


@property (nonatomic, strong) NSArray* seriesList;
- (id)initWithFrame:(CGRect)frame beginHRange:(DCRange*)beginHRange stacked:(BOOL)stacked;

- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden;
//@property (nonatomic) NSArray* axis;
//@property (nonatomic, readonly) DCContext* graphContext;
@end
