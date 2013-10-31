//
//  REMWidgetDetailViewController.m
//  Blues
//
//  Created by tantan on 10/29/13.
//
//

#import "REMWidgetDetailViewController.h"
#import "REMBuildingViewController.h"
#import "REMEnum.h"
#import "REMTimeHelper.h"
#import "REMRankingWidgetWrapper.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMStackColumnWidgetWrapper.h"



const static CGFloat kWidgetBackButtonLeft=10;
const static CGFloat kWidgetBackButtonTop=10;
const static CGFloat kWidgetBackButtonWidthHeight=30;
const static CGFloat kWidgetTitleLeftMargin=10;
const static CGFloat kWidgetTitleHeight=30;
const static CGFloat kWidgetTitleFontSize=25;
const static CGFloat kWidgetDatePickerLeftMargin=15;
const static CGFloat kWidgetDatePickerTopMargin=70;
const static CGFloat kWidgetDatePickerHeight=30;
const static CGFloat kWidgetDatePickerWidth=250;
const static CGFloat kWidgetStepSingleButtonWidth=60;
const static CGFloat kWidgetChartLeftMargin=10;
const static CGFloat kWidgetChartTopMargin=kWidgetDatePickerTopMargin+kWidgetDatePickerHeight;
const static CGFloat kWidgetChartWidth=1004;
const static CGFloat kWidgetChartHeight=748-kWidgetChartTopMargin;

@interface REMWidgetDetailViewController ()

@property (nonatomic,weak) UIButton *backButton;
@property (nonatomic,weak) UILabel *widgetTitleLabel;
@property (nonatomic,weak) UISegmentedControl *diagramTypeControl;
@property (nonatomic,weak) UISegmentedControl *stepControl;
@property (nonatomic,weak) UIButton *datePickerButton;

@property (nonatomic,weak) UIView *chartContainer;

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
    
    UILabel *widgetTitle=[[UILabel alloc]initWithFrame:CGRectMake(backButton.frame.origin.x+backButton.frame.size.width+kWidgetTitleLeftMargin, backButton.frame.origin.y, 1024, kWidgetTitleHeight)];
    widgetTitle.text=self.widgetInfo.name;
    widgetTitle.backgroundColor=[UIColor clearColor];
    widgetTitle.textColor=[UIColor whiteColor];
    widgetTitle.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kWidgetTitleFontSize];
    [self.view addSubview:widgetTitle];
    self.widgetTitleLabel=widgetTitle;
    
    UISegmentedControl *diagramControl=[[UISegmentedControl alloc] initWithItems:@[@"line",@"column",@"pie"]];
    [diagramControl setFrame:CGRectMake(800, backButton.frame.origin.y, 200, 30)];
    UIImage *line=[UIImage imageNamed:@"Back"];
    UIImage *column=[UIImage imageNamed:@"Up"];
    UIImage *pie=[UIImage imageNamed:@"Down"];
    [diagramControl setImage:line forSegmentAtIndex:0];
    [diagramControl setImage:column forSegmentAtIndex:1];
    [diagramControl setImage:pie forSegmentAtIndex:2];
    
    [self.view addSubview:diagramControl];
    self.diagramTypeControl=diagramControl;
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, kWidgetDatePickerTopMargin, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    NSString *text=self.widgetInfo.contentSyntax.relativeDateComponent;
    
    if(text==nil){
        text=[REMTimeHelper formatTimeRangeFullHour:self.widgetInfo.contentSyntax.timeRanges[0]];
    }

    [timePickerButton setBackgroundImage:[UIImage imageNamed:@"Oil"] forState:UIControlStateNormal];
    
    timePickerButton.titleLabel.textColor=[UIColor grayColor];
    timePickerButton.titleLabel.text=text;
    
    [self.view addSubview:timePickerButton];
    self.datePickerButton = timePickerButton;
    
    
    UISegmentedControl *stepControl=[[UISegmentedControl alloc] initWithItems:@[@"hour",@"day",@"week",@"month",@"year"]];
    [stepControl setFrame:CGRectMake(800, timePickerButton.frame.origin.y, 5*kWidgetStepSingleButtonWidth, 30)];
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
    
    [self showEnergyChart];
}

- (void) showEnergyChart{
    CGRect widgetRect = self.chartContainer.frame;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
