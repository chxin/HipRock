//
//  DCPieChartAnimationManager.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/26/13.
//
//

#import <Foundation/Foundation.h>
#import "DCPieChartAnimationFrame.h"

@interface DCPieChartAnimationManager : NSObject
-(id)initWithPieView:(UIView*)view;
-(void)animateToFrame:(DCPieChartAnimationFrame*)targetFrame;
-(void)rotateAngle:(double)angle withInitialSpeed:(double)speed;
-(void)stopTimer;
@end
