//
//  REMMainViewController.m
//  Blues
//
//  Created by 张 锋 on 9/26/13.
//
//

#import "REMMainNavigationController.h"

@interface REMMainNavigationController ()

@end

@implementation REMMainNavigationController{
    NSDictionary *controllerInstances;
}

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
