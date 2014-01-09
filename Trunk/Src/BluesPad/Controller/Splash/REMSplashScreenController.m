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
#import "REMBuildingOverallModel.h"
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
#import "REMCustomerModel.h"
#import "REMUserModel.h"
#import "REMUserValidationModel.h"
#import "REMChartHeader.h"
#import "DCXYChartBackgroundBand.h"

@interface REMSplashScreenController ()

@property (nonatomic,weak) UIView *normalLogo;
@property (nonatomic,weak) UIView *flashLogo;
@property (nonatomic,weak) UIView *copyrightView;

@property (nonatomic,weak) REMLoginCarouselController *carouselController;

@property (nonatomic) DAbstractChartWrapper* plotSource;

@end

@implementation REMSplashScreenController

- (void)loadView
{
    [super loadView];
    
    if(self){
        BOOL isAlreadyLogin = [self isAlreadyLogin];
        UIImage *backgroundImage = isAlreadyLogin ? REMIMG_DefaultMap : REMLoadImageResource(@"SplashScreenBackgroud", @"jpg");
        
        [self loadBackground:backgroundImage];
    }
}

-(void)loadBackground:(UIImage *)image
{
    UIImageView *background = [[UIImageView alloc] initWithImage:image];
    background.frame = REMISIOS7 ? CGRectMake(0, 0, kDMScreenWidth, kDMScreenHeight) : CGRectMake(0, -20, kDMScreenWidth, kDMScreenHeight);
    
    [self.view addSubview:background];
}


- (void)loadLogoView
{
    //Normal logo and flash logo
    if(self.logoView != nil){
        return;
    }
    
    CGSize logoSize = REMIMG_SplashScreenLogo_Common.size;
    UIImageView *normalLogo = [[UIImageView alloc] initWithImage:REMIMG_SplashScreenLogo_Common];
    UIImageView *flashLogo = [[UIImageView alloc] initWithImage:REMIMG_SplashScreenLogo_Flash];
    flashLogo.alpha = 0.0f;
    
    //Title label
    NSString *titleText = REMLocalizedString(@"Splash_Title");
    UIFont *font = [UIFont systemFontOfSize:kDMSplash_TitleLabelFontSize];
    CGSize labelSize = [titleText sizeWithFont:font];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((logoSize.width - labelSize.width) / 2, logoSize.height + kDMSplash_TitleLabelTopOffsetRelativeToLogo, labelSize.width, labelSize.height)];
    titleLabel.text = titleText;
    titleLabel.font = font;
    titleLabel.textColor = [REMColor colorByHexString:kDMSplash_TitleLabelFontColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    //logo view
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake((kDMScreenWidth-logoSize.width)/2, kDMSplash_LogoViewTopOffset, logoSize.width, logoSize.height + kDMSplash_TitleLabelTopOffsetRelativeToLogo + labelSize.height)];
    [logoView addSubview:normalLogo];
    [logoView addSubview:flashLogo];
    [logoView addSubview:titleLabel];
    
    [self.view addSubview:logoView];
    
    self.logoView = logoView;
    self.normalLogo = normalLogo;
    self.flashLogo = flashLogo;
}

- (void)loadCopyrightView
{
    if(self.copyrightView!=nil){
        return;
    }
    
    NSString *copyrightText = REMLocalizedString(@"Splash_Copyright");
    UIFont *font = [UIFont systemFontOfSize:kDMSplash_CopyrightLabelFontSize];
    CGSize labelSize = [copyrightText sizeWithFont:font];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDMScreenWidth - labelSize.width)/2, REMDMCOMPATIOS7(kDMScreenHeight-labelSize.height-kDMSplash_CopyrightLabelBottomOffset-kDMStatusBarHeight), labelSize.width, labelSize.height)];
    copyrightLabel.text = copyrightText;
    copyrightLabel.font = font;
    copyrightLabel.textColor = [REMColor colorByHexString:kDMSplash_CopyrightLabelFontColor];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:copyrightLabel];
    self.copyrightView = copyrightLabel;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
//    [self oscarTest];
    
    if([self isAlreadyLogin]){
        //perform splash map segue
        [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
    }
    else{
        //play login carousel
        [self showLoginView:YES];
    }
    
    
    //decide where to go
    
//    if([self isAlreadyLogin]){
//        //if network is ok and (user or customer does not exist) goto login
//        //else goto map
//        BOOL isNoConnect = [REMNetworkHelper checkIsNoConnect];
//        
//        if(isNoConnect){
//            [self breathShowMapView:YES:nil];
//        }
//        else{
//            REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserCustomerValidate parameter:@{@"userName":REMAppCurrentUser.name,@"customerId":REMAppCurrentCustomer.customerId}];
//            [store access:^(id data) {
//                REMUserValidationModel *validationResult = [[REMUserValidationModel alloc] initWithDictionary:data];
//                
//                if(validationResult.status == REMUserValidationSuccess){
//                    [self breathShowMapView:YES:nil];
//                }
//                else{
//                    //clear login info, TODO:should prompt user that will logout
//                    [REMAlertHelper alert:REMLocalizedString(@"Login_NotAuthorized")];
//                    
//                    REMUserModel *currentUser = [REMApplicationContext instance].currentUser;
//                    REMCustomerModel *currentCustomer = [REMApplicationContext instance].currentCustomer;
//                    
//                    [currentUser kill];
//                    [currentCustomer kill];
//                    currentUser = nil;
//                    currentCustomer = nil;
//                    
//                    [REMApplicationContext destroy];
//                    
//                    [self breathShowLoginView];
//                }
//            } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
//                [self breathShowMapView:YES:nil];
//            }];
//        }
//    }
//    else{
//        [self breathShowLoginView];
//    }
}

-(void)breathShowMapView:(BOOL)isAfterBreathOnce :(void (^)(void))completed
{
    void (^breathLoadMapView)(void) = ^(void){
        [self breathAnimation:nil];
        
        SEL selector = @selector(breathAnimation:);
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:selector]];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 invocation:invocation repeats:YES];
        
        [self showMapView:^(void){
            if(timer != nil && [timer isValid]){
                [timer invalidate];
            }
            
            if(completed)
                completed();
        }];
    };
    
    if(isAfterBreathOnce == NO){
        breathLoadMapView();
    }
    else{
        [self breathAnimation:breathLoadMapView];
    }
}

-(void)breathShowLoginView
{
    [self breathAnimation:^(void){
        [self.logoView setHidden:YES];
        [self showLoginView:YES];
    }];
}

-(void)showLogoView
{
    if(self.carouselController!=nil){
        [self.carouselController.view removeFromSuperview];
        [self.carouselController removeFromParentViewController];
    }
    
    [self.logoView setHidden:NO];
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
    REMChartStyle* style = nil;
    CGRect frame;
    BOOL mini = NO;
    if (mini) {
        style = [REMChartStyle getMinimunStyle];
        frame = CGRectMake(0, 0, 222, 108);
    } else {
        style = [REMChartStyle getMaximizedStyle];
        frame = CGRectMake(0, 0, 974, 605);
    }
    
//    DCPieWrapper* pieWrapper = [[DCPieWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
//    [self.view addSubview:pieWrapper.view];
//    self.plotSource = pieWrapper;
    DCColumnWrapper* columnWidget = [[DCColumnWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
    self.plotSource = columnWidget;
    columnWidget.view.backgroundColor = [UIColor blackColor];
    columnWidget.view.hasVGridlines = YES;
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
    
//    DCLabelingWrapper* labelingWrapper = [[DCLabelingWrapper alloc]initWithFrame:frame data:energyViewData widgetContext:syntax style:style];
//    self.plotSource = labelingWrapper;
//    [labelingWrapper getView].backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:[labelingWrapper getView]];
//    labelingWrapper.delegate = self;
}

-(void)buttonPressed:(UIButton *)button {
    [self showOrHideAtIndex:0];
}
-(void)showOrHideAtIndex:(NSUInteger)index {
    if ([self.plotSource isKindOfClass:[DCTrendWrapper class]]) {
        [(DCTrendWrapper*)self.plotSource setHiddenAtIndex:index hidden:![((DCTrendWrapper*)self.plotSource).view.seriesList[index] hidden]];
    } else if ([self.plotSource isKindOfClass:[DCPieWrapper class]]) {
        [(DCPieWrapper*)self.plotSource setHiddenAtIndex:index hidden:![((DCPieWrapper*)self.plotSource).view.series.datas[index] hidden]];
    }
}
-(void)buttonPressed1:(UIButton *)button {
    [self showOrHideAtIndex:1];
}
-(void)buttonPressed2:(UIButton *)button {
    [self showOrHideAtIndex:2];
}


-(void)breathAnimation:(id)completed
{
    CGFloat animationTime = 1.5;
    
    CGFloat flashOriginalAlpha = 0;
    CGFloat flashFinalAlpha = 0.9;
    CGFloat normalOriginalAlpha = 1;
    CGFloat normalFinalAlpha = 1;

    self.flashLogo.alpha = flashOriginalAlpha;
    self.normalLogo.alpha = normalOriginalAlpha;
    [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.flashLogo.alpha = flashFinalAlpha;
        self.normalLogo.alpha = normalFinalAlpha;
    } completion:^(BOOL finished) {
        self.flashLogo.alpha = flashFinalAlpha;
        self.normalLogo.alpha = normalFinalAlpha;
        [UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.flashLogo.alpha = flashOriginalAlpha;
            self.normalLogo.alpha = normalOriginalAlpha;
        } completion:^(BOOL finished){
            if(completed!=nil)
                ((void (^)(void))completed)();
        }];
    }];
}

-(BOOL)isAlreadyLogin
{
    REMApplicationContext *context = REMAppContext;
    
    return context.currentUser!=nil && context.currentCustomer!=nil;
}


- (void)showLoginView:(BOOL)isAnimated
{
    [self.logoView setHidden:YES];
    if(self.carouselController!=nil){
        [self.carouselController playCarousel:isAnimated];
    }
    else{
        self.carouselController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginCarousel"];
        self.carouselController.showAnimation = isAnimated;
        UIView *carouselView = self.carouselController.view;
        carouselView.frame = self.view.bounds;
        
        [self addChildViewController:self.carouselController];
        [self.view addSubview:carouselView];
        
        self.carouselController.splashScreenController = self;
        
        [self.carouselController playCarousel:isAnimated];
    }
}

- (void)showMapView:(void (^)(void))loadCompleted
{
    NSDictionary *parameter = @{@"customerId":REMAppCurrentCustomer.customerId};
    REMDataStore *buildingStore = [[REMDataStore alloc] initWithName:REMDSBuildingInfo parameter:parameter];
    
    [buildingStore access:^(id data) {
        if([data count] <= 0){
            [REMAlertHelper alert:REMLocalizedString(@"Login_NotAuthorized")];
            
            if([self isAlreadyLogin]){
                [self showLoginView:NO];
            }
            
            return;
        }
        
        self.buildingInfoArray = [[NSMutableArray alloc] init];
        
        for(NSDictionary *item in (NSArray *)data){
            [self.buildingInfoArray addObject:[[REMBuildingOverallModel alloc] initWithDictionary:item]];
        }
        
        NSDictionary *parameter = @{@"customerId":REMAppCurrentCustomer.customerId};
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter];
        logoStore.groupName = nil;
        logoStore.maskContainer = nil;
        
        [logoStore access:^(id data) {
            UIImage *logo = nil;
            if(data != nil && [data length] > 2) {
                logo = [REMImageHelper parseImageFromNSData:data withScale:1.0];
            }
            
            REMAppCurrentLogo = logo;
            
            if(loadCompleted!=nil)
                loadCompleted();
            
            [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
        } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
            if(loadCompleted!=nil)
                loadCompleted();
            
            [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
        }];
        
        
    } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
        if(error.code != -1001 && error.code != 306) {
            [REMAlertHelper alert:REMLocalizedString(kLNCommon_ServerError)];
        }
        
        [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegue_SplashToLogin] == YES)
    {
        REMLoginCarouselController *loginCarouselController = segue.destinationViewController;
        loginCarouselController.splashScreenController = self;
    }
    else if([segue.identifier isEqualToString:kSegue_SplashToMap] == YES)
    {
        REMMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.buildingInfoArray = self.buildingInfoArray;
        mapViewController.isInitialPresenting = YES;
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


@end
