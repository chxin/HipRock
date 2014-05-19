/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginCustomerTableViewController.m
 * Date Created : 张 锋 on 12/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginCustomerTableViewController.h"
#import "REMCommonHeaders.h"
#import "REMTrialCardController.h"
#import <QuartzCore/QuartzCore.h>

@interface REMLoginCustomerTableViewController ()


@end

@implementation REMLoginCustomerTableViewController

static NSString *CellIdentifier = @"loginCustomerCell";

-(void)loadView
{
    self.view = [self renderCustomerTableView:CGRectMake(0, 0, 540, 620)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (self.hideCancelButton!=YES) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    
    self.navigationItem.title = REMIPadLocalizedString(@"Login_CustomerSelectionTitle");
    if (self.customerArray==nil) {
//        self.customerArray= [REMAppContext.currentUser.customers.allObjects sortedArrayUsingComparator:^NSComparisonResult(REMManagedCustomerModel *c1, REMManagedCustomerModel *c2) {
//            return [c1.id compare:c2.id];
//        }];
        self.customerArray = REMAppContext.currentUser.customers.array;
    }
}

-(UITableView *)renderCustomerTableView:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    return tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if(self.delegate!=nil){
            [self.delegate customerSelectionTableViewdidDismissView];
        }
    }];
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
    return self.customerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    REMManagedCustomerModel *customer = self.customerArray[indexPath.row];
    cell.textLabel.text = customer.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    REMManagedCustomerModel *selectedCustomer=self.customerArray[indexPath.row];
//    
//    for(REMCustomerModel *customer in self.customers){
//        if([customer.name isEqualToString:cell.textLabel.text]){
//            selectedCustomer = customer;
//            break;
//        }
//    }
    
    if(selectedCustomer != nil){
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            if(self.delegate!=nil){
                [self.delegate customerSelectionTableView:tableView didSelectCustomer:selectedCustomer];
            }
        }];
    }
}

@synthesize customerArray;

- (void)customerSelectionTableViewUpdate{
    
}

@end
