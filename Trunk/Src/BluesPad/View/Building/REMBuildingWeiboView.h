//
//  REMBuildingWeiboView.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/4/13.
//
//

#import <UIKit/UIKit.h>
#import "REMStatusBar.h"
#import "REMBuildingConstants.h"
#import "REMModalView.h"
#import <QuartzCore/QuartzCore.h>

@interface REMBuildingWeiboView : REMModalView

- (REMModalView*)initWithSuperView:(UIView*)superView text:(NSString*)text image:(UIImage*)image;
@property (nonatomic) NSString* weiboText;
@property (nonatomic) UIImage* weiboImage;
@end
