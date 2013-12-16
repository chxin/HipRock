/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMModalView.h
 * Created      : Zilong-Oscar.Xu on 9/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>

@interface REMModalView : UIView
- (REMModalView*)initWithSuperView:(UIView*)superView;
- (void)show:(BOOL)fadeIn;
- (void)close:(BOOL)fadeOut;
//- (void)didShow;
@end
