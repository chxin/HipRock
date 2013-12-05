//
//  _DCHPinchGestureRecognizer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import <UIKit/UIKit.h>

@interface _DCHPinchGestureRecognizer : UIPinchGestureRecognizer
@property (nonatomic, strong) NSSet* theTouches;
@property (nonatomic, assign, readonly) CGFloat leftScale;
@property (nonatomic, assign, readonly) CGFloat rightScale;
@property (nonatomic, assign, readonly) CGFloat centerX;
@end
