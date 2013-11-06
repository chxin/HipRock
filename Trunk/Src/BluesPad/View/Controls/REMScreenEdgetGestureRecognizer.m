/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMScreenEdgetGestureRecognizer.m
 * Created      : Zilong-Oscar.Xu on 10/17/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMScreenEdgetGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation REMScreenEdgetGestureRecognizer

-(int)getXMovement {
    return [self locationInView:[UIApplication sharedApplication].keyWindow].y - self.eventStartPoint.y;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.eventStartPoint = [self locationInView:[UIApplication sharedApplication].keyWindow];
    float touchX = self.eventStartPoint.y;
    if (touchX > 1000 || touchX < 20) {
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
        self.eventEndPoint = [self locationInView:[UIApplication sharedApplication].keyWindow];
        if (abs(self.eventEndPoint.y - self.eventStartPoint.y) > 100) {
            self.state = UIGestureRecognizerStateEnded;
        } else {
            self.state = UIGestureRecognizerStateCancelled;
        }
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}
@end
