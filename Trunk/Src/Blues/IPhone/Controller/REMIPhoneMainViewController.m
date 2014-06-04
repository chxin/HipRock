/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMIPhoneMainViewController.m
 * Date Created : 张 锋 on 2/19/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMIPhoneMainViewController.h"
#import "REMWidgetContentSyntax.h"
#import "REMEnergyViewData.h"
#import "DCChartStyle.h"
#import "DWrapperConfig.h"
#import "DCTrendWrapper.h"

@interface REMIPhoneMainViewController ()
@property (nonatomic,strong) DAbstractChartWrapper* wrapper;
@end

@implementation REMIPhoneMainViewController

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
    
    self.label.text = NSLocalizedStringFromTable(@"test", @"Localizable_IPhone", @"");
    [self oscarTest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.wrapper getView].frame = self.view.bounds;
}

-(void)oscarTest {
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.xtype = @"columnchartcomponent";
    syntax.step = [NSNumber numberWithInt: REMEnergyStepHour];
    NSMutableArray* timeRanges = [[NSMutableArray alloc]initWithCapacity:1];
    REMTimeRange* r = [[REMTimeRange alloc]initWithStartTime:[NSDate dateWithTimeIntervalSince1970:0] EndTime:[NSDate dateWithTimeIntervalSince1970:3600*12]];
    [timeRanges setObject:r atIndexedSubscript:0];
    syntax.timeRanges = timeRanges;
    syntax.params = @{@"benchmarkOption":@{@"benchmarkText":@"TEST全行业Benckmark"}};
    
    REMEnergyViewData* energyViewData = [[REMEnergyViewData alloc]init];
    NSMutableArray* sereis = [[NSMutableArray alloc]init];
    for (int sIndex = 0; sIndex < 3; sIndex++) {
        NSMutableArray* energyDataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10000; i++) {
            REMEnergyData* data = [[REMEnergyData alloc]init];
            data.quality = REMEnergyDataQualityGood;
            //            if (i%5==0) {
            //
            //            } else {
            data.dataValue = [NSNumber numberWithInt:(i+1)*10*(sIndex+1)];
            //            }
            data.localTime = [NSDate dateWithTimeIntervalSince1970:i*3600];
            [energyDataArray addObject:data];
        }
        REMTargetEnergyData* sData = [[REMTargetEnergyData alloc]init];
        sData.energyData = energyDataArray;
        sData.target = [[REMEnergyTargetModel alloc]init];
        sData.target.targetId = @(1);
        sData.target.name = @"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        sData.target.uomId = 0;
        sData.target.uomName = [NSString stringWithFormat:@"UOM%i", sIndex];
        [sereis addObject:sData];
    }
    energyViewData.visibleTimeRange = r;
    energyViewData.globalTimeRange = [[REMTimeRange alloc]initWithStartTime:[NSDate dateWithTimeIntervalSince1970:0] EndTime:[NSDate dateWithTimeIntervalSince1970:3600*10000]];
    
    NSMutableArray *labellings=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<3; ++i) {
        REMEnergyLabellingLevelData* a = [[REMEnergyLabellingLevelData alloc]init];
        a.name = @"FFFF0";
        a.maxValue = @((i + 1) * 20);
        a.maxValue = @(i * 20);
        a.uomId = 0;
        a.uom = [NSString stringWithFormat:@"UOM%i", i];
        [labellings addObject:a];
    }
    energyViewData.labellingLevelArray = labellings;
    energyViewData.targetEnergyData = sereis;
    DCChartStyle* style = nil;
    CGRect frame;
    BOOL mini = NO;
    if (mini) {
        style = [DCChartStyle getMinimunStyle];
        frame = self.view.bounds;
    } else {
        style = [DCChartStyle getMaximizedStyle];
        frame = self.view.bounds;
    }
    style.xTextFont = [UIFont fontWithName:style.xTextFont.fontName size:10];
    style.yTextFont = [UIFont fontWithName:style.xTextFont.fontName size:10];
    
    DWrapperConfig* config = [[DWrapperConfig alloc]init];
    config.step = REMEnergyStepHour;
    config.calendarType = REMCalendarTypeNone;
    //    DCPieWrapper* pieWrapper = [[DCPieWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
    //    [self.view addSubview:pieWrapper.view];
    //    self.plotSource = pieWrapper;
    DCTrendWrapper* columnWidget = [[DCTrendWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:config style:style];
    columnWidget.view.backgroundColor = [UIColor blackColor];
    columnWidget.view.graphContext.hGridlineAmount = 4;
    [self.view addSubview:columnWidget.view];
    
    //    DCLineWrapper* lineWidget = [[DCLineWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
    //    lineWidget.view.backgroundColor = [UIColor blackColor];
    //    NSMutableArray* bands = [[NSMutableArray alloc]init];
    //    DCRange* bandRange = [[DCRange alloc]initWithLocation:0 length:20];
    //    DCXYChartBackgroundBand* b = [[DCXYChartBackgroundBand alloc]init];
    //    b.range = bandRange;
    //    b.color = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.5];
    //    b.axis = lineWidget.view.yAxisList[0];
    //    [bands addObject:b];
    ////    [lineWidget.view setBackgoundBands:bands];
    //    [self.view addSubview:lineWidget.view];
    //    self.plotSource = lineWidget;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 605, 100, 30)];
    //btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
    [btn setTitle:@"show/hide" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[REMColor colorByHexString:@"#00ff48"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 605, 100, 30)];
    //btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
    [btn1 setTitle:@"show/hide" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[REMColor colorByHexString:@"#00ff48"] forState:UIControlStateSelected];
    [btn1 addTarget:self action:@selector(buttonPressed1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 605, 100, 30)];
    //btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
    [btn2 setTitle:@"show/hide" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[REMColor colorByHexString:@"#00ff48"] forState:UIControlStateSelected];
    [btn2 addTarget:self action:@selector(buttonPressed2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    self.wrapper = columnWidget;
    //    DCLabelingWrapper* labelingWrapper = [[DCLabelingWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
    //    self.plotSource = labelingWrapper;
    //    [labelingWrapper getView].backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:[labelingWrapper getView]];
    //    labelingWrapper.delegate = self;
}

@end
