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


const static CGFloat kWidgetBackButtonLeft=25;
const static CGFloat kWidgetBackButtonTop=18;
const static CGFloat kWidgetBackButtonWidthHeight=32;
const static CGFloat kWidgetTitleLeftMargin=10;
const static CGFloat kWidgetTitleHeight=30;
const static CGFloat kWidgetTitleFontSize=18;
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
    
    self.bizDelegator=[REMWidgetBizDelegatorBase bizDelegatorByWidgetInfo:self.widgetInfo];
    self.bizDelegator.view=self.view;
    self.bizDelegator.energyData=self.energyData;
    self.bizDelegator.widgetInfo=self.widgetInfo;
    self.bizDelegator.groupName=[NSString stringWithFormat:@"widget-%@",self.widgetInfo.widgetId];
    //self.view.layer.borderColor=[UIColor redColor].CGColor;
    //self.view.layer.borderWidth=1;
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(kWidgetBackButtonLeft, kWidgetBackButtonTop, kWidgetBackButtonWidthHeight, kWidgetBackButtonWidthHeight)];
    [backButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenHighlighted=YES;
    backButton.showsTouchWhenHighlighted=YES;
    [backButton addTarget:self.parentViewController action:@selector(popToBuildingCover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    self.backButton=backButton;
    
    
    CGRect frame;
    if(self.widgetInfo.shareInfo!=nil && [self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
        frame=CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetShareTitleHeight);
        UILabel *shareTitle=[[UILabel alloc]initWithFrame:frame];
        NSString *shareName=self.widgetInfo.shareInfo.userRealName;
        NSString *shareTel=self.widgetInfo.shareInfo.userTelephone;
        NSString *date=[REMTimeHelper formatTimeFullDay:self.widgetInfo.shareInfo.shareTime];
        NSString *userTitle=self.widgetInfo.shareInfo.userTitleComponent;
        shareTitle.text=[NSString stringWithFormat:NSLocalizedString(@"Widget_ShareTitle", @""),shareName,userTitle,date,shareTel];
        [self.view addSubview:shareTitle];
        frame=CGRectMake(frame.origin.x, frame.origin.y+frame.size.height+9, frame.size.width, kWidgetTitleHeight);
    }
    else{
        frame=CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetTitleHeight);
    }

    UILabel *widgetTitle=[[UILabel alloc]initWithFrame:frame];
    widgetTitle.text=self.widgetInfo.name;
    widgetTitle.backgroundColor=[UIColor clearColor];
    widgetTitle.textColor=[REMColor colorByHexString:@"#37ab3c"];
    widgetTitle.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetTitleFontSize];
    [self.view addSubview:widgetTitle];
    self.widgetTitleLabel=widgetTitle;
    
    
    [self.bizDelegator initBizView];
}

- (void)showChart
{
    [self.bizDelegator showChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning :%@",[self class]);
}

@end
