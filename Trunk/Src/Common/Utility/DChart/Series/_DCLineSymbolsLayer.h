//
//  _DCLineSymbolsLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "_DCLayer.h"
#import "_DCLine.h"

@interface _DCLineSymbolsLayer : _DCLayer
@property (nonatomic, readonly, strong) NSArray* series;
@property (nonatomic, assign) BOOL enableGrowAnimation; // 是否播放初始动画，默认为YES，播放一次之后就变为NO
-(id)initWithContext:(DCContext*)context view:(DCXYChartView*)view series:(NSArray*)series;
-(NSUInteger)getVisableSeriesCount;
@end
