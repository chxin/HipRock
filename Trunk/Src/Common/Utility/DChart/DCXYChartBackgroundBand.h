//
//  DCXYChartBackgroundBand.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/23/13.
//
//

#import <Foundation/Foundation.h>
#import "DCRange.h"
#import "_DCCoordinateSystem.h"


@interface DCXYChartBackgroundBand : NSObject
@property (nonatomic, strong) DCRange* range;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, weak) _DCCoordinateSystem* coordinateSystem;
@property (nonatomic, weak) DCAxis* axis;
@end
