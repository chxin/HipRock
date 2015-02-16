//
//  _DCCoordinateSystem.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/12/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCAxis.h"
#import "DCContext.h"
#import "DCColumnSeriesGroup.h"

@class _DCYAxisLabelLayer;
@class DCXYSeries;
@class DCXYChartView;

@interface _DCCoordinateSystem : NSObject<DCContextHRangeObserverProtocal>

@property (nonatomic, strong, readonly) DCAxis* xAxis;
@property (nonatomic, strong, readonly) DCAxis* yAxis;
@property (nonatomic, strong, readonly) NSArray* seriesList;
@property (nonatomic, strong, readonly) _DCYAxisLabelLayer* yAxisLabelLayer;
//@property (nonatomic, strong, readonly) NSArray* hiddenSeriesList;
@property (nonatomic, weak) DCContext* graphContext;
@property (nonatomic, weak) DCXYChartView* chartView;

@property (nonatomic, strong) DCRange* yRange;
@property (nonatomic, assign) double yInterval;
@property (nonatomic, strong, readonly) NSString* name;

/* key-seriesList dic */
@property (nonatomic, strong) NSMutableDictionary* columnGroupSeriesDic;

@property (nonatomic, assign) BOOL isMajor;


@property (nonatomic) CGFloat heightUnitInScreen;

-(id)initWithChartView:(UIView*)chartView name:(NSString*)name;
-(void)recalculatorYMaxInRange:(DCRange*)range;

-(void)addYIntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)removeYIntervalObsever:(id<DCContextYIntervalObserverProtocal>)observer;
-(void)clearYIntervalObsevers;

//-(_DCYAxisLabelLayer*)getAxisLabelLayer;
-(void)attachSeries:(DCXYSeries*)series;
-(void)detachSeries:(DCXYSeries*)series;

@end
