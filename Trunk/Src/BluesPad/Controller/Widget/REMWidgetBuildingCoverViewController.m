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
    for (int i=0; i<self.data.count; ++i) {
        NSDictionary *dic=self.data[i];
        NSInteger section=i+1;
        NSInteger row=NSNotFound;
        if ([dic objectForKey:@"firstSelected"]!=nil) {
            row=0;
        }
        else if([dic objectForKey:@"secondSelected"]!=nil){
            row=1;
        }
        if (row != NSNotFound) {
            self.currentIndexPath=[NSIndexPath indexPathForRow:row inSection:section];
            break;
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"widgetListCell" forIndexPath:indexPath];
    
    NSDictionary *dic=self.data[indexPath.section-1];
    if (indexPath.row==0) {
        cell.textLabel.text=dic[@"firstName"];
        cell.textLabel.tag=[dic[@"firstId"] integerValue];
    }
    else{
        cell.textLabel.text=dic[@"secondName"];
        cell.textLabel.tag=[dic[@"secondId"] integerValue];
    }
    if (self.currentIndexPath.section == indexPath.section && self.currentIndexPath.row==indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return NSLocalizedString(@"Building_WidgetRelationTitle", @"");
    }
    NSDictionary *dic=self.data[section-1];
    return dic[@"name"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section!=self.currentIndexPath.section && indexPath.row!=indexPath.row) {
        UITableViewCell *oldCell=[tableView cellForRowAtIndexPath:self.currentIndexPath];
        [oldCell setSelected:NO];
        [oldCell setHighlighted:NO];
        [oldCell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        self.currentIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == self.data.count) {
        return NSLocalizedString(@"Building_WidgetRelationInfo", @"");
    }
    return @"";
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.popController dismissPopoverAnimated:YES];
}

- (IBAction)okButtonClicked:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
