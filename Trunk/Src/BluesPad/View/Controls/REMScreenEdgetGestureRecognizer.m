//
//  REMScreenEdgetGestureRecognizer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/17/13.
//
//

#import "REMScreenEdgetGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation REMScreenEdgetGestureRecognizer {
    CGPoint eventStartPoint;
    CGPoint eventEndPoint;
}

-(int)getXMovement {
    if (self.state == UIGestureRecognizerStateEnded) {
        return abs(eventEndPoint.y - eventStartPoint.y);
    } else {
        return 0;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    eventStartPoint = [self locationInView:[UIApplication sharedApplication].keyWindow];
    float touchX = eventStartPoint.y;
    if (touchX > 974 || touchX < 50) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UIGestureRecognizerState s = self.state;
    if (s == UIGestureRecognizerStateBegan || s == UIGestureRecognizerStatePossible || s == UIGestureRecognizerStateChanged || s==UIGestureRecognizerStateRecognized) {
        eventEndPoint = [self locationInView:[UIApplication sharedApplication].keyWindow];
        if (abs(eventEndPoint.y - eventStartPoint.y) > 100) {
            self.state = UIGestureRecognizerStateEnded;
        } else {
            self.state = UIGestureRecognizerStateCancelled;
        }
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}
@end
