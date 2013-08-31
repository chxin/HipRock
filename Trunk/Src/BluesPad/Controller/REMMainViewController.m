//
//  REMMainViewController.m
//  Blues
//
//  Created by TanTan on 7/8/13.
//
//

#import "REMMainViewController.h"

@interface REMMainViewController ()
@property (nonatomic) BOOL isDashboardMax;
@end

@implementation REMMainViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    self.isDashboardMax=NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"dashboardContainerSegue"] ==YES)
    {
        REMDashboardMainViewController *dashboardController=  segue.destinationViewController;
        dashboardController.favoriteDashboard=self.favoriateDashboard;
        dashboardController.mainController=self;
    }
    
    if([segue.identifier isEqualToString:@"detailSegue"] ==YES)
    {
        
            if(self.currentMaxData != nil)
            {
                REMWidgetMaxViewController *maxController =(REMWidgetMaxViewController *)segue.destinationViewController;
                
                maxController.widgetObj=self.currentWidgetObj;
                maxController.data=self.currentMaxData;
                
            }
            
        
    }
}

- (void)maxDashboardContent:(void(^)(BOOL finished))complete
{
    if(self.isDashboardMax){
        if(complete!=nil){
            complete(YES);
            return;
        }
    }
    
    __weak REMMainViewController *weakSelf=self;
    CGPoint center = self.dashboardContainer.center;
    CGPoint newCenter = CGPointMake(563, center.y);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.dashboardContainer.center=newCenter;
        
    } completion:^(BOOL finished){
        if(complete!=nil){
            complete(finished);
        }
    }];
    self.isDashboardMax=YES;
}

- (void)minDashboardContent;
{
    __weak REMMainViewController *weakSelf=self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
        weakSelf.dashboardContainer.center=CGPointMake(733, self.dashboardContainer.center.y);
        
    } completion:^(BOOL finished){
    
       
    }];
    self.isDashboardMax=NO;
    
}

- (void)moveDashboardContent:(CGFloat)x
{
    self.dashboardContainer.center=CGPointMake(self.dashboardContainer.center.x+x, self.dashboardContainer.center.y);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
