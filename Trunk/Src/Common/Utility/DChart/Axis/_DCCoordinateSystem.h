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

@interface _DCCoordinateSystem : NSObject<DCContextHRangeObserverProtocal>

@property (nonatomic, weak, readonly) DCAxis* xAxis;
@property (nonatomic, weak, readonly) DCAxis* yAxis;
@property (nonatomic, strong, readonly) NSArray* seriesList;
@property (nonatomic, strong, readonly) NSArray* hiddenSeriesList;
@property (nonatomic, weak) DCContext* graphContext;
@property (nonatomic, assign, readonly) NSUInteger index;

-(id)initWithSeries:(NSArray*)series x:(DCAxis*)x y:(DCAxis*)y index:(NSUInteger)index;
@end