//
//  DCTrendAnimationManager.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/11/13.
//
//

#import <Foundation/Foundation.h>
#import "DCXYChartView.h"
#import "DCTrendAnimationDelegate.h"

@interface DCTrendAnimationManager : NSObject
@property (nonatomic, weak) DCXYChartView* view;
@property (nonatomic, weak) id<DCTrendAnimationDelegate> delegate;

-(void)invalidate;
-(BOOL)isValid;
-(void)animateHRangeWithSpeed:(double)speed completion:(void (^)())completion;
@end
