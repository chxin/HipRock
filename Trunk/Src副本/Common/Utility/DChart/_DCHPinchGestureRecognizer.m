//
//  _DCHPinchGestureRecognizer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "_DCHPinchGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
@interface _DCHPinchGestureRecognizer()
@property (nonatomic, assign) CGFloat beginDistance;
@end

@implementation _DCHPinchGestureRecognizer
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (REMIsNilOrNull(touches) || touches.count != 2) return;
    self.theTouches = touches.copy;
    [self log];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (REMIsNilOrNull(touches) || touches.count != 2) return;
    
    self.theTouches = touches.copy;
    [self log];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (REMIsNilOrNull(touches) || touches.count != 2) return;
    self.theTouches = touches.copy;
    [self log];
}

-(void)log {
    if (REMIsNilOrNull(self.view)) return;
    UITouch* touch0 = self.theTouches.allObjects[0];
    UITouch* touch1 = self.theTouches.allObjects[1];
    CGFloat currentX0 = [touch0 locationInView:self.view].x;
    CGFloat currentX1 = [touch1 locationInView:self.view].x;
    
    switch (self.state) {
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateBegan:
            _centerX = (currentX0 + currentX1) / 2;
            _leftScale = 1;
            _rightScale = 1;
            _beginDistance = fabsf(currentX1 - currentX0);
            break;
            
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            if (self.beginDistance != 0 && currentX0 != currentX1) {
//                CGFloat previousX0 = [touch0 previousLocationInView:self.view].x;
//                CGFloat previousX1 = [touch1 previousLocationInView:self.view].x;
//                _rightScale = (previousX1 - self.centerX) / (currentX1 - self.centerX);
//                _leftScale = (previousX0 - self.centerX) / (currentX0 - self.centerX);
//                if (self.rightScale < 0) _rightScale = 1;
//                if (self.leftScale < 0) _leftScale = 1;
                _rightScale = powf(self.beginDistance / fabsf(currentX1 - currentX0) , 0.5);
                _leftScale = self.rightScale;
                self.beginDistance = fabs(currentX1-currentX0);
            } else {
                _rightScale = 1;
                _leftScale = 1;
            }
            break;
        default:
            break;
    }
}
@end
