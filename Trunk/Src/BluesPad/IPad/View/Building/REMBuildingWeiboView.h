/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingWeiboView.h
 * Created      : Zilong-Oscar.Xu on 9/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMStatusBar.h"
#import "Weibo.h"
#import "REMAlertHelper.h"
#import "REMBuildingConstants.h"
#import "REMModalView.h"
#import <QuartzCore/QuartzCore.h>

@interface REMBuildingWeiboView : REMModalView<UITextViewDelegate>

- (REMModalView*)initWithSuperView:(UIView*)superView text:(NSString*)text image:(UIImage*)image;
@property (nonatomic) NSString* weiboText;
@property (nonatomic) UIImage* weiboImage;
@end
