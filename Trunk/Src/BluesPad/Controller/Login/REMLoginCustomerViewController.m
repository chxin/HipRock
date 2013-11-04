//
//  REMLoginCustomerViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/25/13.
//
//

#import "REMLoginCustomerViewController.h"
#import "REMCommonHeaders.h"

@interface REMLoginCustomerViewController ()

@property (nonatomic,strong) NSArray *customers;

@end

@implementation REMLoginCustomerViewController

static NSString *CellIdentifier = @"loginCustomerCell";

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.customers = (NSArray *)(REMAppCurrentUser.customers);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    REMCustomerModel *customer = self.customers[indexPath.row];
    cell.textLabel.text = customer.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    REMCustomerModel *selectedCustomer=nil;
    
    for(REMCustomerModel *customer in self.customers){
        if([customer.name isEqualToString:cell.textLabel.text]){
            selectedCustomer = customer;
            break;
        }
    }
    
    if(selectedCustomer != nil){
        [REMAppContext setCurrentCustomer:selectedCustomer];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self.loginPageController loginSuccess];
        }];
    }
}


/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.loginPageController.loginButton stopIndicator];
    }];
}
@end
