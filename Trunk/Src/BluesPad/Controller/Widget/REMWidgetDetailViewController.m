//
//  REMWidgetDetailViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 10/29/13.
//
//

#import "REMWidgetDetailViewController.h"
#import "REMBuildingViewController.h"

#import "REMTimeHelper.h"
#import "REMRankingWidgetWrapper.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMStackColumnWidgetWrapper.h"
#import "REMDatePickerViewController.h"
#import "REMWidgetBizDelegatorBase.h"


const static CGFloat kWidgetBackButtonLeft=10;
const static CGFloat kWidgetBackButtonTop=10;
const static CGFloat kWidgetBackButtonWidthHeight=30;
const static CGFloat kWidgetTitleLeftMargin=10;
const static CGFloat kWidgetTitleHeight=30;
const static CGFloat kWidgetTitleFontSize=25;

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
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
    
    self.bizDelegator=[REMWidgetBizDelegatorBase bizDelegatorByWidgetInfo:self.widgetInfo];
    self.bizDelegator.view=self.view;
    self.bizDelegator.energyData=self.energyData;
    self.bizDelegator.widgetInfo=self.widgetInfo;
    self.bizDelegator.groupName=self.groupName;
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

    UILabel *widgetTitle=[[UILabel alloc]initWithFrame:CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, self.view.frame.size.width, kWidgetTitleHeight)];
    widgetTitle.text=self.widgetInfo.name;
    widgetTitle.backgroundColor=[UIColor clearColor];
    widgetTitle.textColor=[UIColor whiteColor];
    widgetTitle.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetTitleFontSize];
    [self.view addSubview:widgetTitle];
    self.widgetTitleLabel=widgetTitle;
    
    
    [self.bizDelegator initBizView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
