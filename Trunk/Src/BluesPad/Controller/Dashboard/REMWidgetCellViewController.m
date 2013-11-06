//
//  REMWidgetCellViewController.m
//  Blues
//
//  Created by tantan on 10/29/13.
//
//

#import "REMWidgetCellViewController.h"
#import "REMBuildingViewController.h"
#import "REMEnergySeacherBase.h"
#import "REMRankingWidgetWrapper.h"
#import "REMAbstractChartWrapper.h"
#import "REMWidgetCollectionViewController.h"

@interface REMWidgetCellViewController ()


@property (nonatomic,weak) UIView *chartContainer;

@property (nonatomic,strong) REMAbstractChartWrapper *wrapper;

@end

@implementation REMWidgetCellViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chartLongPressed:) name:kREMChartLongPressNotification object:nil];
        // Custom initialization
    }
    return self;
}

-(void)chartLongPressed:(NSNotification*)n {
    NSArray* points = n.userInfo[@"points"];
    for (NSDictionary* dic in points) {
        UIColor* pointColor = dic[@"color"];
        REMEnergyData* pointData = dic[@"energydata"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setFrame:self.viewFrame];
    //NSLog(@"detail view:%@",NSStringFromCGRect(self.view.frame));

    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(kDashboardWidgetPadding, kDashboardWidgetTitleTopMargin, self.view.frame.size.width, kDashboardWidgetTitleSize)];
    title.backgroundColor=[UIColor clearColor];
    title.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetTitleSize];
    title.textColor=[REMColor colorByHexString:@"#4c4c4c"];
    title.text=self.widgetInfo.name;
    [self.view addSubview:title];

    
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+kDashboardWidgetTimeTopMargin, self.view.frame.size.width, kDashboardWidgetTimeSize)];
    time.backgroundColor=[UIColor clearColor];
    time.textColor=[REMColor colorByHexString:@"#5e5e5e"];
    time.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetTimeSize];
    if([self.widgetInfo.contentSyntax.relativeDate isEqual:[NSNull null]]==NO){
        time.text=self.widgetInfo.contentSyntax.relativeDateComponent;
    }
    else{
        REMTimeRange *range = self.widgetInfo.contentSyntax.timeRanges[0];
        NSString *start= [REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO];
        NSString *end= [REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
        time.text=[NSString stringWithFormat:NSLocalizedString(@"Dashboard_TimeRange", @""),start,end];//%@ 到 %@
    }
    [self.view addSubview:time];

    if(self.widgetInfo.shareInfo!=nil||[self.widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
        UILabel *share=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+2, self.view.frame.size.width-(title.frame.origin.x*2), kDashboardWidgetShareSize)];
        share.backgroundColor=[UIColor clearColor];
        share.textColor=[REMColor colorByHexString:@"#5e5e5e"];
        share.textAlignment=NSTextAlignmentRight;
        share.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetShareSize];
        [self.view addSubview:share];
    }
    
    UIView *chartContainer = [[UIView alloc]initWithFrame:CGRectMake(title.frame.origin.x, time.frame.origin.y+time.frame.size.height+kDashboardWidgetChartTopMargin, kDashboardWidgetChartWidth, kDashboardWidgetChartHeight)];
    //chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    //chartContainer.layer.borderWidth=1;
    [self.view addSubview:chartContainer];
    
    self.chartContainer=chartContainer;
    
    [self queryEnergyData:self.widgetInfo.contentSyntax withGroupName:self.groupName];
}

- (void)queryEnergyData:(REMWidgetContentSyntax *)syntax withGroupName:(NSString *)groupName{
   
    REMEnergySeacherBase *searcher=[REMEnergySeacherBase querySearcherByType:syntax.dataStoreType];
    [searcher queryEnergyDataByStoreType:syntax.dataStoreType andParameters:syntax.params withMaserContainer:self.chartContainer  andGroupName:groupName callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *errorInfo){
        self.chartData = data;
        REMAbstractChartWrapper* widgetWrapper = nil;
        REMDiagramType widgetType = self.widgetInfo.diagramType;
        CGRect widgetRect = self.chartContainer.bounds;
        NSMutableDictionary* style = [[NSMutableDictionary alloc]init];
        //    self.userInteraction = ([dictionary[@"userInteraction"] isEqualToString:@"YES"]) ? YES : NO;
        //    self.series = dictionary[@"series"];
        CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
        CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
        gridlineStyle.lineColor = [CPTColor blackColor];
        gridlineStyle.lineWidth = .5f;
        textStyle.fontName = @kBuildingFontSCRegular;
        textStyle.fontSize = 10.0;
        textStyle.color = [CPTColor blackColor];
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
        if (widgetType == REMDiagramTypeLine) {
            widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
        } else if (widgetType == REMDiagramTypeColumn) {
            widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
        } else if (widgetType == REMDiagramTypePie) {
            widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
        } else if (widgetType == REMDiagramTypeRanking) {
            widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
            //        } else if (widgetType == REMDiagramTypeStackColumn) {
            //            widgetWrapper = [[REMStackColumnWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
        }
        if (widgetWrapper != nil) {
            self.wrapper=widgetWrapper;
            [self.chartContainer addSubview:widgetWrapper.view];
            //[widgetWrapper destroyView];
            
            
            NSRunLoop *loop=[NSRunLoop currentRunLoop];
            NSTimer *timer= [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(snapshotChartView) userInfo:nil repeats:NO];
            [loop addTimer:timer forMode:NSDefaultRunLoopMode];
        }
        
    }];
}

- (void)snapshotChartView{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageView *v = [[UIImageView alloc]initWithImage:image];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //[button setBounds:self.chartContainer.bounds];
    button.showsTouchWhenHighlighted=NO;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setBackgroundImage:image forState:UIControlStateSelected];
    button.tag=[self.widgetInfo.widgetId integerValue];
    [button addTarget:self action:@selector(widgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.wrapper destroyView];
    [self.wrapper.view removeFromSuperview];
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
    [self.view addSubview:button];
    //self.wrapper=nil;
}

- (void)widgetButtonPressed:(UIButton *)button{
    //NSLog(@"click widget:%d",button.tag);
    REMWidgetCollectionViewController *parent=(REMWidgetCollectionViewController *)self.parentViewController;
    
    parent.currentMaxWidgetIndex=self.currentIndex;
    
    [parent maxWidget];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
