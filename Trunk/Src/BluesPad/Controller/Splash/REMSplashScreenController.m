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

@interface REMSplashScreenController ()

@property (nonatomic,strong) NSMutableArray *buildingOveralls;
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
        SEL selector = @selector(breathAnimation:);
         
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:selector]];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 invocation:invocation repeats:YES];
        
        [self showBuildingView:^(void){
            if(self.timer != nil){
                if([self.timer isValid])
                    [self.timer invalidate];
                
                self.timer = nil;
            }
            
            [self.logoView setHidden:YES];
        }];
        
        [self breathAnimation:nil];
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
    CGFloat flashFinalAlpha = 0.8;
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
    self.carouselController = nil;
    self.carouselController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginCarousel"];    
    UIView *carouselView = self.carouselController.view;
    
    [self addChildViewController:self.carouselController];
    [self.view addSubview:carouselView];
    
    self.carouselController.splashScreenController = self;
    
    carouselView.frame = CGRectMake(self.view.bounds.origin.x-1024, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    
    if(isAnimated)
    {
        [UIView animateWithDuration:0.4 animations:^{
            carouselView.frame = self.view.bounds;
        }];
    }
}

- (void)showBuildingView:(void (^)(void))loadCompleted
{
    NSDictionary *parameter = @{@"customerId":[REMApplicationContext instance].currentCustomer.customerId};
    REMDataStore *buildingStore = [[REMDataStore alloc] initWithName:REMDSBuildingOverallData parameter:parameter];
    buildingStore.isStoreLocal = YES;
    buildingStore.isAccessLocal = YES;
    buildingStore.groupName = nil;
    buildingStore.maskContainer = nil;
    
    [REMDataAccessor access:buildingStore success:^(id data) {
        self.buildingOveralls = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for(NSDictionary *item in (NSArray *)data){
            [self.buildingOveralls addObject:[[REMBuildingOverallModel alloc] initWithDictionary:item]];
        }
        
        //test air quality interface
        if(loadCompleted!=nil)
            loadCompleted();
        
        [self performSegueWithIdentifier:@"splashToBuildingSegue" sender:self];
    } error:^(NSError *error, id response) {
        [REMAlertHelper alert:@"building数据加载错误"];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"splashToLoginSegue"] == YES)
    {
        REMLoginCarouselController *loginCarouselController = segue.destinationViewController;
        loginCarouselController.splashScreenController = self;
    }
    else if([segue.identifier isEqualToString:@"splashToBuildingSegue"] == YES)
    {
        REMBuildingViewController *buildingViewController = segue.destinationViewController;
        buildingViewController.buildingOverallArray = self.buildingOveralls;
        self.buildingOveralls=nil;
        buildingViewController.splashScreenController = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
