/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginCustomerViewController.h
 * Created      : 张 锋 on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMLoginPageController.h"

@interface REMLoginCustomerViewController : UITableViewController

@property (nonatomic,weak) REMLoginPageController *loginPageController;
- (IBAction)cancelButtonPressed:(id)sender;

@end
