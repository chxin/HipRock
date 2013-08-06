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
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTimer:) userInfo:nil repeats:NO];
    
    //decide where to go
}

- (void)runTimer:(id)timer
{
    REMUserModel *storedUser = [REMUserModel getCached];
    REMCustomerModel *storedCustomer = [REMCustomerModel getCached];
    
    if(storedUser!=nil && storedCustomer!=nil)
    {
        [[REMApplicationContext instance] setCurrentUser:storedUser];
        [[REMApplicationContext instance] setCurrentCustomer:storedCustomer];
        
        [self gotoBuildingView];
    }
    else
    {
        [self gotoLoginView];
    }
}

- (void)gotoLoginView
{
    [self performSegueWithIdentifier:@"splashToLoginSegue" sender:self];
}

- (void)gotoBuildingView
{
    NSDictionary *parameter = @{@"customerId":[REMApplicationContext instance].currentCustomer.customerId};
    REMDataStore *buildingStore = [[REMDataStore alloc] initWithName:REMDSEnergyBuildingOverall parameter:parameter];
    buildingStore.isStoreLocal = YES;
    buildingStore.isAccessLocal = YES;
    buildingStore.groupName = nil;
    buildingStore.maskContainer = nil;
    
    [REMDataAccessor access:buildingStore success:^(id data) {
        NSLog(@"building loaded: %d",[data count]);
        self.buildingOveralls = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for(NSDictionary *item in (NSArray *)data){
            [self.buildingOveralls addObject:[[REMBuildingOverallModel alloc] initWithDictionary:item]];
        }
        
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
        buildingViewController.buildingInfoArray = self.buildingOveralls;
        buildingViewController.splashScreenController = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
