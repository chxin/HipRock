//
//  REMDashboardMainViewController.m
//  Blues
//
//  Created by TanTan on 7/8/13.
//
//

#import "REMDashboardMainViewController.h"

@interface REMDashboardMainViewController ()
@property (weak,nonatomic) UINavigationController *rightNavigationController;
@property (weak,nonatomic) REMDashboardRootViewController *rootDashboardController;
@property (nonatomic) BOOL isDashboardLoaded;
@end

@implementation REMDashboardMainViewController

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
    self.isDashboardLoaded = NO;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"leftDashboardSegue"] == YES)
    {
        REMDashboardLeftNavigationController *left=segue.destinationViewController;
        
        
        
        REMFavoriteTableViewController *favController = left.childViewControllers[0];
        
        favController.favoriteList=self.favoriteDashboard;
    }
    
    if ([segue.identifier isEqualToString:@"rightDashboardSegue"] ==YES)
    {
        self.rightNavigationController=segue.destinationViewController;
        self.rootDashboardController=self.rightNavigationController.childViewControllers[0];
        self.rootDashboardController.mainController=self.mainController;
    }
    
}



- (void)showDashboard:(REMDashboardObj *)dashboard
{
    
    
        
        REMMainViewController *main=(REMMainViewController *)self.parentViewController;
        [main maxDashboardContent:^(BOOL finished){
            
            if(self.isDashboardLoaded == NO){
                
                self.isDashboardLoaded=YES;
                [self.rootDashboardController goDashboard:dashboard];
            }
            else
            {
                [self.rootDashboardController backThenGoDashboard:dashboard];
            }

        }];
        
        
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
