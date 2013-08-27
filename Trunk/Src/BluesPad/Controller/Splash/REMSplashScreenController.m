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

@end

@implementation REMSplashScreenController

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
    self.navigationController.navigationBarHidden = YES;
    
    //decide where to go
    [self recoverAppContext];
    
    if([self isLogin]){
        NSLog(@"%@",@"breath");
        [self breathAnimation:nil];
        __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(breathAnimation:) userInfo:nil repeats:YES];
        
        NSLog(@"%@",@"load data");
        [self showBuildingView:^(void){
            [timer invalidate];
            timer = nil;
            
            [self.logoView setHidden:YES];
        }];
    }
    else{
        [self breathAnimation:^(void){
            [self.logoView setHidden:YES];
            [self showLoginView];
        }];
    }
}


-(void)breathAnimation:(void (^)(void))completed
{
    self.flashLogo.alpha = 0;
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.flashLogo.alpha = 0.8;
    } completion:^(BOOL finished) {
        self.flashLogo.alpha = 0.8;
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.flashLogo.alpha = 0;
        } completion:^(BOOL finished){
            if(completed!=nil)
                completed();
        }];
    }];
}

-(BOOL)isLogin
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

- (void)showLoginView
{
    if(self.carouselController == nil){
        self.carouselController = [[self storyboard] instantiateViewControllerWithIdentifier:@"loginCarousel"];
    }
    
    UIView *carouselView = self.carouselController.view;
    
    [self addChildViewController:self.carouselController];
    [self.view addSubview:carouselView];
    
    self.carouselController.splashScreenController = self;
    
    carouselView.frame = CGRectMake(self.view.bounds.origin.x-1024, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        carouselView.frame = self.view.bounds;
    }];
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
