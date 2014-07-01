/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRelativeDateViewController.m
 * Created      : tantan on 10/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMRelativeDateViewController.h"

@interface REMRelativeDateViewController ()

@property (nonatomic) NSUInteger currentRow;
@property (nonatomic,strong) NSArray *dataKeys;
@property (nonatomic,strong) NSArray *dataValues;

@end

@implementation REMRelativeDateViewController

-(NSArray *)dataKeys
{
    return @[REMIPadLocalizedString(@"Common_Last7Day"),
             REMIPadLocalizedString(@"Common_Last30Days"),
             REMIPadLocalizedString(@"Common_Last12Months"),
             REMIPadLocalizedString(@"Common_Today"),
             REMIPadLocalizedString(@"Common_Yesterday"),
             REMIPadLocalizedString(@"Common_ThisWeek"),
             REMIPadLocalizedString(@"Common_LastWeek"),
             REMIPadLocalizedString(@"Common_ThisMonth"),
             REMIPadLocalizedString(@"Common_LastMonth"),
             REMIPadLocalizedString(@"Common_ThisYear"),
             REMIPadLocalizedString(@"Common_LastYear")
             ];
}
-(NSArray *)dataValues
{
    return @[@(REMRelativeTimeRangeTypeLast7Day),
             @(REMRelativeTimeRangeTypeLast30Day),
             @(REMRelativeTimeRangeTypeLast12Month),
             @(REMRelativeTimeRangeTypeToday),
             @(REMRelativeTimeRangeTypeYesterday),
             @(REMRelativeTimeRangeTypeThisWeek),
             @(REMRelativeTimeRangeTypeLastWeek),
             @(REMRelativeTimeRangeTypeThisMonth),
             @(REMRelativeTimeRangeTypeLastMonth),
             @(REMRelativeTimeRangeTypeThisYear),
             @(REMRelativeTimeRangeTypeLastYear)
             ];
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
    self.currentRow=NSNotFound;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"relativeCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = REMIPadLocalizedString(@"Widget_RelativeTimePickerViewTitle");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"relativeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if([self.dataValues[indexPath.row] shortValue] == (short)self.relativeDate && self.currentRow == NSNotFound){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        self.currentRow=indexPath.row;
    }
    else{
        if(self.currentRow!=NSNotFound && self.currentRow!=indexPath.row){
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        else{
            if(self.currentRow==indexPath.row){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                
            }
        }
    }
    
    cell.textLabel.text = self.dataKeys[indexPath.row];
    cell.tag = [self.dataValues[indexPath.row] shortValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [cell setSelected:NO];
    [cell setHighlighted:NO];
    [self.datePickerController setTimeRangeByDateRelative:cell.textLabel.text withTimeRange:(REMRelativeTimeRangeType)cell.tag];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.currentRow!=indexPath.row && self.currentRow!=NSNotFound){
        NSIndexPath *old=[NSIndexPath indexPathForRow:self.currentRow inSection:0];
        cell=[tableView cellForRowAtIndexPath:old];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
    
    self.currentRow=indexPath.row;
    
    [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
