//
//  REMStatusBar.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 8/26/13.
//
//

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
