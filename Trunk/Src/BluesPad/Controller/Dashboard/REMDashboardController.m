/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDashboardControllerViewController.m
 * Created      : tantan on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kDashboardDragTitleMargin, 300, kDashboardDragTitleSize)];
    label.text=NSLocalizedString(@"Dashboard_PullDownShowGeneral", @"");//@"下拉返回概览能耗信息";
    label.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:label.frame.size.height];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [self.tableView addSubview:label];
    self.buildingLabel=label;
    
    CGRect imgFrame=CGRectMake(168, kDashboardDragTitleMargin-8, 30, 30);
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
    CGFloat titleHeight=kDashboardTitleSize+kDashboardTitleBottomMargin;
    if(obj.shareInfo!=nil){
        titleHeight+=kDashboardShareSize+kDashboardTitleShareMargin;
    }
    CGFloat cellMargin=kDashboardWidgetInnerVerticalMargin;
    CGFloat cellHeight=kDashboardWidgetHeight; //cell height
    double n=obj.widgets.count/4.0f;
    float row= ceil(n);
    int margin=row>0?row-1:0;
    return titleHeight+row*cellHeight+cellMargin*margin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kDashboardInnerMargin;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    REMDashboardCellViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath ];
   
    REMWidgetCollectionViewController *current;
    for (REMWidgetCollectionViewController *vc in self.childViewControllers) {
        if(vc.currentDashboardIndex == indexPath.section){
            //NSLog(@"reuse cell:%@",indexPath);
            current=vc;
        }
    }
    if(current!=nil){
        if(current.view == cell.subviews.lastObject){
            return cell;
        }
        else{
            if(cell.contentView.subviews.count>0){
                for (UIView *v in cell.contentView.subviews) {
                    [v removeFromSuperview];
                }
                REMWidgetCollectionViewController *old= self.childViewControllers[cell.tag];
                old.view=nil;
            }
        }
    }
    else{
        if(cell.contentView.subviews.count>0){
            for (UIView *v in cell.contentView.subviews) {
                [v removeFromSuperview];
            }
            REMWidgetCollectionViewController *old= self.childViewControllers[cell.tag];
            old.view=nil;
           
        }
        REMWidgetCollectionViewController *widgetCollectionController = [[REMWidgetCollectionViewController alloc]initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        
        widgetCollectionController.currentDashboardIndex=indexPath.section;
        widgetCollectionController.dashboardInfo=self.dashboardArray[indexPath.section];
        widgetCollectionController.groupName=[self groupName];
        
        [self addChildViewController:widgetCollectionController];
        current=widgetCollectionController;
    }
    //NSLog(@"index path:%@",indexPath);
    //NSLog(@"content view frame:%@",NSStringFromCGRect(cell.contentView.frame));
    
    
    
    
    CGRect viewFrame= [self addTitleForCell:cell withDashboardInfo:self.dashboardArray[indexPath.section]];
    
    current.viewFrame=viewFrame;
    cell.tag=indexPath.section;
    
    [cell.contentView addSubview:current.view];
    
    return cell;
}

- (CGRect)addTitleForCell:(REMDashboardCellViewCell *)cell withDashboardInfo:(REMDashboardObj *)dashboardInfo{
    CGRect frame=cell.contentView.frame;
    CGRect shareFrame;
    if(dashboardInfo.shareInfo!=nil && [dashboardInfo.shareInfo isEqual:[NSNull null]]== NO && [dashboardInfo.shareInfo.userRealName isEqual:[NSNull null]]==NO){
        shareFrame = CGRectMake(0, 0, frame.size.width, kDashboardShareSize);
        UILabel *shareName=[[UILabel alloc]initWithFrame:CGRectMake(shareFrame.origin.x, shareFrame.origin.y, frame.size.width, shareFrame.size.height)];
        shareName.textColor=[UIColor whiteColor];
        shareName.text=dashboardInfo.shareInfo.userRealName;
        [cell.contentView addSubview:shareName];
    }
    else{
        shareFrame = CGRectMake(0, 0, frame.size.width, 0);
    }
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(shareFrame.origin.x,shareFrame.origin.y+shareFrame.size.height, frame.size.width, kDashboardTitleSize)];
    title.text=dashboardInfo.name;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardTitleSize];
    [cell.contentView addSubview:title];
    
    return CGRectMake(0, title.frame.origin.y+title.frame.size.height+kDashboardTitleBottomMargin, frame.size.width, cell.contentView.frame.size.height-(title.frame.origin.y+title.frame.size.height+kDashboardTitleBottomMargin));
}

- (void)maxWidget{
    [self.buildingController performSegueWithIdentifier:@"maxWidgetSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
