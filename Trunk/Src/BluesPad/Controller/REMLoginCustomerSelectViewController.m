//
//  REMCustomerSelectViewController.m
//  Blues
//
//  Created by zhangfeng on 7/3/13.
//
//

#import "REMLoginCustomerSelectViewController.h"
#import "REMAppDelegate.h"
#import "REMCommonHeaders.h"

@interface REMLoginCustomerSelectViewController ()

@end

@implementation REMLoginCustomerSelectViewController


static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.customers =  [REMApplicationContext instance].currentUser.customers;//[[REMAppDelegate app].currentUser valueForKey:@"Customers"];
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
    return self.customers.count;//[REMAppDelegate app].currentUser;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *customerForIndexPath = (NSDictionary *)[self.customers objectAtIndex:indexPath.row];
    
    if([REMApplicationContext instance].currentCustomer.customerId == [customerForIndexPath valueForKey:@"Id"])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [cell.textLabel setText:[customerForIndexPath valueForKey:@"Name"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set check mark
    [[tableView visibleCells] enumerateObjectsUsingBlock:^(id object, NSUInteger i, BOOL *stop){ ((UITableViewCell *)object).accessoryType = UITableViewCellAccessoryNone; }];
    [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //set current customer
    NSDictionary *selectedCustomer = (NSDictionary *)[self.customers objectAtIndex:indexPath.row];
    //[[REMAppDelegate app] setCurrentCustomer:selectedCustomer];
    [[REMApplicationContext instance] setCurrentCustomer:selectedCustomer];
    
    //set button text
    [self.customerViewController setSelectedCustomerName:[selectedCustomer valueForKey:@"Name"]];
    [self.popoverViewController dismissPopoverAnimated:YES];
}

@end
