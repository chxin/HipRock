//
//  REMBuildingSettingViewController.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/22/13.
//
//

#import "REMBuildingSettingViewController.h"
#import "Weibo.h"
#import "WeiboAccounts.h"
#import "REMAlertHelper.h"
#import "REMSettingCustomerSelectionViewController.h"


@interface REMBuildingSettingViewController ()

@end

@implementation REMBuildingSettingViewController
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.backBarButtonItem=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController=(UINavigationController *)self.parentViewController;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 2;
    if (section == 1) return 2;
    if (section == 2) return 1;
    if (section == 3) return 1;
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    // weibo account binding cell
    if (indexPath.section == 2 && indexPath.item == 0) {
        [[cell textLabel]setText:@"绑定新浪微博"];
        self.weiboAccoutSwitcher = [[UISwitch alloc]initWithFrame:CGRectMake(405, 12, 79, 27)];
        self.weiboAccoutSwitcher.on = [Weibo.weibo isAuthenticated];
        [self.weiboAccoutSwitcher addTarget:self action:@selector(weiboSwitcherChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:self.weiboAccoutSwitcher];
    }
    //logout cell
    else if(indexPath.section==0){
        
        
        if(indexPath.row==0){
            [[cell textLabel]setText:@"显示名称"];
            NSString *name=[REMApplicationContext instance].currentUser.realname;
            [cell.detailTextLabel setText:name];
        }
        else{
            [[cell textLabel]setText:@"能源管理开发平台ID"];
            NSString *name1=[REMApplicationContext instance].currentUser.name;
            [cell.detailTextLabel setText:name1];
        }
    }
    else if(indexPath.section==1){
        
        
        if(indexPath.row==0){
            [[cell textLabel]setText:@"当前客户"];
            NSString *name=[REMApplicationContext instance].currentCustomer.name;
            [cell.detailTextLabel setText:name];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            [[cell textLabel]setText:@"客户信息"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if(indexPath.section==3 && indexPath.row==0 ){
        UITableViewCell *cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        //[[cell textLabel]setText:@"退出登录"];
        cell1.textLabel.text=@"退出登录";
        cell1.textLabel.textColor=[UIColor redColor];
        cell1.textLabel.textAlignment=NSTextAlignmentCenter;
        return cell1;
        //NSLog(@"frame:%@",NSStringFromCGRect(cell.contentView.frame));
        //NSLog(@"bounds:%@",NSStringFromCGRect(cell.contentView.frame));
        
        
        /*
         UIButton *logout= [UIButton buttonWithType:UIButtonTypeRoundedRect];
         [logout setFrame: CGRectMake(0, 0, 480, cell.contentView.frame.size.height)];
         
         logout.layer.borderWidth=0;
         
         
         [logout setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         [logout setTitle:@"退出登录" forState:UIControlStateNormal];
         logout.contentMode=UIViewContentModeScaleAspectFit;
         [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:logout];*/
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1 && indexPath.row==0){
        [self performSegueWithIdentifier:@"settingCustomerDetailSegue" sender:self];
    }
    else if(indexPath.section==1 && indexPath.row==1){
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.accessibilityIdentifier isEqual: @"weiboAccount"]) {
        if (buttonIndex == 0) {
            self.weiboAccoutSwitcher.on = YES;
        } else if (buttonIndex == 1) {
            [[WeiboAccounts shared]signOut];
        }
    } else {
        if(buttonIndex==0){
            [self logoutAndClearCache];
        }
    }
}

- (void)logout{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您要退出当前账号登录吗?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"退出",@"放弃", nil];
    alert.cancelButtonIndex=1;
    
    [alert show];
}

-(void)logoutAndClearCache
{
    REMUserModel *currentUser = [REMApplicationContext instance].currentUser;
    REMCustomerModel *currentCustomer = [REMApplicationContext instance].currentCustomer;
    
    [currentUser kill];
    [currentCustomer kill];
    currentUser = nil;
    currentCustomer = nil;
    UINavigationController *nav=(UINavigationController *)self.parentViewController;
    [nav dismissViewControllerAnimated:YES completion:^(void){
        [self.parentNavigationController popToRootViewControllerAnimated:YES];
        [self.splashScreenController showLoginView:NO];
        
        [REMStorage clearSessionStorage];
    }];
}

- (void)needReload{
    [self.tableView reloadData];
}

- (void) weiboSwitcherChanged:(UISwitch*)sender {
    BOOL isAuthed = [Weibo.weibo isAuthenticated];
    if (sender.on == NO && isAuthed) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"解除绑定新浪微博？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"放弃", @"解除绑定", nil];
        alertView.accessibilityIdentifier = @"weiboAccount";
        
        [alertView show];
    } else if (!isAuthed && sender.on == YES){
        [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
            NSString *message = nil;
            if (!error) {
                message = @"微博账户绑定成功";
            }
            else {
                message = [NSString stringWithFormat:@"微博账户绑定失败: %@", error];
                sender.on = NO;
            }
            [REMAlertHelper alert:message];
        }];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    if(indexPath.section == 3 && indexPath.row==0){
        [self logout];
        
    }
    else if(indexPath.section==1 && indexPath.row==1){
        [self performSegueWithIdentifier:@"settingCustomerDetailSegue" sender:self];
    }
    else if(indexPath.section == 1 && indexPath.row==0){
        [self performSegueWithIdentifier:@"settingCustomerSelectionSegue" sender:self];
    }
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"settingCustomerSelectionSegue"]==YES){
        REMSettingCustomerSelectionViewController *selectionVc= segue.destinationViewController;
        selectionVc.splashController=self.splashScreenController;
        selectionVc.parentNavigationController=self.parentNavigationController;
        selectionVc.settingController=self;
    }
}


@end
