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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView* myView = (UITableView*)self.view;
    [myView  registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 2;
    if (section == 1) return 1;
    if (section == 2) return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // weibo account binding cell
    if (indexPath.section == 1 && indexPath.item == 0) {
        [[cell textLabel]setText:@"绑定新浪微博"];
        UISwitch* s = [[UISwitch alloc]initWithFrame:CGRectMake(405, 12, 79, 27)];
        s.on = [Weibo.weibo isAuthenticated];
        [s addTarget:self action:@selector(weiboSwitcherChanged:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:s];
    }
    //logout cell
    if(indexPath.section == 3 && indexPath.item == 0){
    }
    return cell;
}

- (void) weiboSwitcherChanged:(UISwitch*)sender {
    BOOL isAuthed = [Weibo.weibo isAuthenticated];
    if (sender.on == NO && isAuthed) {
        [[WeiboAccounts shared]signOut];
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
}

@end
