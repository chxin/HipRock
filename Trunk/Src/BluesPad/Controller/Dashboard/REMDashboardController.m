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

@property (nonatomic,weak) UIImageView *arrow;


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

- (void)cancelAllRequest{
    [REMDataAccessor cancelAccess:[self groupName]];
}

- (void)loadView{
    self.tableView= [[REMDashboardView alloc]initWithFrame:self.viewFrame style:UITableViewStyleGrouped];
     
    self.view=self.tableView;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    [self.tableView registerClass:[REMDashboardCellViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.sectionFooterHeight=34;
    
    //NSLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, -40, 300, 17)];
    label.text=NSLocalizedString(@"Dashboard_PullDownShowGeneral", @"");//@"下拉返回概览能耗信息";
    label.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:label.frame.size.height];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [self.tableView addSubview:label];
    self.buildingLabel=label;
    
    CGRect imgFrame=CGRectMake(168, -40-8, 30, 30);
    UIImage *image=[UIImage imageNamed:@"Down"];
    UIImageView *arrow=[[UIImageView alloc]initWithImage:image];
    [arrow setFrame:imgFrame];
    [self.tableView addSubview:arrow];
    self.arrow=arrow;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

static NSString *dashboardGroupName=@"building-dashboard-%@";

#define kDashboardSwitchLabelTop -65

- (NSString *)groupName{
    return [NSString stringWithFormat:dashboardGroupName,self.buildingInfo.building.buildingId];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES && scrollView.contentOffset.y<kDashboardSwitchLabelTop){
        //self.isHiding=YES;
        
        [REMDataAccessor cancelAccess:[self groupName]];
        [self.imageView gotoBuildingInfo];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // NSLog(@"table scroll:%@",NSStringFromCGPoint(scrollView.contentOffset));
    //if(self.isHiding==YES)return;

    if(scrollView.contentOffset.y<kDashboardSwitchLabelTop){
        self.buildingLabel.text=NSLocalizedString(@"Building_ReleaseSwitchView", @"");//@"松开以显示";
        [UIView animateWithDuration:0.2 animations:^(void){
            //self.arrow.layer.transform=CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            self.arrow.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else {
        self.buildingLabel.text=NSLocalizedString(@"Dashboard_PullDownShowGeneral", @"");// @"下拉返回概览能耗信息";
        [UIView animateWithDuration:0.2 animations:^(void){
            //self.arrow.layer.transform=CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            self.arrow.transform=CGAffineTransformMakeRotation(M_PI*2);
        }];
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
    CGFloat titleHeight=49;
    if(obj.shareInfo!=nil){
        titleHeight+=20;
    }
    CGFloat cellMargin=8;
    CGFloat cellHeight=157; //cell height
    double n=obj.widgets.count/4.0f;
    float row= ceil(n);
    int margin=row>0?row-1:0;
    return titleHeight+row*cellHeight+cellMargin*margin;
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
