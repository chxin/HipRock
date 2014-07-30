/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingCoverWidgetViewController.m
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingCoverWidgetViewController.h"
#import "REMPinToBuildingCoverHelper.h"

@interface REMBuildingCoverWidgetViewController ()

@property (nonatomic,strong) NSIndexPath *currentIndexPath;
@property (nonatomic,strong) REMPinToBuildingCoverHelper *pinHelper;

@end

@implementation REMBuildingCoverWidgetViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.currentIndexPath=nil;
        self.isRequesting=NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = REMIPadLocalizedString(@"Building_WidgetRelationViewTitle");
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Done") style:UIBarButtonItemStylePlain target:self action:@selector(okButtonClicked:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"widgetCell"];
    if ([self.selectedWidgetId isEqualToNumber:@(-1)]==YES) {
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else if ([self.selectedWidgetId isEqualToNumber:@(-2)]==YES){
        self.currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    else{
        NSUInteger section=NSNotFound;
        NSUInteger row=NSNotFound;
        for (int i=0; i<self.dashboardArray.count; ++i) {
            REMManagedWidgetModel *dashboard=self.dashboardArray[i];
            if ([dashboard.id isEqualToNumber:self.selectedDashboardId]== YES) {
                section=i+2;
                NSArray *widgetList=self.widgetDic[dashboard.id];
                for (int j=0; j<widgetList.count;j++) {
                    REMManagedWidgetModel *widget=widgetList[j];
                    if ([widget.id isEqualToNumber:self.selectedWidgetId]==YES) {
                        row=j;
                        break;
                    }
                }
                if (section!=NSNotFound) {
                    break;
                }
            }
        }
        self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }
}

-(void)cancelPressed
{
}


- (void)viewDidAppear:(BOOL)animated{
    CGFloat height=700;
    if (self.tableView.contentSize.height<700) {
        height=self.tableView.contentSize.height+30;
    }
    [self.popController setPopoverContentSize:CGSizeMake(350, height) animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSUInteger counter=2;
    counter+=self.dashboardArray.count;
    return counter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }
    else if (section == 1) {
        return 2;
    }
    else{
        REMManagedDashboardModel *dashboard= self.dashboardArray[section-2];
        NSArray *widgetList=self.widgetDic[dashboard.id];
        return widgetList.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return REMIPadLocalizedString(@"Building_WidgetRelationTitle");
    }
    else if(section == 1){
//        return [NSString stringWithFormat:REMIPadLocalizedString(@"Building_WidgetRelationCommodityTitle"),self.commodityInfo.comment];
        NSString *commodityKey = REMCommodities[self.commodityInfo.id];
        return [NSString stringWithFormat:REMIPadLocalizedString(@"Building_WidgetRelationCommodityTitle"),REMIPadLocalizedString(commodityKey)];
    }
    else{
        REMManagedDashboardModel *dashboard= self.dashboardArray[section-2];
        return dashboard.name;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (REMISIOS7) {
        if (section==0) {
            return 40;
        }
        if (section==1) {
            return 16;
        }
    }
    else{
        if (section==0) {
            return 40;
        }

    }
    
    return 28;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0;
    }
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 22;
//    }
//    return 20;
//}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == self.dashboardArray.count+1) {
        return REMIPadLocalizedString(@"Building_WidgetRelationInfo");
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"widgetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.font = [REMFont defaultFontSystemSize];
    
    if (self.currentIndexPath.section == indexPath.section && self.currentIndexPath.row == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if (indexPath.section==1) {
        NSString *commodityKey = REMCommodities[self.commodityInfo.id];
        if (indexPath.row==0) {
            cell.textLabel.text=[NSString stringWithFormat:REMIPadLocalizedString(@"Building_EnergyUsageByAreaByMonth"),REMIPadLocalizedString(commodityKey)];
        }
        else{
            cell.textLabel.text=[NSString stringWithFormat:REMIPadLocalizedString(@"Building_EnergyUsageByCommodity"),REMIPadLocalizedString(commodityKey)];
        }
    }
    else{
        REMManagedDashboardModel *dashboard= self.dashboardArray[indexPath.section-2];
        NSArray *widgetList=self.widgetDic[dashboard.id];
        REMManagedWidgetModel *widgetInfo=widgetList[indexPath.row];
        cell.textLabel.text=widgetInfo.name;
    }
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [cell setSelected:NO];
    [cell setHighlighted:NO];
    [tableView deselectRowAtIndexPath:self.currentIndexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==self.currentIndexPath.section && indexPath.row == self.currentIndexPath.row) {
        return;
    }
    
    UITableViewCell *oldCell=[tableView cellForRowAtIndexPath:self.currentIndexPath];
    [oldCell setSelected:NO];
    [oldCell setAccessoryType:UITableViewCellAccessoryNone];
    self.currentIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
}


- (IBAction)okButtonClicked:(id)sender {
//    REMBuildingCoverWidgetRelationModel *model= [[REMBuildingCoverWidgetRelationModel alloc]init];
//    model.commodityId=self.commodityInfo.id;
//    model.buildingId=self.buildingInfo.id;

    NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
    [modelDic setObject:self.commodityInfo.id forKey:@"CommodityId"];
    [modelDic setObject:self.buildingInfo.id forKey:@"HierarchyId"];
    if (self.currentIndexPath.section==1) {
        
        NSNumber *widgetId;
        if (self.currentIndexPath.row==0) {
            widgetId=@(-1);
        }
        else{
            widgetId=@(-2);
        }
        [modelDic setObject:widgetId forKey:@"WidgetId"];
        [modelDic setObject:@(-1) forKey:@"DashboardId"];
//        model.widgetId=widgetId;
//        model.dashboardId=@(-1);
    }
    NSString *widgetName=nil;
    if (self.currentIndexPath.section!=1) {
        REMManagedWidgetModel *dashboard=self.dashboardArray[self.currentIndexPath.section-2];
        NSArray *widgetList=self.widgetDic[dashboard.id];
        REMManagedWidgetModel *widget=widgetList[self.currentIndexPath.row];
//        model.dashboardId=dashboard.id;
//        model.widgetId=widget.id;
        [modelDic setObject:widget.id forKey:@"WidgetId"];
        [modelDic setObject:dashboard.id forKey:@"DashboardId"];

        widgetName=widget.name;
    }
    
    if ([self.selectedDashboardId isEqualToNumber:modelDic[@"DashboardId"]]==YES &&
        [self.selectedWidgetId isEqualToNumber:modelDic[@"WidgetId"]]==YES) {
        [self cancelButtonClicked:nil];
        return;
    }
    
    REMManagedCustomerModel *customer=REMAppContext.currentCustomer;
//    NSDictionary *modelDic=@{
//                             @"DashboardId":model.dashboardId,
//                             @"HierarchyId":model.buildingId,
//                             @"CommodityId":model.commodityId,
//                             @"Position":@((NSUInteger)self.position)
//                             };
//    NSMutableDictionary *newDic = [modelDic mutableCopy];
//    if (model.widgetId!=nil) {
//        [newDic setObject:model.widgetId forKey:@"WidgetId"];
//    }
//    ;
    [modelDic setObject:@((NSUInteger)self.position) forKey:@"Position"];
    self.isRequesting=YES;
    REMPinToBuildingCoverHelper *helper=[[REMPinToBuildingCoverHelper alloc]init];
    helper.mainNavigationController=(REMMainNavigationController *)self.commodityController.parentViewController.parentViewController.parentViewController.navigationController;
    helper.widgetName=widgetName;
    self.pinHelper=helper;
    [helper pinToBuildingCover:@{@"relationList":@[modelDic],@"buildingId":modelDic[@"HierarchyId"],@"customerId":customer.id} withBuildingInfo:self.buildingInfo withCallback:^(REMPinToBuildingCoverStatus status){
        if (status == REMPinToBuildingCoverStatusSuccess) {
            self.pinHelper=nil;
            [self.commodityController updateChartController];
        }
    }];
    [self cancelButtonClicked:nil];
    
}
- (IBAction)cancelButtonClicked:(id)sender {
    [self.popController dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
