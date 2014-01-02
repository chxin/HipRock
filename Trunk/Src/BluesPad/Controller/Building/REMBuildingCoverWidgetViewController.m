/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingCoverWidgetViewController.m
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingCoverWidgetViewController.h"
#import "REMDashboardObj.h"


@interface REMBuildingCoverWidgetViewController ()

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@end

@implementation REMBuildingCoverWidgetViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.currentIndexPath=nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"widgetCell"];
    if ([self.selectedDashboardId isEqualToNumber:@(-1)]==YES) {
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
    else if ([self.selectedDashboardId isEqualToNumber:@(-2)]==YES){
        self.currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    else{
        self.currentIndexPath = [NSIndexPath indexPathForRow:[self.selectedWidgetId integerValue] inSection:[self.selectedDashboardId integerValue]];
    }
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
        REMDashboardObj *dashboard= self.dashboardArray[section-2];
        NSArray *widgetList=self.widgetDic[dashboard.dashboardId];
        return widgetList.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return NSLocalizedString(@"Building_WidgetRelationTitle", @"");
    }
    else if(section == 1){
        return [NSString stringWithFormat:NSLocalizedString(@"Building_WidgetRelationCommodityTitle", @""),self.commodityInfo.comment];
    }
    else{
        REMDashboardObj *dashboard= self.dashboardArray[section-2];
        return dashboard.name;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0) {
//        return 10;
//    }
//    return 44;
//}

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
        return NSLocalizedString(@"Building_WidgetRelationInfo", @"");
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
    if (self.currentIndexPath.section == indexPath.section && self.currentIndexPath.row == indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Building_EnergyUsageByCommodity", @""),self.commodityInfo.comment];
        }
        else{
            cell.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Building_EnergyUsageByAreaByMonth", @""),self.commodityInfo.comment];
        }
    }
    else{
        REMDashboardObj *dashboard= self.dashboardArray[indexPath.section-2];
        NSArray *widgetList=self.widgetDic[dashboard.dashboardId];
        REMWidgetObject *widgetInfo=widgetList[indexPath.row];
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
    UITableViewCell *oldCell=[tableView cellForRowAtIndexPath:self.currentIndexPath];
    [oldCell setSelected:NO];
    [oldCell setAccessoryType:UITableViewCellAccessoryNone];
    self.currentIndexPath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
}


- (IBAction)okButtonClicked:(id)sender {
    
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
