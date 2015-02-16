/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMStatusBar.h
 * Created      : Zilong-Oscar.Xu on 8/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>

@interface REMStatusBar : UIWindow
{
//    BBCyclingLabel *defaultLabel;
    NSMutableArray* labels;
    NSInteger currentIndex;
}
+ (void)showStatusMessage:(NSString *)message;
+ (void)showStatusMessage:(NSString *)message autoHide:(BOOL)autoHide;
@end
