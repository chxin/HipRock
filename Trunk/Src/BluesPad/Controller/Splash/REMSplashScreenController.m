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
    UIImage *backgroundImage = /*isAlreadyLogin ? REMIMG_DefaultMap :*/ REMLoadImageResource(@"SplashScreenBackgroud", @"jpg");
    
    UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    background.frame = REMISIOS7 ? CGRectMake(0, 0, kDMScreenWidth, kDMScreenHeight) : CGRectMake(0, -20, kDMScreenWidth, kDMScreenHeight);
    
    [self.view addSubview:background];
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    if([self isAlreadyLogin]){
        //perform splash map segue
        [self performSegueWithIdentifier:kSegue_SplashToMap sender:self];
    }
    else{
        //play login carousel
        [self showLoginView:YES];
    }
}


-(BOOL)isAlreadyLogin
{
    return REMAppContext.currentUser!=nil && REMAppContext.currentCustomer!=nil;
}


- (void)showLoginView:(BOOL)isAnimated
{
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
    else if([segue.identifier isEqualToString:kSegue_SplashToMap] == YES)
    {
//        REMMapViewController *mapViewController = segue.destinationViewController;
//        mapViewController.buildingInfoArray = self.buildingInfoArray;
//        mapViewController.isInitialPresenting = YES;
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
