//
//  REMDashboardControllerViewController.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardController.h"
#import "REMDataAccessor.h"

@interface REMDashboardController ()

@property (nonatomic,weak) UILabel *buildingLabel;
@property  (nonatomic) BOOL isHiding;


@end

@implementation REMDashboardController


static NSString *cellId=@"dashboardcell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;  
}

- (void)loadView{
    self.tableView= [[REMDashboardView alloc]initWithFrame:self.viewFrame style:UITableViewStyleGrouped];
    self.view=self.tableView;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    [self.tableView registerClass:[REMDashboardCellViewCell class] forCellReuseIdentifier:cellId];
    
    
    //NSLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, -40, 300, 60)];
    label.text=@"下拉返回概览能耗信息";
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [self.tableView addSubview:label];
    self.buildingLabel=label;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

static NSString *dashboardGroupName=@"building-dashboard-%@";

- (NSString *)groupName{
    return [NSString stringWithFormat:dashboardGroupName,self.buildingInfo.building.buildingId];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES && scrollView.contentOffset.y<-80){
        self.isHiding=YES;
        
        [REMDataAccessor cancelAccess:[self groupName]];
        [self.imageView showBuildingInfo];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"table scroll:%@",NSStringFromCGPoint(scrollView.contentOffset));
    if(self.isHiding==YES)return;
    if(scrollView.contentOffset.y<-80){
        self.buildingLabel.text=@"松开以显示";
    }
    else {
        self.buildingLabel.text=@"下拉返回概览能耗信息";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dashboardArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    REMDashboardObj *obj= self.dashboardArray[indexPath.section];
    CGFloat titleHeight=60;
    if(obj.shareInfo!=nil){
        titleHeight+=20;
    }
    CGFloat cellMargin=10;
    CGFloat cellHeight=180;
    return titleHeight+(obj.widgets.count/4+1)*cellHeight+cellMargin*(obj.widgets.count/4);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    REMDashboardCellViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if(cell==nil){
        cell = [[REMDashboardCellViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    [cell initWidgetCollection:self.dashboardArray[indexPath.section] withGroupName:[self groupName]];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
