//
//  REMBuildingShareViewController.h
//  Blues
//
//  Created by 张 锋 on 11/1/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "REMBuildingViewController.h"

@interface REMBuildingShareViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (weak,nonatomic) REMBuildingViewController *buildingController;

@property (weak, nonatomic) IBOutlet UIButton *weiboButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;

@end
