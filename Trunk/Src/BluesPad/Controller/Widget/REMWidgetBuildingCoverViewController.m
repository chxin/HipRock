/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetBuildingCoverViewController.m
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetBuildingCoverViewController.h"

@interface REMWidgetBuildingCoverViewController ()

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@end

@implementation REMWidgetBuildingCoverViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"widgetListCell"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"widgetListCell" forIndexPath:indexPath];
    
    NSDictionary *dic=self.data[indexPath.section];
    if (indexPath.row==0) {
        cell.textLabel.text=dic[@"firstName"];
        cell.textLabel.tag=[dic[@"firstId"] integerValue];
    }
    else{
        cell.textLabel.text=dic[@"secondName"];
        cell.textLabel.tag=[dic[@"secondId"] integerValue];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic=self.data[section];
    return dic[@"name"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section!=self.currentIndexPath.section && indexPath.row!=indexPath.row) {
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
