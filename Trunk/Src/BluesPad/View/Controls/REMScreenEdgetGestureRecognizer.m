//
//  REMScreenEdgetGestureRecognizer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/17/13.
//
//

#import "REMScreenEdgetGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation REMScreenEdgetGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    float touchX = [self locationInView:self.view].x;
    if (touchX > 974 || touchX < 50) {
        self.state = UIGestureRecognizerStateBegan;
    } else {
        self.state = UIGestureRecognizerStateCancelled;
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateEnded;
    NSLog(@"touchedEnded:%f",[self locationInView:self.view].x);
}
@end
