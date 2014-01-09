//
//  DCXYChartViewDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/22/13.
//
//

#import <Foundation/Foundation.h>

@protocol DCXYChartViewDelegate <NSObject>
-(void)touchedInPlotAt:(CGPoint)point xCoordinate:(double)xLocation;
-(void)didYIntervalChange:(double)yInterval forAxis:(DCAxis *)yAxis range:(DCRange*)range;
-(void)panWithSpeed:(CGFloat)speed panStopped:(BOOL)stopped;

-(void)pinchStopped;

-(void)focusPointChanged:(NSArray*)dcpoints at:(int)x;

-(DCRange*)updatePinchRange:(DCRange*)newRange;
@end
