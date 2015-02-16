//
//  _DCSeriesLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLayer.h"
#import "_DCCoordinateSystem.h"
#import "DCContext.h"

@interface _DCSeriesLayer : _DCLayer

//@property (nonatomic, strong, readonly) NSArray* seriesList;
@property (nonatomic, assign) BOOL enableGrowAnimation; // 是否播放初始动画，默认为YES，播放一次之后就变为NO
@property (nonatomic, assign) BOOL growthAnimationDone;
-(NSUInteger)getVisableSeriesCount;

@property (nonatomic, weak, readonly) NSArray* coordinateSystems;
-(id)initWithContext:(DCContext*)graphContext view:(DCXYChartView*)view coordinateSystems:(NSArray*)coordinateSystems;
-(BOOL)isValidSeriesForMe:(DCXYSeries*)series;

//-(void)redrawWithXRange:(DCRange*)xRange yRange:(DCRange*)yRange;
-(void)redraw;
@end
