/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetDetailViewController.m
 * Created      : tantan on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetDetailViewController.h"
#import "REMBuildingViewController.h"

#import "REMTimeHelper.h"
#import "REMDatePickerViewController.h"
#import "REMWidgetBizDelegatorBase.h"
#import "REMDimensions.h"
#import "REMWidgetBuildingCoverViewController.h"
#import "REMBuildingOverallModel.h"
#import "REMBuildingCoverWidgetRelationModel.h"


const static CGFloat kWidgetBackButtonLeft=25;
const static CGFloat kWidgetBackButtonTop=16;
const static CGFloat kWidgetBackButtonWidthHeight=32;
const static CGFloat kWidgetTitleLeftMargin=10;
const static CGFloat kWidgetTitleHeight=30;
const static CGFloat kWidgetTitleFontSize=18;
const static CGFloat kWidgetShareTitleMargin=2;
const static CGFloat kWidgetShareTitleHeight=14;
const static CGFloat kWidgetShareTitleFontSize=14;


@interface REMWidgetDetailViewController ()

@property (nonatomic,weak) UIButton *backButton;
@property (nonatomic,weak) UILabel *widgetTitleLabel;
@property (nonatomic,weak) UISegmentedControl *legendControl;
@property (nonatomic,weak) UISegmentedControl *stepControl;
@property (nonatomic,weak) UIButton *datePickerButton;

@property (nonatomic,weak) UIView *chartContainer;
@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) REMWidgetBizDelegatorBase *bizDelegator;
@property (nonatomic,strong) UIPopoverController *popController;
@end

@implementation REMWidgetDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self.view setBackgroundColor:[REMColor colorByHexString:@"#f4f4f4"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:CGRectMake(0, 0, kDMScreenWidth, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight))];
    
    self.bizDelegator=[REMWidgetBizDelegatorBase bizDelegatorByWidgetInfo:self.widgetInfo];
    self.bizDelegator.view=self.view;
    self.bizDelegator.energyData=self.energyData;
    self.bizDelegator.widgetInfo=self.widgetInfo;
    self.bizDelegator.ownerController=self;
    self.bizDelegator.groupName=[NSString stringWithFormat:@"widget-%@",self.widgetInfo.widgetId];
    //self.view.layer.borderColor=[UIColor redColor].CGColor;
    //self.view.layer.borderWidth=1;
    
    UIView *titleContainer=[[UIView alloc]initWithFrame:CGRectMake(0, REMDMCOMPATIOS7(0), self.view.frame.size.width, 63)];
    //[titleContainer setBackgroundColor:[REMColor colorByHexString:@"#f8f8f8"]];
    [titleContainer setBackgroundColor:[UIColor whiteColor]];

    [self initBackButton:titleContainer];
//    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    if (REMISIOS7) {
//        backButton=[UIButton buttonWithType:UIButtonTypeSystem];
//    }
//    [backButton setFrame:CGRectMake(kWidgetBackButtonLeft, kWidgetBackButtonTop, kWidgetBackButtonWidthHeight, kWidgetBackButtonWidthHeight)];
//    [backButton setImage:[UIImage imageNamed:@"Back_Chart"] forState:UIControlStateNormal];
//    [backButton setTintColor:[REMColor colorByHexString:@"#37ab3c"] ];
//    backButton.adjustsImageWhenHighlighted=NO;
//    //backButton.showsTouchWhenHighlighted=YES;
//    
//    [backButton addTarget:self.parentViewController action:@selector(popToBuildingCover) forControlEvents:UIControlEventTouchUpInside];
//    [titleContainer addSubview:backButton];
//    self.backButton=backButton;
//    
//    
//    CGRect frame;
//    if(self.widgetInfo.shareInfo!=nil && [self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
//        frame=CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetShareTitleFontSize);
//        UILabel *shareTitle=[[UILabel alloc]initWithFrame:frame];
//        [shareTitle setBackgroundColor:[UIColor clearColor]];
//        shareTitle.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetShareTitleFontSize];
//        shareTitle.textColor=[REMColor colorByHexString:@"#a2a2a2"];
//        NSString *shareName=self.widgetInfo.shareInfo.userRealName;
//        NSString *shareTel=self.widgetInfo.shareInfo.userTelephone;
//        NSString *date=[REMTimeHelper formatTimeFullDay:self.widgetInfo.shareInfo.shareTime isChangeTo24Hour:NO];
//        NSString *userTitle=self.widgetInfo.shareInfo.userTitleComponent;
//        shareTitle.text=[NSString stringWithFormat:NSLocalizedString(@"Widget_ShareTitle", @""),shareName,userTitle,date,shareTel];
//        [titleContainer addSubview:shareTitle];
//        frame=CGRectMake(frame.origin.x, frame.origin.y+frame.size.height+kWidgetShareTitleMargin, frame.size.width, kWidgetTitleHeight);
//    }
//    else{
//        frame=CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetTitleHeight);
//    }
//
//    UILabel *widgetTitle=[[UILabel alloc]initWithFrame:frame];
//    widgetTitle.text=self.widgetInfo.name;
//    widgetTitle.backgroundColor=[UIColor clearColor];
//    widgetTitle.textColor=[REMColor colorByHexString:@"#37ab3c"];
//    widgetTitle.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetTitleFontSize];
//    [titleContainer addSubview:widgetTitle];
//    self.widgetTitleLabel=widgetTitle;
    [self.view addSubview:titleContainer];
    self.titleContainer=titleContainer;
    
    
    
    [self.bizDelegator initBizView];
    
    if ([self.bizDelegator shouldPinToBuildingCover]==YES) {
        UIButton *pinButton=[UIButton buttonWithType:UIButtonTypeCustom];
        if (REMISIOS7) {
            pinButton = [UIButton buttonWithType:UIButtonTypeSystem];
            pinButton.tintColor=[REMColor colorByHexString:@"#37ab3c"];
            
        }
        CGFloat x=[self.bizDelegator xPositionForPinToBuildingCoverButton];
        
        [pinButton setFrame:CGRectMake(x, kWidgetBackButtonTop, 32, 32)];
        [pinButton setImage:[UIImage imageNamed:@"ChartCustomization_Widget"] forState:UIControlStateNormal];
        [pinButton addTarget:self action:@selector(pinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleContainer addSubview:pinButton];
        [pinButton setEnabled:[self.bizDelegator shouldEnablePinToBuildingCoverButton]];
    }
    
}

- (void)initBackButton:(UIView *)container{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    if (REMISIOS7) {
        backButton=[UIButton buttonWithType:UIButtonTypeSystem];
    }
    //backButton.layer.borderColor=[UIColor redColor].CGColor;
    //backButton.layer.borderWidth=1;
    backButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    [backButton setFrame:CGRectMake(kWidgetBackButtonLeft, 0, container.frame.size.width/2, container.frame.size.height)];
    backButton.imageView.contentMode=UIViewContentModeLeft;
    backButton.contentMode=UIViewContentModeLeft;
    [backButton setImage:[UIImage imageNamed:@"Back_Chart"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [backButton setTintColor:[REMColor colorByHexString:@"#37ab3c"] ];
    backButton.adjustsImageWhenHighlighted=NO;
    
    
    NSString *shareTitle=nil;
    NSString *widgetTitle=self.widgetInfo.name;
    if(self.widgetInfo.shareInfo!=nil && [self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
        NSString *shareName=self.widgetInfo.shareInfo.userRealName;
        NSString *shareTel=self.widgetInfo.shareInfo.userTelephone;
        NSString *date=[REMTimeHelper formatTimeFullDay:self.widgetInfo.shareInfo.shareTime isChangeTo24Hour:NO];
        NSString *userTitle=self.widgetInfo.shareInfo.userTitleComponent;
        shareTitle = [NSString stringWithFormat:NSLocalizedString(@"Widget_ShareTitle", @""),shareName,userTitle,date,shareTel];
    }
    NSString *fullTitle=widgetTitle;
    if (shareTitle!=nil) {
        fullTitle = [shareTitle stringByAppendingFormat:@"\n%@",widgetTitle];
        backButton.titleLabel.numberOfLines=2;
        backButton.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    }
    
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:fullTitle];
    if (shareTitle!=nil) {
        NSRange shareRange=[fullTitle rangeOfString:shareTitle];
        [attrString addAttribute:NSForegroundColorAttributeName value:[REMColor colorByHexString:@"#a2a2a2"] range:shareRange];
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetShareTitleFontSize] range:shareRange];
        NSMutableParagraphStyle *paraStyle=[[NSMutableParagraphStyle alloc]init];
        paraStyle.lineBreakMode=NSLineBreakByClipping;
        paraStyle.alignment=NSTextAlignmentLeft;
        paraStyle.lineSpacing=4;
        [attrString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:shareRange];
    }
    NSRange widgetTitleRange=[fullTitle rangeOfString:widgetTitle];
    [attrString addAttribute:NSForegroundColorAttributeName value:[REMColor colorByHexString:@"#37ab3c"] range:widgetTitleRange];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetTitleFontSize] range:widgetTitleRange];
    NSMutableParagraphStyle *titleParaStyle=[[NSMutableParagraphStyle alloc]init];
    
    titleParaStyle.lineBreakMode=NSLineBreakByClipping;
    titleParaStyle.alignment=NSTextAlignmentLeft;
    [attrString addAttribute:NSParagraphStyleAttributeName value:titleParaStyle range:widgetTitleRange];
    [backButton setAttributedTitle:attrString forState:UIControlStateNormal];
    CGSize size = [backButton sizeThatFits:backButton.frame.size];
    [backButton setFrame:CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, size.width, backButton.frame.size.height)];
    [backButton addTarget:self.parentViewController action:@selector(popToBuildingCover) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:backButton];
}

- (REMWidgetObject *)widgetByRelation:(REMBuildingCoverWidgetRelationModel *)relation{
    for (REMDashboardObj *dashboard in self.buildingInfo.dashboardArray) {
        if ([relation.dashboardId isEqualToNumber:dashboard.dashboardId]==YES) {
            for (REMWidgetObject *widget in dashboard.widgets) {
                if ([widget.widgetId isEqualToNumber:relation.widgetId]==YES) {
                    return widget;
                }
            }
        }
    }
    return nil;
}

- (NSArray *)piningWidgetList{
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<self.buildingInfo.commodityArray.count; ++i) {
        REMCommodityModel *commodity=self.buildingInfo.commodityArray[i];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        dic[@"name"]= commodity.comment;
        dic[@"Id"]=commodity.commodityId;
        BOOL foundFirst=NO;
        BOOL foundSecond=NO;
        for (REMBuildingCoverWidgetRelationModel *relation in self.buildingInfo.widgetRelationArray) {
            if ([relation.commodityId isEqualToNumber:commodity.commodityId]==YES) {
                REMWidgetObject *widget=[self widgetByRelation:relation];
                if (widget!=nil && [widget.widgetId isGreaterThan:@(0)]==YES) {
                    if (relation.position == REMBuildingCoverWidgetPositionFirst) {
                        foundFirst=YES;
                        dic[@"firstName"]=widget.name;
                        dic[@"firstId"]=widget.widgetId;
                        dic[@"firstDashboardId"]=relation.dashboardId;
                        if ([self.widgetInfo.widgetId isEqualToNumber:widget.widgetId]) {
                            dic[@"firstSelected"]=@(1);
                        }
                        
                    }
                    else{
                        foundSecond=YES;
                        dic[@"secondName"]=widget.name;
                        dic[@"secondId"]=widget.widgetId;
                        dic[@"secondDashboardId"]=relation.dashboardId;
                        if ([self.widgetInfo.widgetId isEqualToNumber:widget.widgetId]) {
                            dic[@"secondSelected"]=@(1);
                        }
                    }
                    
                }
            }
        }
        if (foundFirst==NO) {
            dic[@"firstName"]=[NSString stringWithFormat:NSLocalizedString(@"Building_EnergyUsageByAreaByMonth", @""),commodity.comment];
            dic[@"firstId"]=@(-1);
        }
        if (foundSecond==NO) {
            dic[@"secondName"]=[NSString stringWithFormat:NSLocalizedString(@"Building_EnergyUsageByCommodity", @""),commodity.comment];
            dic[@"secondId"]=@(-2);
        }
        [array addObject:dic];
    }
    
    return array;
}

- (void)pinButtonClicked:(UIButton *)button{
    UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *nav= [mainStoryboard instantiateViewControllerWithIdentifier:@"widgetBuildingCoverNavigation"];
    nav.navigationBar.translucent=NO;
    REMWidgetBuildingCoverViewController *buildingCoverWidgetController=nav.childViewControllers[0];
    buildingCoverWidgetController.buildingInfo=self.buildingInfo;
    buildingCoverWidgetController.detailController=self;
    buildingCoverWidgetController.dashboardInfo=self.dashboardInfo;
    buildingCoverWidgetController.data=[self piningWidgetList];
    UIPopoverController *popController=[[UIPopoverController alloc]initWithContentViewController:nav];
    popController.popoverContentSize=CGSizeMake(350, 400);
    popController.delegate=self;
    self.popController=popController;
    CGRect frame=CGRectMake(button.frame.origin.x, REMDMCOMPATIOS7(button.frame.origin.y), button.frame.size.width, button.frame.size.height);
    [popController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    buildingCoverWidgetController.popController=popController;
    
    
}
- (void)updateBuildingCover{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBuildingCoverRelation" object:nil];
    self.popController=nil;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    UINavigationController *nav=(UINavigationController *)popoverController.contentViewController;
    REMWidgetBuildingCoverViewController *pinController=nav.childViewControllers[0];
    
    if (pinController.isRequesting==NO) {
        self.popController=nil;
    }
    
}

- (void)showChart
{
    [self.bizDelegator showChart];
}

- (void)releaseChart{
    [self.bizDelegator releaseChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
}

@end
