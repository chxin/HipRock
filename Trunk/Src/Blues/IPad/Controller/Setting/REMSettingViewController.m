/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingSettingViewController.m
 * Created      : Zilong-Oscar.Xu on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMSettingViewController.h"
#import "Weibo.h"
#import "WeiboAccounts.h"
#import "REMAlertHelper.h"
#import "REMSettingCustomerSelectionViewController.h"
#import "REMUpdateAllManager.h"

@interface REMSettingViewController ()

@property (nonatomic) BOOL isLoggingOut;
@property (nonatomic,strong) AFHTTPRequestOperation *weiboNetworkValidateOperation;
@property (nonatomic,weak) UIBarButtonItem *doneButton;


@end

@implementation REMSettingViewController

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
        self.modalInPopover = YES;
        self.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.backBarButtonItem=nil;
    self.isLoggingOut=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController=(UINavigationController *)self.parentViewController;
    self.isLoggingOut=NO;
    
    self.title = REMIPadLocalizedString(@"Setting_SettingViewTitle");
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] init];
    [button setTitle:REMIPadLocalizedString(@"Common_Done")];
    
    self.navigationController.navigationBar.topItem.rightBarButtonItem = button;
    self.doneButton = button;
    self.doneButton.target = self;
    self.doneButton.action = @selector(doneButtonPressed);
}

-(void)doneButtonPressed
{
    [self.weiboNetworkValidateOperation cancel];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.weiboNetworkValidateOperation cancel];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 4;
    if (section == 1) return 1;
    if (section == 2) return 3;
    if (section == 3) return 1;
    if (section == 4) return 1;
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    REMApplicationContext *context=REMAppContext;
    // weibo account binding cell
    if (indexPath.section == 1 && indexPath.item == 0) {
        [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_BindWeibo")]; //绑定新浪微博
        cell.detailTextLabel.text=@"";
        UISwitch *switcher= [[UISwitch alloc]initWithFrame:CGRectZero];
        cell.accessoryView=switcher;
        switcher.on = [Weibo.weibo isAuthenticated];
        [switcher addTarget:self action:@selector(weiboSwitcherChanged:) forControlEvents:UIControlEventValueChanged];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:switcher];
        self.weiboAccoutSwitcher=switcher;
    }
    //logout cell
    else if(indexPath.section==0){
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(indexPath.row==0){
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_UserName")]; //显示名称
            
            NSString *name=context.currentUser.realname;
            
            [cell.detailTextLabel setText:name];
        }
        else if(indexPath.row==1){
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_EMOPID")];//能源管理开发平台ID
            NSString *name1=context.currentUser.name;
            if ([context.currentUser.isDemo boolValue]) {
                name1=@"Demo";
            }
            [cell.detailTextLabel setText:name1];
        }
        else if(indexPath.row==2){
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_CurrentCustomer")];//当前客户
            NSString *name=REMAppContext.currentCustomer.name;
            [cell.detailTextLabel setText:name];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_CustomerInfo")];//客户信息
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section==2){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(indexPath.row==0){
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_QRCode")];//QR code
            UIImageView *codeIcon = [[UIImageView alloc] initWithImage:REMIMG_QRCodeIcon];
            codeIcon.frame = CGRectMake(0, 0, 32, 32);
            codeIcon.translatesAutoresizingMaskIntoConstraints = NO;
            
            [cell.contentView addSubview:codeIcon];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:codeIcon attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:codeIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
            
            //cell.accessoryView = [[UIImageView alloc] initWithImage:REMIMG_QDCode_EMOP];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row==1){
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_ContactUs")];//cotact
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            [[cell textLabel]setText:REMIPadLocalizedString(@"Setting_About")];//关于云能效
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if(indexPath.section==4 && indexPath.row==0 ){
        UITableViewCell *cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell1"];
        //[[cell textLabel]setText:@"退出登录"];
        cell1.textLabel.text=REMIPadLocalizedString(@"Setting_Logout");//@"退出登录";
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
    else if(indexPath.section==3 && indexPath.row==0){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_UpdateAll"); //@"更新全部数据";
        cell.textLabel.textColor=[REMColor colorByHexString:@"#37ab3c"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row==2){
        [self performSegueWithIdentifier:@"settingCustomerDetailSegue" sender:self];
    }
    else if(indexPath.section==2 && indexPath.row==2){
        [self performSegueWithIdentifier:@"settingAboutSegue" sender:self];
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
        if(buttonIndex==1){
            [self logoutAndClearCache];
        }
        else{
            self.isLoggingOut=NO;
        }
    }
}

- (void)logout{
    //您要退出当前账号登录吗?
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:REMIPadLocalizedString(@"Setting_AreYouSureLogout") delegate:self cancelButtonTitle:REMIPadLocalizedString(@"Common_Giveup") otherButtonTitles:REMIPadLocalizedString(@"Common_Quit"), nil];
    alert.cancelButtonIndex=1;
    
    [alert show];
}

-(void)logoutAndClearCache
{
    UINavigationController *nav=(UINavigationController *)self.parentViewController;
    REMMainNavigationController *mainController=(REMMainNavigationController *)nav.presentingViewController;
    
    [mainController dismissViewControllerAnimated:YES completion:^(void){
        [mainController logout];
    }];
}

- (void)needReload{
    [self.tableView reloadData];
}

- (void) weiboSwitcherChanged:(UISwitch*)sender {
    BOOL isAuthed = [Weibo.weibo isAuthenticated];
    if (sender.on == NO && isAuthed) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:REMIPadLocalizedString(@"Weibo_AccountUnbindingConfirm") delegate:self cancelButtonTitle:nil otherButtonTitles:REMIPadLocalizedString(@"Weibo_AccountUnbindingNOButton"), REMIPadLocalizedString(@"Weibo_AccountUnbindingYESButton"), nil];
        alertView.accessibilityIdentifier = @"weiboAccount";
        
        [alertView show];
    } else if (!isAuthed && sender.on == YES){
        [sender setEnabled:NO];
        
        self.weiboNetworkValidateOperation = [REMAppContext.sharedRequestOperationManager HEAD:@"http://api.weibo.com" parameters:nil success:^(AFHTTPRequestOperation *operation) {
            [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
                NSString *message = nil;
                if (!error) {
                    message = REMIPadLocalizedString(@"Weibo_AccountBindingSuccess");
                }
                else {
                    message = [NSString stringWithFormat:REMIPadLocalizedString(@"Weibo_AccountBindingFail"), error];
                    sender.on = NO;
                }
                [REMAlertHelper alert:message];
            }];
            [sender setEnabled:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(error.code != -999){
                [REMAlertHelper alert:REMIPadLocalizedString(@"Weibo_NONetwork")];
            }
            [sender setEnabled:YES];
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 4 && indexPath.row==0){
        if (self.isLoggingOut==NO) {
            self.isLoggingOut=YES;
            [self logout];
        }
        
        
    }
    else if(indexPath.section==0 && indexPath.row==3){
        [self performSegueWithIdentifier:@"settingCustomerDetailSegue" sender:self];
    }
    else if(indexPath.section == 0 && indexPath.row==2){
        [self performSegueWithIdentifier:@"settingCustomerSelectionSegue" sender:self];
    }
    else if(indexPath.section==2 && indexPath.row==0){ //qr code
        [self performSegueWithIdentifier:@"settingQuickResponseCodeSegue" sender:self];
    }
    else if(indexPath.section==2 && indexPath.row==1){ //contact
        [self performSegueWithIdentifier:@"settingContactSegue" sender:self];
    }
    else if(indexPath.section==2 && indexPath.row==2){ //about
        [self performSegueWithIdentifier:@"settingAboutSegue" sender:self];
    }
    else if(indexPath.section==3 && indexPath.row==0){
        __weak REMUpdateAllManager *manager=[REMUpdateAllManager defaultManager];
        manager.canCancel=YES;
        manager.updateSource=REMCustomerUserConcurrencySourceUpdate;
        manager.mainNavigationController=(REMMainNavigationController *)self.presentingViewController;
        
        [manager updateAllBuildingInfoWithAction:^(REMCustomerUserConcurrencyStatus status, NSArray *buildingInfoArray, REMDataAccessStatus errorStatus) {
            if (status == REMCustomerUserConcurrencyStatusSuccess) {
                REMMainNavigationController *mainController=(REMMainNavigationController *)self.presentingViewController;
                if (mainController!=nil) {
                    [mainController dismissViewControllerAnimated:YES completion:^(void){
                        [mainController presentInitialView];
                    }];
                }
                else{
                    [manager.mainNavigationController presentInitialView];
                }                
            }
        }];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"settingCustomerSelectionSegue"]==YES){
        REMSettingCustomerSelectionViewController *selectionVc= segue.destinationViewController;
//        selectionVc.customerArray = [REMAppContext.currentUser.customers.allObjects sortedArrayUsingComparator:^NSComparisonResult(REMManagedCustomerModel *c1, REMManagedCustomerModel *c2) {
//            return [c1.id compare:c2.id];
//        }];
        selectionVc.customerArray = REMAppContext.currentUser.customers.array;
        //selectionVc.splashController=self.splashScreenController;
        //selectionVc.parentNavigationController=self.mainNavigationController;
        selectionVc.settingController=self;
    }
}


@end
