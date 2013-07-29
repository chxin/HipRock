//
//  REMChartLegendTableViewController.m
//  Blues
//
//  Created by 张 锋 on 7/18/13.
//
//

#import "REMChartLegendTableViewController.h"
#import "REMWidgetMaxColumnViewController.h"

@interface REMChartLegendTableViewController ()


@end

@implementation REMChartLegendTableViewController

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
    return self.targetEnergyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"legendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell.textLabel setText:((REMTargetEnergyData *)self.targetEnergyData[indexPath.row]).target.name];
    
    REMEnergyTargetModel *target = ((REMTargetEnergyData *)self.targetEnergyData[indexPath.row]).target;
    
    if(self.chartController.hiddenTargets != nil && [self.chartController.hiddenTargets containsObject:target])
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    REMEnergyTargetModel *target = ((REMTargetEnergyData *)self.targetEnergyData[indexPath.row]).target;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(self.chartController.hiddenTargets == nil)
    {
        self.chartController.hiddenTargets = [[NSMutableArray alloc] initWithCapacity:self.targetEnergyData.count];
    }
    
    if([self.chartController.hiddenTargets containsObject:target])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [self.chartController.hiddenTargets removeObject:target];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.chartController.hiddenTargets addObject:target];
    }
    
    [self.chartController hidePlots];
    
    [self.popoverViewController dismissPopoverAnimated:YES];
}

@end
