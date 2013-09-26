//
//  REMDashboardControllerViewController.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardController.h"

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
    
	// Do any additional setup after loading the view.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES && scrollView.contentOffset.y<-65){
        self.isHiding=YES;
        [self.imageView showBuildingInfo];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"table scroll:%@",NSStringFromCGPoint(scrollView.contentOffset));
    if(self.isHiding==YES)return;
    if(scrollView.contentOffset.y<-65){
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    REMDashboardCellViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if(cell==nil){
        cell = [[REMDashboardCellViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    [cell initWidgetCollection];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
