//
//  DCXYSeries.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/8/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import "DCSeries.h"
#import "DCDataPoint.h"
#import "DCAxis.h"
#import "DCRange.h"
#import "_DCSeriesLayer.h"
#import "REMEnergyTargetModel.h"


@interface DCXYSeries : DCSeries<DCContextHRangeObserverProtocal>
@property (nonatomic, strong) DCRange* visableRange;
@property (nonatomic, readonly) NSNumber* visableYMax;
@property (nonatomic, weak) DCAxis* xAxis;
@property (nonatomic, weak) DCAxis* yAxis;
@property (nonatomic, weak) REMEnergyTargetModel* target;

@property (nonatomic, assign)BOOL hidden;

@property (nonatomic, weak) _DCSeriesLayer* seriesLayer;

@end
