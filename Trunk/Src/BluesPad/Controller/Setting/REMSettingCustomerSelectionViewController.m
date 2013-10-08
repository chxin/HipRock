//
//  REMSettingCustomerSelectionViewController.m
//  Blues
//
//  Created by tantan on 9/29/13.
//
//

#import "REMSettingCustomerSelectionViewController.h"
#import "REMApplicationContext.h"
#import "REMUserModel.h"
#import "REMCustomerModel.h"

@interface REMSettingCustomerSelectionViewController ()
@property (nonatomic) NSUInteger currentRow;
@end

@implementation REMSettingCustomerSelectionViewController

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
	// Do any additional setup after loading the view.
    self.currentRow= NSNotFound;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [REMApplicationContext instance].currentUser.customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId=@"customerCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    NSArray *customers=[REMApplicationContext instance].currentUser.customers;
    REMCustomerModel *model=customers[indexPath.row];
    cell.textLabel.text=model.name;
    NSString *currentName=[REMApplicationContext instance].currentCustomer.name;
    
    if([currentName isEqualToString:model.name]==YES && self.currentRow==NSNotFound){
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
    
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [cell setSelected:NO];
    [cell setHighlighted:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(self.currentRow!=indexPath.row && self.currentRow!=NSNotFound){
        NSIndexPath *old=[NSIndexPath indexPathForRow:self.currentRow inSection:0];
        cell=[tableView cellForRowAtIndexPath:old];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
    
    self.currentRow=indexPath.row;
    
    
}

@end
