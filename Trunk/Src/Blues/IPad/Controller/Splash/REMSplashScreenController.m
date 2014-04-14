/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSplashScreenController.m
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMSplashScreenController.h"
#import "REMLoginCarouselController.h"
#import "REMCommonHeaders.h"
#import "REMBuildingViewController.h"
#import "REMMapViewController.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"
#import "DCColumnWrapper.h"
#import "DCLineWrapper.h"
#import "DCPieWrapper.h"
#import "DCPieChartView.h"
#import "DCLabelingWrapper.h"
#import "REMEnergyLabellingLevelData.h"
#import "REMLocalizeKeys.h"
#import "REMUserValidationModel.h"
#import "DCChartEnum.h"
#import "DCXYChartBackgroundBand.h"

@interface REMSplashScreenController ()


@property (nonatomic,weak) REMLoginCarouselController *carouselController;


@end

@implementation REMSplashScreenController

- (void)loadView
{
    [super loadView];
    
    if(self){
        [self loadBackground];
    }
}

-(void)loadBackground
{
    UIImage *backgroundImage = REMIMG_SplashScreenBackgroud; ///*[self isAlreadyLogin] ? REMIMG_MapBlur : */REMLoadImageResource(@"SplashScreenBackgroud", @"jpg");
    
    UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    background.frame = REMISIOS7 ? CGRectMake(0, 0, kDMScreenWidth, kDMScreenHeight) : CGRectMake(0, -20, kDMScreenWidth, kDMScreenHeight);
    
    [self.view addSubview:background];
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
//    [self oscarTest];
    if([self isAlreadyLogin]){
        //perform splash map segue
        [self showMapView];
    }
    else{
        //play login carousel
        [self showLoginView:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGFloat distance = 40;
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= distance;
        rect.size.height += distance;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += distance;
        rect.size.height -= distance;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(BOOL)isAlreadyLogin
{
    return REMAppContext.currentUser!=nil && REMAppContext.currentCustomer!=nil && [REMAppContext.currentUser.isDemo boolValue] == NO;
}


- (void)showLoginView:(BOOL)isAnimated
{
    if(self.carouselController!=nil){
        [self.carouselController.view removeFromSuperview];
        [self.carouselController removeFromParentViewController];
        
        self.carouselController.view = nil;
        self.carouselController = nil;
    }
    
    self.carouselController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginCarousel"];
    UIView *carouselView = self.carouselController.view;
    carouselView.frame = self.view.bounds;
    
    [self addChildViewController:self.carouselController];
    [self.view addSubview:carouselView];
    
    self.carouselController.splashScreenController = self;
    
    [self.carouselController playCarousel:isAnimated];
}

- (void)showMapView
{
    [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegue_SplashToLogin] == YES)
    {
        REMLoginCarouselController *loginCarouselController = segue.destinationViewController;
        loginCarouselController.splashScreenController = self;
    }
    if([segue.identifier isEqualToString:kSegue_SplashToMap]){
        REMMapViewController *mapController = segue.destinationViewController;
        mapController.isInitialPresenting = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return UIStatusBarStyleLightContent;
#else
    return UIStatusBarStyleDefault;
#endif
}

-(void)oscarTest {
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.xtype = @"columnchartcomponent";
    syntax.step = [NSNumber numberWithInt: REMEnergyStepDay];
    NSMutableArray* timeRanges = [[NSMutableArray alloc]initWithCapacity:1];
    REMTimeRange* r = [[REMTimeRange alloc]initWithStartTime:[NSDate dateWithTimeIntervalSince1970:0] EndTime:[NSDate dateWithTimeIntervalSince1970:86400*12]];
    [timeRanges setObject:r atIndexedSubscript:0];
    syntax.timeRanges = timeRanges;
    syntax.params = @{@"benchmarkOption":@{@"benchmarkText":@"TEST全行业Benckmark"}};
    
    REMEnergyViewData* energyViewData = [[REMEnergyViewData alloc]init];
    NSMutableArray* sereis = [[NSMutableArray alloc]init];
    for (int sIndex = 0; sIndex < 3; sIndex++) {
        NSMutableArray* energyDataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 100; i++) {
            REMEnergyData* data = [[REMEnergyData alloc]init];
            data.quality = REMEnergyDataQualityGood;
            //            if (i%5==0) {
            //
            //            } else {
            data.dataValue = [NSNumber numberWithInt:(i+1)*10*(sIndex+1)];
            //            }
            data.localTime = [NSDate dateWithTimeIntervalSince1970:i*86400];
            [energyDataArray addObject:data];
        }
        REMTargetEnergyData* sData = [[REMTargetEnergyData alloc]init];
        sData.energyData = energyDataArray;
        sData.target = [[REMEnergyTargetModel alloc]init];
        sData.target.targetId = @(1);
        sData.target.name = @"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF";
        sData.target.uomId = 0;
        sData.target.uomName = [NSString stringWithFormat:@"UOM%i", 0];
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
        frame = CGRectMake(0, 0, 222, 108);
    } else {
        style = [DCChartStyle getMaximizedStyle];
        frame = CGRectMake(0, 0, 974, 605);
    }
    
    DWrapperConfig* config = [[DWrapperConfig alloc]init];
    config.step = REMEnergyStepDay;
    config.stacked = NO;
    config.calendarType = REMCalendarTypeNone;
    config.isUnitOrRatioChart = NO;
    config.isMultiTimeChart = NO;
//    DCPieWrapper* pieWrapper = [[DCPieWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:config style:style];
//    [self.view addSubview:pieWrapper.view];
//    self.carouselController = pieWrapper;
//    DCColumnWrapper* columnWidget = [[DCColumnWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:config style:style];
//    columnWidget.view.backgroundColor = [UIColor blackColor];
//    columnWidget.view.hasVGridlines = YES;
//    columnWidget.view.graphContext.hGridlineAmount = 4;
//    self.carouselController = columnWidget;
//    [self.view addSubview:columnWidget.view];
    
    DCLineWrapper* lineWidget = [[DCLineWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:config style:style];
    lineWidget.view.backgroundColor = [UIColor blackColor];
    NSMutableArray* bands = [[NSMutableArray alloc]init];
    DCRange* bandRange = [[DCRange alloc]initWithLocation:0 length:20];
    DCXYChartBackgroundBand* b = [[DCXYChartBackgroundBand alloc]init];
    b.range = bandRange;
    b.color = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.5];
    b.axis = lineWidget.view.yAxisList[0];
    [bands addObject:b];
    [lineWidget.view setBackgoundBands:bands];
    [self.view addSubview:lineWidget.view];
    self.carouselController = lineWidget;
    
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
    
    //    DCLabelingWrapper* labelingWrapper = [[DCLabelingWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
    //    self.plotSource = labelingWrapper;
    //    [labelingWrapper getView].backgroundColor = [UIColor whiteColor];
    //    [self.view addSubview:[labelingWrapper getView]];
    //    labelingWrapper.delegate = self;
}

//-(void)buttonPressed:(UIButton*)btn {
//    DCColumnWrapper* columnWidget = self.carouselController;
//    [columnWidget switchSeriesTypeAtIndex:0];
//}
//
//-(void)buttonPressed1:(UIButton*)btn {
//    DCColumnWrapper* columnWidget = self.carouselController;
//    [columnWidget switchSeriesTypeAtIndex:1];
//}
//
//-(void)buttonPressed2:(UIButton*)btn {
//    DCColumnWrapper* columnWidget = self.carouselController;
//    [columnWidget switchSeriesTypeAtIndex:2];
//}
@end
