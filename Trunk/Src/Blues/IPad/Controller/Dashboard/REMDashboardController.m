/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDashboardControllerViewController.m
 * Created      : tantan on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMDashboardController.h"

#import "REMWidgetMaxViewController.h"
#import "REMManagedSharedModel.h"
#import "REMManagedDashboardModel.h"

@interface REMDashboardController ()

@property (nonatomic,weak) UILabel *buildingLabel;
@property  (nonatomic) BOOL isHiding;

@property (nonatomic,weak) UIImageView *arrow;


@end

@implementation REMDashboardController


static NSString *cellId=@"dashboardcell";

-(NSArray *)dashboards
{
//    if(_dashboards == nil){
//        _dashboards = [self.buildingInfo.dashboards.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            return [[obj2 id] compare:[obj1 id]];
//        }];
//    }
//    
//    return _dashboards;
    return self.buildingInfo.dashboards.array;
}

- (void)cancelAllRequest{
    [REMDataStore cancel:[self groupName]];
}



- (void)loadView{
    self.tableView= [[REMDashboardView alloc]initWithFrame:self.viewFrame style:UITableViewStyleGrouped];
    //NSLog(@"viewframe:%@",NSStringFromCGRect(self.viewFrame));
    self.view=self.tableView;
    //self.view.layer.borderWidth=1;
    //self.view.layer.borderColor=[UIColor yellowColor].CGColor;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[REMDashboardCellViewCell class] forCellReuseIdentifier:cellId];
    self.tableView.sectionFooterHeight=34;
    self.tableView.sectionHeaderHeight=0;
    self.tableView.contentInset = UIEdgeInsetsMake(-REMDMCOMPATIOS7(14), 0, 0, 0);
    //NSLog(@"frame:%@",NSStringFromCGRect(self.view.frame));
    
    UIFont *font = [REMFont defaultFontOfSize:kDashboardDragTitleSize];
    NSString *text = REMIPadLocalizedString(@"Dashboard_PullDownShowGeneral");
    CGSize size = [text sizeWithFont:font];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kDashboardDragTitleMargin, size.width, kDashboardDragTitleSize)];
    label.text=text;
    label.font=font;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [self.tableView addSubview:label];
    self.buildingLabel=label;
    
    CGRect imgFrame=CGRectMake(size.width + 5, kDashboardDragTitleMargin-2,  15, 20);
    UIImageView *arrow=[[UIImageView alloc]initWithImage:REMIMG_Down];
    [arrow setFrame:imgFrame];
    [self.tableView addSubview:arrow];
    self.arrow=arrow;
    
}

static NSString *dashboardGroupName=@"building-data-%@";

#define kDashboardSwitchLabelTop -65

- (NSString *)groupName{
    return [NSString stringWithFormat:dashboardGroupName,self.buildingInfo.id];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES && scrollView.contentOffset.y<kDashboardSwitchLabelTop){
        //self.isHiding=YES;
        
        //[REMDataAccessor cancelAccess:[self groupName]];
        //[self.imageView gotoBuildingInfo];
        REMBuildingImageViewController *parent=(REMBuildingImageViewController *)self.parentViewController;
        parent.currentCoverStatus=REMBuildingCoverStatusCoverPage;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // NSLog(@"table scroll:%@",NSStringFromCGPoint(scrollView.contentOffset));
    //if(self.isHiding==YES)return;

    if(scrollView.contentOffset.y<kDashboardSwitchLabelTop){
        self.buildingLabel.text=REMIPadLocalizedString(@"Building_ReleaseSwitchView");//@"松开以显示";
        [UIView animateWithDuration:0.2 animations:^(void){
            //self.arrow.layer.transform=CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            self.arrow.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else {
        self.buildingLabel.text=REMIPadLocalizedString(@"Dashboard_PullDownShowGeneral");// @"下拉返回概览能耗信息";
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
    
    NSInteger count= self.dashboards.count;
    if(count==0){
        return 1;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dashboards.count==0) {
        return 100;
    }
    
    REMManagedDashboardModel *obj= self.dashboards[indexPath.section];
    CGFloat titleHeight=kDashboardTitleSize+kDashboardTitleBottomMargin+4;
    if(obj.sharedInfo!=nil){
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
    [cell.contentView setFrame:CGRectMake(0, 0, cell.frame.size.width,cell.frame.size.height)];
    //cell.contentView.layer.borderWidth=1;
    //cell.contentView.layer.borderColor=[UIColor yellowColor].CGColor;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (self.dashboards.count==0) {
        NSString *emptyText=REMIPadLocalizedString(@"Dashboard_Empty");//未配置任何仪表盘。
        cell.textLabel.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
        cell.textLabel.font=[REMFont defaultFontOfSize:29];
        cell.textLabel.text=emptyText;
        return cell;
    }
    
    
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
            [self cleanCellContent:cell];
        }
    }
    else{
        [self cleanCellContent:cell];
        REMWidgetCollectionViewController *widgetCollectionController = [[REMWidgetCollectionViewController alloc]initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        
        widgetCollectionController.currentDashboardIndex=indexPath.section;
        widgetCollectionController.dashboardInfo=self.dashboards[indexPath.section];
        widgetCollectionController.groupName=[self groupName];
        
        [self addChildViewController:widgetCollectionController];
        current=widgetCollectionController;
    }
    //NSLog(@"index path:%@",indexPath);
    //NSLog(@"content view frame:%@",NSStringFromCGRect(cell.contentView.frame));
    
    
    
    
    CGRect viewFrame= [self addTitleForCell:cell withDashboardInfo:self.dashboards[indexPath.section]];
    
    current.viewFrame=viewFrame;
    cell.tag=indexPath.section;
    CGFloat height=[self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, height)];
    [cell.contentView setFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    [current.view setFrame:viewFrame];
    [cell.contentView addSubview:current.view];
    
    //NSLog(@"section:%d,cellcontent:%@,cell:%@,collection:%@",indexPath.section,NSStringFromCGRect(cell.contentView.frame), NSStringFromCGRect(cell.frame),NSStringFromCGRect(current.view.frame));
    //cell.contentView.layer.borderWidth=1;
    //cell.contentView.layer.borderColor=[UIColor redColor].CGColor;
    return cell;
}

- (void)cleanCellContent:(UITableViewCell *)cell{
    if(cell.contentView.subviews.count>0){
        for (UIView *v in cell.contentView.subviews) {
            [v removeFromSuperview];
        }
        //REMWidgetCollectionViewController *old= self.childViewControllers[cell.tag];
        //[old releaseContentView];
        
    }
}

- (CGRect)addTitleForCell:(REMDashboardCellViewCell *)cell withDashboardInfo:(REMManagedDashboardModel *)dashboardInfo{
    CGRect frame=cell.contentView.frame;
    CGRect shareFrame;
    if(dashboardInfo.sharedInfo!=nil && [dashboardInfo.sharedInfo isEqual:[NSNull null]]== NO && [dashboardInfo.sharedInfo.userRealName isEqual:[NSNull null]]==NO){
        shareFrame = CGRectMake(0, 0, frame.size.width, kDashboardShareSize);
        UILabel *shareLabel=[[UILabel alloc]initWithFrame:CGRectMake(shareFrame.origin.x, shareFrame.origin.y, frame.size.width, shareFrame.size.height)];
        //shareLabel.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
        shareLabel.textColor=[UIColor whiteColor];
        shareLabel.font=[REMFont defaultFontOfSize:kDashboardShareSize];
        [shareLabel setBackgroundColor:[UIColor clearColor]];
        REMManagedSharedModel *sharedObj =dashboardInfo.sharedInfo;
        NSString *shareName=sharedObj.userRealName;
        NSString *shareTel=sharedObj.userTelephone;
        NSString *date=[REMTimeHelper formatTimeFullDay:sharedObj.shareTime isChangeTo24Hour:NO];
        NSString *userTitle=dashboardInfo.sharedInfo.userTitleComponent;
        shareLabel.text=[NSString stringWithFormat:REMIPadLocalizedString(@"Widget_ShareTitle"),shareName,userTitle,date,shareTel];
        [cell.contentView addSubview:shareLabel];
    }
    else{
        shareFrame = CGRectMake(0, 0, frame.size.width, 0);
    }
    
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(shareFrame.origin.x,shareFrame.origin.y+shareFrame.size.height+kDashboardTitleShareMargin, frame.size.width, kDashboardTitleSize)];
    [title setBackgroundColor:[UIColor clearColor]];
    title.text=dashboardInfo.name;
    title.backgroundColor=[UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    //title.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardTitleSize];
    title.font=[REMFont defaultFontOfSize:kDashboardTitleSize];
    [cell.contentView addSubview:title];
    
    return CGRectMake(0, title.frame.origin.y+title.frame.size.height+kDashboardTitleBottomMargin, frame.size.width, cell.contentView.frame.size.height-(title.frame.origin.y+title.frame.size.height+kDashboardTitleBottomMargin+1));
}

- (void)maxWidget{
    REMBuildingImageViewController *parent=(REMBuildingImageViewController *)self.parentViewController;
    REMBuildingViewController *buildingController=(REMBuildingViewController *)parent.parentViewController;
    
    [buildingController performSegueWithIdentifier:@"maxWidgetSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"maxWidgetSegue"]==YES) {
        REMWidgetMaxViewController *maxController=segue.destinationViewController;
        maxController.buildingInfo=self.buildingInfo;
    }
}

- (void)horizonalMoving{
    UIScrollView *view=(UIScrollView *)self.view;
    [view setUserInteractionEnabled:NO];
}

- (void)horizonalStopped{
    UIScrollView *view=(UIScrollView *)self.view;
    [view setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
    // Dispose of any resources that can be recreated.
}

@end
