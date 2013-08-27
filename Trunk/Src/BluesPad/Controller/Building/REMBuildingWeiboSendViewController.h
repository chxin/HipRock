//
//  REMBuildingWeiboSendViewController.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/26/13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Weibo.h"
#import "REMAlertHelper.h"

@interface REMBuildingWeiboSendViewController : UIViewController<UITextViewDelegate>
//@property (nonatomic) UIImage* image;
@property (nonatomic) NSString* weiboText;
@property (nonatomic) UIImage* weiboImage;
@end
