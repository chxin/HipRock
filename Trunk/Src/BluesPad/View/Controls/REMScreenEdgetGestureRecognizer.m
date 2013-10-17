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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    eventStartPoint = [self locationInView:self.view];
    float touchX = eventStartPoint.x;
    if (touchX > 974 || touchX < 50) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateBegan) {
        eventEndPoint = [self locationInView:self.view];
        if (abs(eventEndPoint.x - eventStartPoint.x) > 100) {
            self.state = UIGestureRecognizerStateEnded;
        } else {
            self.state = UIGestureRecognizerStateCancelled;
        }
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}
@end
