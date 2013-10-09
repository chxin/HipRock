//
//  REMSplashScreenController.m
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import "REMSplashScreenController.h"
#import "REMLoginCarouselController.h"
#import "REMCommonHeaders.h"
#import "REMBuildingViewController.h"
#import "REMBuildingOverallModel.h"
#import "REMMapViewController.h"

@interface REMSplashScreenController ()

@property (nonatomic,strong) NSMutableArray *buildingInfoArray;
@property (nonatomic,strong) REMLoginCarouselController *carouselController;
@property (nonatomic,strong) NSTimer *timer;



@end

@implementation REMSplashScreenController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    //decide where to go
    [self recoverAppContext];
    
    if([self isAlreadyLogin]){
        [self breathAnimation:^(void){
            SEL selector = @selector(breathAnimation:);
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:selector]];
            [invocation setTarget:self];
            [invocation setSelector:selector];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 invocation:invocation repeats:YES];
            
            [self showMapView:^(void){
                if(self.timer != nil){
                    if([self.timer isValid])
                        [self.timer invalidate];
                    
                    self.timer = nil;
                }
                
                [self.logoView setHidden:YES];
            }];
        }];
    }
    else{
        [self breathAnimation:^(void){
            [self.logoView setHidden:YES];
            [self showLoginView:YES];
        }];
    }
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
    REMApplicationContext *context = [REMApplicationContext instance];
    
    return context.currentUser!=nil && context.currentCustomer!=nil;
}

-(void)recoverAppContext
{
    REMUserModel *storedUser = [REMUserModel getCached];
    REMCustomerModel *storedCustomer = [REMCustomerModel getCached];
    
    [[REMApplicationContext instance] setCurrentUser:storedUser];
    [[REMApplicationContext instance] setCurrentCustomer:storedCustomer];
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
    
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.type = @"line";
    syntax.step = [NSNumber numberWithInt: REMEnergyStepHour];
    
    NSDictionary *parameter = @{@"customerId":[REMApplicationContext instance].currentCustomer.customerId};
    REMDataStore *buildingStore = [[REMDataStore alloc] initWithName:REMDSBuildingInfo parameter:parameter];
    //buildingStore.isAccessLocal = YES;
    buildingStore.groupName = nil;
    buildingStore.maskContainer = nil;
    
    [REMDataAccessor access:buildingStore success:^(id data) {
        self.buildingInfoArray = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for(NSDictionary *item in (NSArray *)data){
            [self.buildingInfoArray addObject:[[REMBuildingOverallModel alloc] initWithDictionary:item]];
        }
        
        NSDictionary *parameter = @{@"customerId":[REMApplicationContext instance].currentCustomer.customerId};
        REMDataStore *logoStore = [[REMDataStore alloc] initWithName:REMDSCustomerLogo parameter:parameter];
        //buildingStore.isAccessLocal = YES;
        logoStore.groupName = nil;
        logoStore.maskContainer = nil;
        
        [REMDataAccessor access:logoStore success:^(id data) {
            if(data == nil || [data length] == 2) return;
            UIImage *view = [REMImageHelper parseImageFromNSData:data];
            
            [REMApplicationContext instance].currentCustomerLogo=view;
            
      
            
            
            
            //test air quality interface
            if(loadCompleted!=nil)
                loadCompleted();
            
            [self performSegueWithIdentifier:kSplashToMapSegue sender:self];
        }];
        
        
    } error:^(NSError *error, id response) {
        if(error.code != 1001) {
            [REMAlertHelper alert:@"数据加载错误"];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSplashToLoginSegue] == YES)
    {
        REMLoginCarouselController *loginCarouselController = segue.destinationViewController;
        loginCarouselController.splashScreenController = self;
    }
    else if([segue.identifier isEqualToString:kSplashToMapSegue] == YES)
    {
        REMMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.buildingInfoArray = self.buildingInfoArray;
        self.buildingInfoArray=nil;
        mapViewController.splashScreenController = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
