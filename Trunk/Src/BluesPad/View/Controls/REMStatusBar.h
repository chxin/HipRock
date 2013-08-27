//
//  REMStatusBar.h
//  Blues
//
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
@end
