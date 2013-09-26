//
//  REMDashboardLeftNavigationController.m
//  Blues
//
//  Created by TanTan on 7/10/13.
//
//

#import "REMDashboardLeftNavigationController.h"
#import "REMMainDashboardViewController.h"

@interface REMDashboardLeftNavigationController ()
@property (nonatomic) CGFloat x;
@end

@implementation REMDashboardLeftNavigationController

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
    //self.x = self.view.center.x;
    //NSLog(@"start x:%f",self.x);
    self.x=0;
    UIPanGestureRecognizer  *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(minDashboard:)];
    [self.view addGestureRecognizer:panGesture];
    
    
    
    //CALayer *layer = self.view.layer;
    //layer.shadowColor = [UIColor blackColor].CGColor;
    //layer.shadowOffset = CGSizeMake(4,0);
    //layer.shadowOpacity = 1;
    //layer.shadowRadius = 20.0;
}

- (void)minDashboard:(UIPanGestureRecognizer *)pan
{
    
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation= [pan translationInView:self.view];
        
        self.x+=translation.x;
        
        REMMainDashboardViewController *mainController = (REMMainDashboardViewController *)self.parentViewController.parentViewController;
        
        [mainController moveDashboardContent:translation.x];
        
        //self.x=translation.x;
        //NSLog(@"translation.x:%f",self.x);
        //NSLog(@"translation.x:%f",self.view.frame.origin.x);
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];
        
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        //CGPoint translation= [pan translationInView:self.view];
        REMMainDashboardViewController *mainController = (REMMainDashboardViewController *)self.parentViewController.parentViewController;
        //NSLog(@"translation.x:%f",self.view.center.x);
        if(self.x<= 170 )
        {
            [mainController maxDashboardContent:nil];
        }
        else{
            [mainController minDashboardContent];
        }
        
        self.x=0;
        [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
