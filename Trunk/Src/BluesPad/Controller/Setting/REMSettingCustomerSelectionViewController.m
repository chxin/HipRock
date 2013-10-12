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
#import "REMCustomerSwitchHelper.h"

@interface REMSettingCustomerSelectionViewController ()
@property (nonatomic) NSUInteger currentRow;
@property (nonatomic,weak) UIAlertView *currentAlert;

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

- (void)switchCustomer:(UIBarButtonItem *)sender
{
    REMCustomerModel *customer= [REMApplicationContext instance].currentUser.customers[self.currentRow];
    if([customer.name isEqualToString:[REMApplicationContext instance].currentCustomer.name]==YES){
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在获取新客户的能源信息,请稍候..." delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
        self.currentAlert=alert;
        [self realSwitchCustomer:customer.customerId];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1){
        [REMCustomerSwitchHelper cancelSwitch];
    }
    else if(alertView.tag==3){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"当前客户已被解除关联,请退出系统后重新登录。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        alert.tag=4;
        [alert show];
    }
    else if(alertView.tag==4){
        [self.settingController logoutAndClearCache];
    }
    
}


- (void)realSwitchCustomer:(NSNumber *)customerId{
    [REMCustomerSwitchHelper switchCustomerById:customerId masker:nil action:^(REMCustomerSwitchStatus status,NSArray *customerArray){
        
        if (status == REMCustomerSwitchStatusSelectedCustomerDeleted) {
            [self.currentAlert dismissWithClickedButtonIndex:-1 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该客户已被解除关联,请重新选择客户。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            alert.tag=2;
            [alert show];
            
            [REMApplicationContext instance].currentUser.customers=customerArray;
            self.currentRow=NSNotFound;
            [self.tableView reloadData];
        }
        else if(status == REMCustomerSwitchStatusBothDeleted){
            [self.currentAlert dismissWithClickedButtonIndex:-1 animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"该客户已被解除关联,请重新选择客户。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            alert.tag=3;
            [alert show];

        }
        else{
            UINavigationController *nav=self.parentNavigationController;
            
            [REMApplicationContext instance].currentCustomer=[REMApplicationContext instance].currentUser.customers[self.currentRow];
            [[REMApplicationContext instance].currentCustomer save];
            [self.settingController needReload];
            
            [nav dismissViewControllerAnimated:YES completion:^{
                [self.settingController.mainNavigationController showInitialView:^(void){
                    [self.currentAlert dismissWithClickedButtonIndex:-1 animated:YES];
                    [self.settingController.mainNavigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
