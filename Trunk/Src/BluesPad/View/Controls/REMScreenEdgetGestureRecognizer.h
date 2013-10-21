//
//  REMScreenEdgetGestureRecognizer.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/17/13.
//
//

#import <UIKit/UIKit.h>

@interface REMScreenEdgetGestureRecognizer : UIGestureRecognizer
@property (nonatomic) CGPoint eventStartPoint;
@property (nonatomic) CGPoint eventEndPoint;
-(int)getXMovement;
@end
