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
#import "_DCLayer.h"


@interface DCXYSeries : DCSeries<DCContextHRangeObserverProtocal>
@property (nonatomic, strong) DCRange* visableRange;
@property (nonatomic, readonly) NSNumber* visableYMax;
@property (nonatomic, readonly) NSNumber* visableYMin;
@property (nonatomic, weak) DCAxis* xAxis;
@property (nonatomic, weak) DCAxis* yAxis;
@property (nonatomic, weak) REMEnergyTargetModel* target;
@property (nonatomic, weak) _DCCoordinateSystem* coordinate;
//@property (nonatomic, assign) CGFloat pointXOffset;
@property (nonatomic, weak) _DCLayer* layer;

@property (nonatomic, assign)BOOL hidden;

@end
