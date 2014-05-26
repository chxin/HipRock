//
//  DCXYSeries.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCSeries.h"
#import "DCAxis.h"
#import "DCRange.h"
#import "REMEnergyTargetModel.h"
#import "_DCCoordinateSystem.h"
@class _DCSeriesLayer;

@interface DCXYSeries : DCSeries<DCContextHRangeObserverProtocal>
@property (nonatomic, strong) DCRange* visableRange;
@property (nonatomic, readonly) NSNumber* visableYMax;
@property (nonatomic, readonly) NSNumber* visableYMin;
@property (nonatomic, strong) NSNumber* visableYMaxThreshold; // visableYMax不允许小于这个值
@property (nonatomic, weak) DCAxis* xAxis;
@property (nonatomic, weak) DCAxis* yAxis;
@property (nonatomic, weak) REMEnergyTargetModel* target;
@property (nonatomic, weak) _DCCoordinateSystem* coordinate;
//@property (nonatomic, assign) CGFloat pointXOffset;
@property (nonatomic, weak) _DCSeriesLayer* seriesLayer;

@property (nonatomic, assign)BOOL hidden;

-(void)copyFromSeries:(DCXYSeries*)series;
@end
