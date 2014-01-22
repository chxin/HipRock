/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMainViewController.m
 * Created      : 张 锋 on 9/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMMainNavigationController.h"
#import "REMSplashScreenController.h"
#import "REMMaxWidgetSegue.h"
#import "REMBuildingEntranceSegue.h"
#import "REMStoryboardDefinitions.h"
#import "REMMapGallerySegue.h"
#import "REMColor.h"

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
    if (REMISIOS7 == YES) {
        [[UIBarButtonItem appearance] setTintColor:[REMColor colorByHexString:@"#37ab3c"]];
        [[UINavigationBar appearance] setTintColor:[REMColor colorByHexString:@"#37ab3c"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    //gallery to map
    if([identifier isEqualToString:kSegue_GalleryToMap]){
        return [[REMMapGallerySegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }
    
    //building to map
    if([identifier isEqualToString:kSegue_BuildingToMap]){
        return [[REMBuildingEntranceSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }
    
    //building to gallery
    if([identifier isEqualToString:kSegue_BuildingToGallery]){
        return [[REMBuildingEntranceSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }
    
    //chart to dashboard
    if([identifier isEqualToString:@"exitWidgetSegue"]==YES){
        return [[REMMaxWidgetSegue alloc]initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }
    
    UIStoryboardSegue *segue=[super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    
    return segue;
}

-(void)logout
{
    REMApplicationContext *context=REMAppContext;
    REMUserModel *currentUser = context.currentUser;
    REMCustomerModel *currentCustomer = context.currentCustomer;
    
    [currentUser kill];
    [currentCustomer kill];
    currentUser = nil;
    currentCustomer = nil;
    context.updateManager = nil;
    
    [REMApplicationContext destroy];
    
    [REMStorage clearSessionStorage];
    [REMStorage clearOnApplicationActive];
    
    [self popToRootViewControllerAnimated:YES];
    
    REMSplashScreenController *splashController = [self getChildControllerInstanceOfClass:[REMSplashScreenController class]];
    [splashController showLoginView:NO];
}

-(void)presentInitialView:(void (^)(void))completed
{
    REMMapViewController *mapController = [self getChildControllerInstanceOfClass:[REMMapViewController class]];
    mapController.isInitialPresenting = true;
    
    if([self.topViewController isEqual:mapController] == NO){
        [self popToViewController:mapController animated:YES];
        [mapController updateView];
        if(completed) completed();
//        [self popToViewController:mapController animated:YES onCompletion:^{
//            [mapController updateView];
//            if(completed) completed();
//        }];
    }
    else{
        [mapController updateView];
        if(completed) completed();
    }
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
