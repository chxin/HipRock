//
//  REMSettingCustomerDetailViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 9/29/13.
//
//

#import "REMSettingCustomerDetailViewController.h"
#import "REMTimeHelper.h"
#import "REMAdministratorModel.h"
#import "REMSettingCustomerDetailAdminViewController.h"

@interface REMSettingCustomerDetailViewController ()

@end

@implementation REMSettingCustomerDetailViewController

static NSString * cellId=@"customerCell";

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
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    REMCustomerModel *customer = [REMApplicationContext instance].currentCustomer;
    
    
    if(indexPath.row==0){
        cell.textLabel.text=@"名称";
        cell.detailTextLabel.text=customer.name;
    }
    else if(indexPath.row==1){
        cell.textLabel.text=@"编码";
        cell.detailTextLabel.text=customer.code;
    }
    else if(indexPath.row==2){
        cell.textLabel.text=@"Logo";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else if(indexPath.row==3){
        cell.textLabel.text=@"地址";
        cell.detailTextLabel.text=customer.address;
    }
    else if(indexPath.row==4){
        cell.textLabel.text=@"负责人";
        cell.detailTextLabel.text=customer.manager;
    }
    else if(indexPath.row==5){
        cell.textLabel.text=@"负责人电话";
        cell.detailTextLabel.text=customer.telephone;
    }
    else if(indexPath.row==6){
        cell.textLabel.text=@"负责人电子邮箱";
        cell.detailTextLabel.text=customer.email;
    }
    else if(indexPath.row==7){
        cell.textLabel.text=@"运营时间";
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        cell.detailTextLabel.text=[formatter stringFromDate:customer.startTime];
    }
    else if(indexPath.row==8){
        cell.textLabel.text=@"客户管理员";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if(customer.administratorArray.count==1){
            REMAdministratorModel *model=customer.administratorArray[0];
            cell.detailTextLabel.text=model.realName;
        }
        else if(customer.administratorArray.count==2){
            REMAdministratorModel *model=customer.administratorArray[0];
            REMAdministratorModel *model1=customer.administratorArray[1];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@和%@",model.realName,model1.realName];
        }
        else if (customer.administratorArray.count>2){
            REMAdministratorModel *model=customer.administratorArray[0];
            REMAdministratorModel *model1=customer.administratorArray[1];
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@和%@等%d人",model.realName,model1.realName,customer.administratorArray.count];
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    if(indexPath.row==2){
        [self performSegueWithIdentifier:@"settingCustomerDetailLogoSegue" sender:self];
    }
    else if(indexPath.row==8){
        [self performSegueWithIdentifier:@"settingCustomerDetailAdminSegue" sender:self];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
