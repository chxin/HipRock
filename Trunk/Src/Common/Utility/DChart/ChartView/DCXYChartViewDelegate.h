//
//  DCXYChartViewDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/22/13.
//
//

#import <Foundation/Foundation.h>

@protocol DCXYChartViewDelegate <NSObject>
@optional
/*** 
 * point:touch point in view
 * xLocation: xValue of touch point
 ***/
-(void)tapInPlotAt:(CGPoint)point xCoordinate:(double)xLocation;

-(void)touchesBegan;
-(void)touchesEnded;

-(void)didYIntervalChange:(double)yInterval forAxis:(DCAxis *)yAxis range:(DCRange*)range;
-(void)panWithSpeed:(CGFloat)speed panStopped:(BOOL)stopped;

-(void)focusPointChanged:(NSArray*)dcpoints at:(int)x;

-(DCRange*)updatePinchRange:(DCRange*)newRange pinchCentreX:(CGFloat)centreX pinchStopped:(BOOL)stopped;
-(DCRange*)updatePanRange:(DCRange *)newRange withSpeed:(double)speed;
-(void)beginAnimationDone;
@end
