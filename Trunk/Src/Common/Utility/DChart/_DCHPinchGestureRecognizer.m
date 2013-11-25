//
//  _DCHPinchGestureRecognizer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "_DCHPinchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation _DCHPinchGestureRecognizer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.theTouches = touches.copy;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.theTouches = touches.copy;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.theTouches = touches.copy;
}
@end
