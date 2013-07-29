//
//  REMLoginCustomerSelectViewController.m
//  Blues
//
//  Created by zhangfeng on 7/2/13.
//
//

#import "REMLoginCustomerViewController.h"
#import "REMLoginCustomerSelectViewController.h"
#import "REMAppDelegate.h"
#import "REMAlertHelper.h"
#import "REMCommonHeaders.h"

@interface REMLoginCustomerViewController ()

@end

@implementation REMLoginCustomerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    self.loginViewController = (REMLoginViewController *)self.parentViewController.parentViewController;
    self.userNameLabel.text = [REMApplicationContext instance].currentUser.realname;//[[REMAppDelegate app].currentUser valueForKey:@"RealName"];
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneTouchDown:(id)sender
{
    if([REMApplicationContext instance].currentCustomer == nil)
    {
        [REMAlertHelper alert:@"You must select a customer" withTitle:@"Sorry"];
    }
    else
    {
        [self.loginViewController gotoMainView];
    }
}

- (void)setSelectedCustomerName:(NSString *)customerName
{
    //self.customerListButton.titleLabel.text = customerName;
    
    [self.customerListButton setTitle:customerName forState:UIControlStateNormal];
    [self.customerListButton setTitle:customerName forState:UIControlStateSelected];
    [self.customerListButton setTitle:customerName forState:UIControlStateHighlighted];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    REMLoginCustomerSelectViewController *tableViewController = segue.destinationViewController;
     
    tableViewController.popoverViewController = ((UIStoryboardPopoverSegue *)segue).popoverController;
    
    tableViewController.customerViewController = self;
    
}
@end
