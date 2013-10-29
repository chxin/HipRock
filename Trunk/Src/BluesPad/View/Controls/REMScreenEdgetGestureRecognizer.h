//
//  REMScreenEdgetGestureRecognizer.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 10/17/13.
//
//

#import <UIKit/UIKit.h>

@interface REMScreenEdgetGestureRecognizer : UIGestureRecognizer
@property (nonatomic) CGPoint eventStartPoint;
@property (nonatomic) CGPoint eventEndPoint;
-(int)getXMovement;
@end
