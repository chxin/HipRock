//
//  REMFavoriteTableViewController.m
//  Blues
//
//  Created by TanTan on 7/8/13.
//
//

#import "REMFavoriteTableViewController.h"

@interface REMFavoriteTableViewController ()


@property (nonatomic,strong) NSArray *convertedDashboardList;
@property (nonatomic,strong) NSIndexPath *currentIndex;

@end

@implementation REMFavoriteTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) convertDashboard:(NSArray *)dashboardList
{
    
    
    REMLogVerbose(@"dashboards:%@",dashboardList);
    
    NSMutableArray *array= [[NSMutableArray alloc] initWithCapacity:dashboardList.count];
    
    for(NSDictionary *dic in dashboardList)
    {
        [array addObject:[[REMDashboardObj alloc]initWithDictionary:dic]];
    }
    
    self.convertedDashboardList=array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self convertDashboard:self.favoriteList];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:16/255.0f green:127/255.0f blue:66/255.0f alpha:1];
    //self.favoriteList=@[@"123",@"234",@"345"];
    
    //self.view.layer.borderColor = [UIColor blueColor].CGColor;
    //self.view.layer.borderWidth = 1;
    
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
    //return 3;
    return self.convertedDashboardList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1" forIndexPath:indexPath];
    
    // Configure the cell...
    REMDashboardObj *obj = (REMDashboardObj *)self.convertedDashboardList[indexPath.item];
    cell.textLabel.text= obj.name;
    //cell.textLabel.text=self.favoriteList[indexPath.item];
    return cell;
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
    //NSLog(@"parentViewController:%@",self.parentViewController.parentViewController);
    
    if(self.currentIndex!=nil && ([self.currentIndex isEqual:indexPath] == YES))
    {
            return;
    }
    [REMDataAccessor cancelAccess:@"Dashboard"];
    self.currentIndex=indexPath;
    NSDictionary *dashboardDic= self.favoriteList[indexPath.item];
    REMDashboardObj *dashboard= [[ REMDashboardObj alloc]initWithDictionary:dashboardDic];
    REMDashboardMainViewController *dashboardMain = (REMDashboardMainViewController *)self.parentViewController.parentViewController;
    [dashboardMain showDashboard:dashboard];
}

@end
