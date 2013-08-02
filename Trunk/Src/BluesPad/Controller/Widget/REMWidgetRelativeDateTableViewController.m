//
//  REMWidgetRelativeDateTableViewController.m
//  Blues
//
//  Created by 谭 坦 on 7/17/13.
//
//

#import "REMWidgetRelativeDateTableViewController.h"

@interface REMWidgetRelativeDateTableViewController ()
@property  (nonatomic,strong) NSArray *data;
@end

@implementation REMWidgetRelativeDateTableViewController

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
    
   NSArray *keys= @[@"Customize",
                    @"Last7Day",
                    @"Today",
                    @"Yesterday",
                    @"ThisWeek",
                    @"LastWeek",
                    @"ThisMonth",
                    @"LastMonth",
                    @"ThisYear",
                    @"LastYear"];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:keys.count];
    for (NSString *key in keys) {
                
        [arr addObject:@{@"value":key,@"text":[[REMEnergyConstants sharedRelativeDateDictionary] objectForKey:key]}];
    }
                    
                   
    
    
    
    self.data = arr ;
    
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
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"relativeDateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text=self.data[indexPath.item][@"text"];
    
    
    NSString *v = self.data[indexPath.item][@"value"];
        if([v isEqualToString:self.relativeDataString] ==YES)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
    
    
   
    
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
    //set check mark
    [[tableView visibleCells] enumerateObjectsUsingBlock:^(id object, NSUInteger i, BOOL *stop){ ((UITableViewCell *)object).accessoryType = UITableViewCellAccessoryNone; }];
    [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    NSString *str = self.data[indexPath.item][@"value"];
    
    NSString *text=self.data[indexPath.item][@"text"];
    [self.maxController setRelativeDate:str WithText:text ];
    
    
    [self.popController dismissPopoverAnimated:YES];
}

@end
