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

-(void)setOn:(BOOL)onThis {
    if (onThis == self.on) return;
    
    _on = onThis;
    if (onThis) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
