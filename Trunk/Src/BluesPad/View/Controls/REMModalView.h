//
//  REMModalView.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/5/13.
//
//

#import <UIKit/UIKit.h>

@interface REMModalView : UIView
- (REMModalView*)initWithSuperView:(UIView*)superView;
- (void)show:(BOOL)fadeIn;
- (void)close:(BOOL)fadeOut;
//- (void)didShow;
@end
