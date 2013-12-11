//
//  DCTrendAnimationManager.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/11/13.
//
//

#import <Foundation/Foundation.h>
#import "DCXYChartView.h"

@interface DCTrendAnimationManager : NSObject
@property (nonatomic, weak) DCXYChartView* view;

-(void)invalidate;
-(void)animateHRangeLocationFrom:(double)from to:(double)to;
@end
