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
#import "REMRankingWidgetWrapper.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMStackColumnWidgetWrapper.h"
#import "REMDatePickerViewController.h"
#import "REMWidgetBizDelegatorBase.h"
#import "REMDimensions.h"

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
    [titleContainer setBackgroundColor:[UIColor clearColor]];
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(kWidgetBackButtonLeft, kWidgetBackButtonTop, kWidgetBackButtonWidthHeight, kWidgetBackButtonWidthHeight)];
    [backButton setImage:[UIImage imageNamed:@"Back_Chart"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenHighlighted=YES;
    backButton.showsTouchWhenHighlighted=YES;
    
    [backButton addTarget:self.parentViewController action:@selector(popToBuildingCover) forControlEvents:UIControlEventTouchUpInside];
    [titleContainer addSubview:backButton];
    self.backButton=backButton;
    
    
    CGRect frame;
    if(self.widgetInfo.shareInfo!=nil && [self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
        frame=CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetShareTitleFontSize);
        UILabel *shareTitle=[[UILabel alloc]initWithFrame:frame];
        [shareTitle setBackgroundColor:[UIColor clearColor]];
        shareTitle.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetShareTitleFontSize];
        shareTitle.textColor=[REMColor colorByHexString:@"#a2a2a2"];
        NSString *shareName=self.widgetInfo.shareInfo.userRealName;
        NSString *shareTel=self.widgetInfo.shareInfo.userTelephone;
        NSString *date=[REMTimeHelper formatTimeFullDay:self.widgetInfo.shareInfo.shareTime];
        NSString *userTitle=self.widgetInfo.shareInfo.userTitleComponent;
        shareTitle.text=[NSString stringWithFormat:NSLocalizedString(@"Widget_ShareTitle", @""),shareName,userTitle,date,shareTel];
        [titleContainer addSubview:shareTitle];
        frame=CGRectMake(frame.origin.x, frame.origin.y+frame.size.height+kWidgetShareTitleMargin, frame.size.width, kWidgetTitleHeight);
    }
    else{
        frame=CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetTitleHeight);
    }

    UILabel *widgetTitle=[[UILabel alloc]initWithFrame:frame];
    widgetTitle.text=self.widgetInfo.name;
    widgetTitle.backgroundColor=[UIColor clearColor];
    widgetTitle.textColor=[REMColor colorByHexString:@"#37ab3c"];
    widgetTitle.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetTitleFontSize];
    [titleContainer addSubview:widgetTitle];
    self.widgetTitleLabel=widgetTitle;
    [self.view addSubview:titleContainer];
    self.titleContainer=titleContainer;
    [self.bizDelegator initBizView];
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
