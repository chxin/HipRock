//
//  REMDashboardRootViewController.m
//  Blues
//
//  Created by TanTan on 7/12/13.
//
//

#import "REMDashboardRootViewController.h"

@interface REMDashboardRootViewController ()
@property (nonatomic) BOOL isBack;
@property (nonatomic,strong) REMDashboardObj *dashboard;
@end

@implementation REMDashboardRootViewController

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
  
    
    
    self.isBack=NO;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden=NO;
}

- (void)goDashboard:(REMDashboardObj *)dashboard
{
    self.dashboard=dashboard;
    [self performSegueWithIdentifier:@"showDashboardSegue" sender:self];
    self.isBack=NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDashboardSegue"] == YES){
        REMDashboardViewController *dashboardController=  segue.destinationViewController;
        dashboardController.dashboard = self.dashboard;
        dashboardController.mainController=self.mainController;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    if(self.isBack == YES){
        [self goDashboard:self.dashboard];
    }
}

-(void)backThenGoDashboard:(REMDashboardObj *)dashboard
{
    self.isBack=YES;
    self.dashboard=dashboard;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
