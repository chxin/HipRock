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

@property (nonatomic, weak, readonly) _DCCoordinateSystem* coordinateSystem;
@property (nonatomic, strong) NSArray* series;

@property (nonatomic) CGFloat columnWidthInCoordinateSys;
@property (nonatomic, strong) DCRange* yRange;  // 最后一次重绘时的yRange
@property (nonatomic, strong) DCRange* xRange;  // 最后一次重绘时的xRange

@property (nonatomic, assign) BOOL enableGrowAnimation; // 是否播放初始动画，默认为YES，播放一次之后就变为NO

-(id)initWithCoordinateSystem:(id)coordinateSystem;
-(BOOL)isValidSeriesForMe:(id)series;
-(void)redrawWithXRange:(DCRange*)xRange yRange:(DCRange*)yRange;
-(void)redraw;
@end
