//
//  MyLayer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/18/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "_DCLayer.h"

@interface _DCContextAnimationLayer : _DCLayer

@property (nonatomic) double hRangeLocation;
-(void)animateHRangeLocationFrom:(double)from to:(double)to;
@end
