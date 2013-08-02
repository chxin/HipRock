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

@interface REMSplashScreenController ()

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
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(runTimer:) userInfo:nil repeats:NO];
    
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
        
        [self gotoMainView];
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

- (void)gotoMainView
{
    [self performSegueWithIdentifier:@"splashToBuildingSegue" sender:self];
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
        buildingViewController.splashScreenController = self;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
