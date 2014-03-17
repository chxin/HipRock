//
//  DCChartTrendWrapperDelegate.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "DCChartWrapperDelegate.h"

@protocol DCChartTrendWrapperDelegate <DCChartWrapperDelegate>

@optional
/*
 * points: List<DCDataPoint>
 */
-(void)highlightPoints:(NSArray*)points x:(id)x;

/*
 * Parameter data type: NSDate for line/column. NSNumber for ranking.
 */
-(void)willRangeChange:(id)start end:(id)end;
-(void)gestureEndFrom:(id)start end:(id)end;
@end
