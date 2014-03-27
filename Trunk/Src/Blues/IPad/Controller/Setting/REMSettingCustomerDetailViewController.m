/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingCustomerDetailViewController.m
 * Created      : tantan on 9/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMSettingCustomerDetailViewController.h"
#import "REMTimeHelper.h"
#import "REMSettingCustomerDetailAdminViewController.h"
#import "REMManagedAdministratorModel.h"

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
    //return 9;
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    REMManagedCustomerModel *customer = REMAppContext.currentCustomer;
    
    
    if(indexPath.row==0){
        cell.textLabel.text= REMIPadLocalizedString(@"Setting_DetailName"); //@"名称";
        cell.detailTextLabel.text=customer.name;
    }
    else if(indexPath.row==1){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailCode"); //@"编码";
        cell.detailTextLabel.text=customer.code;
    }
//    else if(indexPath.row==2){
//        cell.textLabel.text=@"Logo";
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    }
    else if(indexPath.row==2){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailAddress"); //@"地址";
        cell.detailTextLabel.text=customer.address;
    }
    else if(indexPath.row==3){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailAdmin"); //@"负责人";
        cell.detailTextLabel.text=customer.manager;
    }
    else if(indexPath.row==4){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailAdminTelephone"); //@"负责人电话";
        cell.detailTextLabel.text=customer.telephone;
    }
    else if(indexPath.row==5){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailAdminEmail"); //@"负责人电子邮箱";
        cell.detailTextLabel.text=customer.email;
    }
    else if(indexPath.row==6){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailOperationDate"); //@"运营时间";
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        cell.detailTextLabel.text=[formatter stringFromDate:customer.startTime];
    }
    else if(indexPath.row==7){
        cell.textLabel.text=REMIPadLocalizedString(@"Setting_DetailCustomerAdmin"); //@"客户管理员";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if(customer.administrators.count==1){
            REMManagedAdministratorModel *model=customer.administrators.allObjects[0];
            cell.detailTextLabel.text=model.realName;
        }
        else if(customer.administrators.count==2){
            REMManagedAdministratorModel *model=customer.administrators.allObjects[0];
            REMManagedAdministratorModel *model1=customer.administrators.allObjects[1];
            NSString *str=REMIPadLocalizedString(@"Setting_DetailCustomerAdminTwoName"); //@"%@和%@"
            cell.detailTextLabel.text=[NSString stringWithFormat:str,model.realName,model1.realName];
        }
        else if (customer.administrators.count>2){
            REMManagedAdministratorModel *model=customer.administrators.allObjects[0];
            REMManagedAdministratorModel *model1=customer.administrators.allObjects[1];
            NSString *str=REMIPadLocalizedString(@"Setting_DetailCustomerAdminThreeName"); //%@和%@等%d人
            cell.detailTextLabel.text=[NSString stringWithFormat:str,model.realName,model1.realName,customer.administrators.count];
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
//    if(indexPath.row==2){
//        [self performSegueWithIdentifier:@"settingCustomerDetailLogoSegue" sender:self];
//    }
//    else if(indexPath.row==8){
//        [self performSegueWithIdentifier:@"settingCustomerDetailAdminSegue" sender:self];
//    }
    if (indexPath.row==7) {
        [self performSegueWithIdentifier:@"settingCustomerDetailAdminSegue" sender:self];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
