//
//  REMToggleButton.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/19/13.
//
//

#import "REMToggleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation REMToggleButton 
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:3.0];
        [self.layer setBorderWidth:0];
    }
    return self;
}
- (BOOL)toggle {
    self.on = !self.on;
    if (self.on) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self.on;
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.touchInside) {
        [self toggle];
    }
}

@end
