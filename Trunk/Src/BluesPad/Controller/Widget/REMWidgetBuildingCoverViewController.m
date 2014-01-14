/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetBuildingCoverViewController.m
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetBuildingCoverViewController.h"
#import "REMPinToBuildingCoverHelper.h"
#import "REMBuildingCoverWidgetRelationModel.h"


@interface REMWidgetBuildingCoverViewController ()

@property (nonatomic,strong) NSMutableArray *currentSelectedArray;
@property (nonatomic,strong) NSMutableArray *selectedPathArray;
@end

@implementation REMWidgetBuildingCoverViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"widgetListCell"];
    self.currentSelectedArray = [NSMutableArray array];
    self.selectedPathArray=[NSMutableArray array];
    for (int i=0; i<self.data.count; ++i) {
        NSDictionary *dic=self.data[i];
        NSInteger section=i+1;
        NSInteger row=NSNotFound;
        if ([dic objectForKey:@"firstSelected"]!=nil) {
            row=0;
            NSIndexPath *path=[NSIndexPath indexPathForRow:row inSection:section];
            [self.selectedPathArray addObject:path];
            [self.currentSelectedArray addObject:path];
        }
        if([dic objectForKey:@"secondSelected"]!=nil){
            row=1;
            NSIndexPath *path=[NSIndexPath indexPathForRow:row inSection:section];
            [self.selectedPathArray addObject:path];
            [self.currentSelectedArray addObject:path];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    CGFloat height=700;
    if (self.tableView.contentSize.height<700) {
        height=self.tableView.contentSize.height;
    }
    [self.popController setPopoverContentSize:CGSizeMake(350, height) animated:YES];
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
    for (NSIndexPath *path in self.currentSelectedArray) {
        if (path.section == indexPath.section && path.row==indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
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
    
    for (NSIndexPath *path in self.currentSelectedArray) {
        if (path.section == indexPath.section && indexPath.row==path.row) {
            UITableViewCell *cell1=[tableView cellForRowAtIndexPath:path];
            [cell1 setAccessoryType:UITableViewCellAccessoryNone];
            [self.currentSelectedArray removeObject:path];
            return;
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    NSIndexPath *newPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [self.currentSelectedArray addObject:newPath];
    
    
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
    NSMutableArray *array=[NSMutableArray array];
    BOOL includeCurrent=NO;
    for (NSIndexPath *path in self.currentSelectedArray) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"HierarchyId"]=self.buildingInfo.building.buildingId;
        dic[@"WidgetId"]=self.detailController.widgetInfo.widgetId;
        dic[@"DashboardId"]=self.dashboardInfo.dashboardId;
        
        REMCommodityModel *commodity=self.buildingInfo.commodityArray[path.section-1];
        dic[@"CommodityId"]=commodity.commodityId;
        dic[@"Position"]= @((REMBuildingCoverWidgetPosition)path.row);
        
        [array addObject:dic];
    }
    for (NSIndexPath *path in self.selectedPathArray) {
        BOOL found=NO;
        for (NSIndexPath *current in self.currentSelectedArray) {
            if (current.section == path.section && current.row == path.row) {
                found=YES;
                break;
            }
        }
        if (found==NO) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            dic[@"HierarchyId"]=self.buildingInfo.building.buildingId;
            dic[@"WidgetId"]=self.detailController.widgetInfo.widgetId;
            dic[@"DashboardId"]=self.dashboardInfo.dashboardId;
            
            REMCommodityModel *commodity=self.buildingInfo.commodityArray[path.section-1];
            dic[@"CommodityId"]=commodity.commodityId;
            dic[@"Position"]= @(path.row-2);
            [array addObject:dic];
        }
        
    }
    self.isRequesting=YES;
    REMCustomerModel *customer=REMAppCurrentCustomer;
    REMPinToBuildingCoverHelper *helper=[[REMPinToBuildingCoverHelper alloc]init];
    helper.mainNavigationController=(REMMainNavigationController *)self.detailController.parentViewController.navigationController;
    helper.widgetName=self.detailController.widgetInfo.name;
    [helper pinToBuildingCover:@{@"relationList":array,@"buildingId":self.buildingInfo.building.buildingId,@"customerId":customer.customerId} withBuildingInfo:self.buildingInfo withCallback:^(REMPinToBuildingCoverStatus status){
        if (status == REMPinToBuildingCoverStatusSuccess) {
            [self.detailController updateBuildingCover];
        }
    }];
    [self cancelButtonClicked:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
