//
//  DCPieChartAnimationManager.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/26/13.
//
//

#import <Foundation/Foundation.h>
#import "DCPieChartAnimationFrame.h"
#import "DCPieDataPoint.h"
#import "DCPieSeries.h"

@interface DCPieChartAnimationManager : NSObject

-(id)initWithPieView:(UIView*)view;
-(void)animateToFrame:(DCPieChartAnimationFrame*)targetFrame;
-(void)rotateWithInitialSpeed:(double)speed;
-(void)playFrames:(NSArray*)frames;
-(void)stopTimer;

-(NSArray*)getAngleTurningFramesFrom:(double)from to:(double)to;
-(void)setPoint:(DCPieDataPoint*)point hidden:(BOOL)hidden;

-(double)getVisableValueOfPoint:(DCPieDataPoint*)point;

@property (nonatomic, weak) DCPieSeries* series;

/*获取可视的饼的值的总和*/
-(double)getVisableSliceSum;

-(CGFloat)findNearbySliceCenter:(CGFloat)angle;
-(NSUInteger)findIndexOfSlide:(CGFloat)angle;

@end
