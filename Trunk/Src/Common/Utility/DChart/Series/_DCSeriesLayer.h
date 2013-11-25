//
//  _DCSeriesLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLayer.h"
#import "_DCCoordinateSystem.h"
//#import "DCXYSeries.h"
#import "DCContext.h"

@interface _DCSeriesLayer : _DCLayer<DCContextYRangeObserverProtocal,DCContextHRangeObserverProtocal>

@property (nonatomic, weak, readonly) _DCCoordinateSystem* coordinateSystem;
@property (nonatomic, strong) NSArray* series;

@property (nonatomic) CGFloat columnWidthInCoordinateSys;
@property (nonatomic) CGFloat heightUnitInScreen;
@property (nonatomic, strong) DCRange* yRange;
@property (nonatomic, strong) DCRange* xRange;

@property (nonatomic, readonly) int focusX;
@property (nonatomic, assign) BOOL enableGrowAnimation; // 是否播放初始动画，默认为YES，播放一次之后就变为NO

-(id)initWithCoordinateSystem:(_DCCoordinateSystem*)coordinateSystem;
//- (void)setSeries:(DCXYSeries*)series hidden:(BOOL)hidden;
-(BOOL)isValidSeriesForMe:(id)series;

-(void)focusOnX:(int)x;
-(void)defocus;
@end
