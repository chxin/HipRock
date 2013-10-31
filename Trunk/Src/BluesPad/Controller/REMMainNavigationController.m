//
//  REMMainViewController.m
//  Blues
//
//  Created by 张 锋 on 9/26/13.
//
//

#import "REMMainNavigationController.h"
#import "REMSplashScreenController.h"
#import "REMMaxWidgetSegue.h"

@interface REMMainNavigationController ()

@end

@implementation REMMainNavigationController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    if([identifier isEqualToString:@"exitWidgetSegue"]==YES){
        return [[REMMaxWidgetSegue alloc]initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }
    
    
    UIStoryboardSegue *segue=[super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    
    return segue;
}

-(void)presentLoginView:(void (^)(void))completed
{
    REMSplashScreenController *splashController = [self getChildControllerInstanceOfClass:[REMSplashScreenController class]];
    
    [self popToRootViewControllerAnimated:YES];
    [splashController showLoginView:NO];
    if(completed!=nil)
        completed();
}

-(void)presentInitialView:(void (^)(void))completed
{
    //load data, when load finised, show map view
    REMSplashScreenController *splashController = [self getChildControllerInstanceOfClass:[REMSplashScreenController class]];
    
    [splashController showMapView:completed];
}

-(id)getChildControllerInstanceOfClass:(Class)cls
{
    if(self.childViewControllers == nil || self.childViewControllers.count <= 0)
        return nil;
    
    for(UIViewController *controller in self.childViewControllers){
        if(controller.class == cls)
            return controller;
    }
    
    return nil;
}

@end
