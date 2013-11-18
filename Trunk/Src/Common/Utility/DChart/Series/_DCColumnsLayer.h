//
//  DCColumnsLayer.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/13/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_DCMagicLayer.h"
#import "_DCCoordinateSystem.h"
#import "DCColumnSeries.h"
#import "DCContext.h"

@interface _DCColumnsLayer : _DCMagicLayer<DCContextYRangeObserverProtocal,DCContextHRangeObserverProtocal>

-(id)initWithCoordinateSystem:(_DCCoordinateSystem*)coordinateSystem;
- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden;
@end
