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
#import "REMTrend.h"
#import "REMTestChartView.h"
#import "REMDimensions.h"
#import "DChartColumnWrapper.h"

@interface REMSplashScreenController ()

@property (nonatomic,weak) REMLoginCarouselController *carouselController;
@property (nonatomic) NSMutableArray* plotSource;
@end

@implementation REMSplashScreenController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // iOS 7.0 supported
//    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
//        [self setNeedsStatusBarAppearanceUpdate];
//    }
    
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    //    [self.view addSubview:[[REMTrend alloc]initWithFrame:CGRectMake(100, 0, 924, 708)]];
    
    [self oscarTest];
    
    
    //decide where to go
//    [self recoverAppContext];
//    
//    if([self isAlreadyLogin]){
//        [self breathAnimation:^(void){
//            [self breathAnimation:nil];
//            
//            SEL selector = @selector(breathAnimation:);
//            
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:selector]];
//            [invocation setTarget:self];
//            [invocation setSelector:selector];
//            
//            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 invocation:invocation repeats:YES];
//            
//            [self showMapView:^(void){
//                if(timer != nil){
//                    if([timer isValid])
//                        [timer invalidate];
//                }
//            }];
//        }];
//    }
//    else{
//        [self breathAnimation:^(void){
//            [self.logoView setHidden:YES];
//            [self showLoginView:YES];
//        }];
//    }
}

-(void)oscarTest {
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.xtype = @"columnchartcomponent";
    syntax.step = [NSNumber numberWithInt: REMEnergyStepHour];
    NSMutableArray* timeRanges = [[NSMutableArray alloc]initWithCapacity:1];
    REMTimeRange* r = [[REMTimeRange alloc]initWithStartTime:[NSDate dateWithTimeIntervalSince1970:0] EndTime:[NSDate dateWithTimeIntervalSince1970:3600*10]];
    [timeRanges setObject:r atIndexedSubscript:0];
    syntax.timeRanges = timeRanges;
    
    REMEnergyViewData* energyViewData = [[REMEnergyViewData alloc]init];
    NSMutableArray* sereis = [[NSMutableArray alloc]init];
    for (int sIndex = 0; sIndex < 10; sIndex++) {
        NSMutableArray* energyDataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10000; i++) {
            if (i%5==0) continue;
            REMEnergyData* data = [[REMEnergyData alloc]init];
            data.quality = REMEnergyDataQualityGood;
            data.dataValue = [NSNumber numberWithInt:(i+1)*10*(sIndex+1)];
            data.localTime = [NSDate dateWithTimeIntervalSince1970:i*3600];
            [energyDataArray addObject:data];
        }
        REMTargetEnergyData* sData = [[REMTargetEnergyData alloc]init];
        sData.energyData = energyDataArray;
        sData.target = [[REMEnergyTargetModel alloc]init];
        sData.target.uomId = 0;
        sData.target.uomName = [NSString stringWithFormat:@"%i", sIndex%3];
        [sereis addObject:sData];
    }
    
    energyViewData.targetEnergyData = sereis;
    
    REMChartStyle* style = [REMChartStyle getMaximizedStyle];
    DChartColumnWrapper* columnWidget = [[DChartColumnWrapper alloc]initWithFrame:CGRectMake(0, 0, 1024, 748) data:energyViewData widgetContext:syntax style:style];
    columnWidget.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:columnWidget.view];
}

-(void)oscarTest2 {
    REMTestChartView* hostingView  = [[REMTestChartView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    
    
    [self.view addSubview:hostingView];
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

-(void)recoverAppContext
{
    REMUserModel *storedUser = [REMUserModel getCached];
    REMCustomerModel *storedCustomer = [REMCustomerModel getCached];
    
    [REMAppContext setCurrentUser:storedUser];
    [REMAppContext setCurrentCustomer:storedCustomer];
}

- (void)showLoginView:(BOOL)isAnimated
{
    if(self.carouselController!=nil){
        [self.carouselController.view removeFromSuperview];
        self.carouselController = nil;
    }
    
    self.carouselController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginCarousel"];
    self.carouselController.showAnimation = isAnimated;
    UIView *carouselView = self.carouselController.view;
    
    [self addChildViewController:self.carouselController];
    [self.view addSubview:carouselView];
    
    self.carouselController.splashScreenController = self;
    
    carouselView.frame = CGRectMake(self.view.bounds.origin.x-1024, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    
    if(isAnimated==YES)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            carouselView.frame = self.view.bounds;
        } completion:^(BOOL finished) {
            [self.carouselController initializationCarousel];
        }];
    }
    else{
        carouselView.frame = self.view.bounds;
    }
}

- (void)showMapView:(void (^)(void))loadCompleted
{
    //    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    //    syntax.type = @"line";
    //    syntax.step = [NSNumber numberWithInt: REMEnergyStepHour];
    
    NSDictionary *parameter = @{@"customerId":REMAppCurrentCustomer.customerId};
    REMDataStore *buildingStore = [[REMDataStore alloc] initWithName:REMDSBuildingInfo parameter:parameter];
    //buildingStore.isAccessLocal = YES;
    buildingStore.groupName = nil;
    buildingStore.maskContainer = nil;
    
    [REMDataAccessor access:buildingStore success:^(id data) {
        if([data count]<=0){
            [REMAlertHelper alert:REMLocalizedString(@"Login_NotAuthorized")];
        }
        
        self.buildingInfoArray = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for(NSDictionary *item in (NSArray *)data){
            [self.buildingInfoArray addObject:[[REMBuildingOverallModel alloc] initWithDictionary:item]];
        }
        
        NSDictionary *parameter = @{@"customerId":REMAppCurrentCustomer.customerId};
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter];
        //buildingStore.isAccessLocal = YES;
        logoStore.groupName = nil;
        logoStore.maskContainer = nil;
        
        [REMDataAccessor access:logoStore success:^(id data) {
            //TODO: what if customer logo is null?
            if(data == nil || [data length] == 2) return;
            
            UIImage *view = [REMImageHelper parseImageFromNSData:data];
            
            REMAppCurrentLogo = view;
            
            if(loadCompleted!=nil)
                loadCompleted();
            
            [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
        } error:^(NSError *error, id response) {
            //
            
            if(loadCompleted!=nil)
                loadCompleted();
            
            [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
        }];
        
        
    } error:^(NSError *error, id response) {
        if(error.code != 1001) {
            [REMAlertHelper alert:@"数据加载错误"];
        }
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

- (void)stopBreath
{
    [self.normalLogo.layer removeAllAnimations];
    [self.flashLogo.layer removeAllAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
#if __IPHONE_7_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    return UIStatusBarStyleLightContent;
#else
    return UIStatusBarStyleDefault;
#endif
}


@end
