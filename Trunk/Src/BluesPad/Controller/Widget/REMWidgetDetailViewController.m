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
const static CGFloat kWidgetDatePickerLeftMargin=15;
const static CGFloat kWidgetDatePickerTopMargin=70;
const static CGFloat kWidgetDatePickerHeight=40;
const static CGFloat kWidgetDatePickerWidth=380;
const static CGFloat kWidgetStepSingleButtonWidth=60;
const static CGFloat kWidgetChartLeftMargin=10;
const static CGFloat kWidgetChartTopMargin=kWidgetDatePickerTopMargin+kWidgetDatePickerHeight;
const static CGFloat kWidgetChartWidth=1004;
const static CGFloat kWidgetChartHeight=748-kWidgetChartTopMargin;

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
    self.currentTimeRangeArray=[[NSMutableArray alloc]initWithCapacity:self.widgetInfo.contentSyntax.timeRanges.count];
    
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
    /*
    UISegmentedControl *legendControl=[[UISegmentedControl alloc] initWithItems:@[@"search",@"legend"]];
    [legendControl setFrame:CGRectMake(800, backButton.frame.origin.y, 200, 30)];
    UIImage *search=[UIImage imageNamed:@"Up"];
    UIImage *legend=[UIImage imageNamed:@"Down"];
    [legendControl setImage:search forSegmentAtIndex:0];
    [legendControl setImage:legend forSegmentAtIndex:1];
    [legendControl setSelectedSegmentIndex:1];
    
    [self.view addSubview:legendControl];
    self.legendControl=legendControl;
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, kWidgetDatePickerTopMargin, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    

    
    
    [timePickerButton setImage:[UIImage imageNamed:@"Oil_pressed"] forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, kWidgetDatePickerWidth-40)];
    [timePickerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:timePickerButton];
    
    self.datePickerButton = timePickerButton;
    
    
    UISegmentedControl *stepControl=[[UISegmentedControl alloc] initWithItems:@[@"hour",@"day",@"week",@"month",@"year"]];
    [stepControl setFrame:CGRectMake(700, timePickerButton.frame.origin.y, 5*kWidgetStepSingleButtonWidth, 30)];
    [stepControl setTitle:NSLocalizedString(@"Common_Hour", "") forSegmentAtIndex:0];//小时
    [stepControl setTitle:NSLocalizedString(@"Common_Day", "") forSegmentAtIndex:1];//天
    [stepControl setTitle:NSLocalizedString(@"Common_Week", "") forSegmentAtIndex:2];//周
    [stepControl setTitle:NSLocalizedString(@"Common_Month", "") forSegmentAtIndex:3];//月
    [stepControl setTitle:NSLocalizedString(@"Common_Year", "") forSegmentAtIndex:4];//年
    
    [self.view addSubview:stepControl];
    self.stepControl=stepControl;
    
    UIView *chartContainer=[[UIView alloc]initWithFrame:CGRectMake(kWidgetChartLeftMargin, kWidgetChartTopMargin, kWidgetChartWidth, kWidgetChartHeight)];
    [self.view addSubview:chartContainer];
    self.chartContainer=chartContainer;
    self.chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    self.chartContainer.layer.borderWidth=1;
    [self showEnergyChart];
    
    [self setStepControlStatusByStep:self.widgetInfo.contentSyntax.stepType];
    [self setDatePickerButtonValueByTimeRange:self.widgetInfo.contentSyntax.timeRanges[0] withRelative:self.widgetInfo.contentSyntax.relativeDateComponent withRelativeType:self.widgetInfo.contentSyntax.relativeDateType];
    
    
}

- (void) showTimePicker{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *nav=[storyboard instantiateViewControllerWithIdentifier:@"datePickerNavigationController"];
    
    //REMDatePickerViewController *dateViewController=[storyboard instantiateViewControllerWithIdentifier:@"datePickerViewController"];
        
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
    REMDatePickerViewController *dateViewController =nav.childViewControllers[0];
    dateViewController.relativeDate=self.currentRelativeDate;
    dateViewController.timeRange=self.currentTimeRangeArray[0];
    dateViewController.relativeDateType=self.currentRelativeDateType;
    dateViewController.widgetController=self;
    dateViewController.popController=popoverController;
    [popoverController setPopoverContentSize:CGSizeMake(400, 500)];
    [popoverController presentPopoverFromRect:self.datePickerButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    self.datePickerPopoverController=popoverController;
    //[self performSegueWithIdentifier:@"timePickerSegue" sender:self];
}

- (void)setNewTimeRange:(REMTimeRange *)newRange withRelativeType:(REMRelativeTimeRangeType)relativeType withRelativeDateComponent:(NSString *)newDateComponent
{
    
    [self setDatePickerButtonValueByTimeRange:newRange withRelative:newDateComponent withRelativeType:relativeType];
    
    
}



- (void) showEnergyChart{
    CGRect widgetRect = self.chartContainer.bounds;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    NSMutableDictionary* style = [[NSMutableDictionary alloc]init];
    //    self.userInteraction = ([dictionary[@"userInteraction"] isEqualToString:@"YES"]) ? YES : NO;
    //    self.series = dictionary[@"series"];
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    [style setObject:@"YES" forKey:@"userInteraction"];
    [style setObject:@(0.05) forKey:@"animationDuration"];
    [style setObject:gridlineStyle forKey:@"xLineStyle"];
    [style setObject:textStyle forKey:@"xTextStyle"];
    //    [style setObject:nil forKey:@"xGridlineStyle"];
    //    [style setObject:nil forKey:@"yLineStyle"];
    [style setObject:textStyle forKey:@"yTextStyle"];
    [style setObject:gridlineStyle forKey:@"yGridlineStyle"];
    [style setObject:@(6) forKey:@"horizentalGridLineAmount"];
    REMAbstractChartWrapper  *widgetWrapper;
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[REMStackColumnWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    }
    if (widgetWrapper != nil) {
        [self.chartContainer addSubview:widgetWrapper.view];
    }

}



- (void) setDatePickerButtonValueByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType {
    NSString *text=[REMTimeHelper formatTimeRangeFullHour:range];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
    [self.datePickerButton setTitle:text1 forState:UIControlStateNormal];
    
    self.currentRelativeDate=relativeDate;
    self.currentTimeRangeArray[0]=range;
    self.currentRelativeDateType=relativeType;
}

- (void) setStepControlStatusByTimeRange:(REMTimeRange *)range {
    
    
}

- (void) setStepControlStatusByStep:(REMEnergyStep)step{
    NSUInteger pressedIndex;
    if (step == REMEnergyStepHour) {
        pressedIndex=0;
    }
    else if(step == REMEnergyStepDay){
        pressedIndex=1;
    }
    else if(step == REMEnergyStepWeek){
        pressedIndex=2;
    }
    else if(step == REMEnergyStepMonth){
        pressedIndex=3;
    }
    else if(step == REMEnergyStepYear){
        pressedIndex=4;
    }
    else{
        pressedIndex=NSNotFound;
    }
    if(pressedIndex!=NSNotFound){
        [self.stepControl setSelectedSegmentIndex:pressedIndex];
    }
    
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
