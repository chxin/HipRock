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


@interface DCXYSeries : DCSeries<DCContextHRangeObserverProtocal>
@property (nonatomic, strong) DCRange* visableRange;
@property (nonatomic, readonly) NSNumber* visableYMax;
@property (nonatomic, weak) DCAxis* xAxis;
@property (nonatomic, weak) DCAxis* yAxis;


@end
