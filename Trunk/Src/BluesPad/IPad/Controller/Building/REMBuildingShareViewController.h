/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingShareViewController.h
 * Created      : 张 锋 on 11/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "REMBuildingViewController.h"

@interface REMBuildingShareViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (weak,nonatomic) REMBuildingViewController *buildingController;

@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;

@end
