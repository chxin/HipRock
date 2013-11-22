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

/*
 * return ture to move all series with pan, otherwise the chart will not move.
 */
-(BOOL)panInPlotAt:(CGPoint)point translation:(CGPoint)translation;

-(void)panStoppedAtRange:(DCRange*)range;
@end
