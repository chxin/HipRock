//
//  REMViewController.m
//  BluesPad
//
//  Created by zhangfeng on 6/26/13.
//
//

#import "REMLoginViewController.h"
#import "REMDataAccessor.h"
#import "REMServiceUrl.h"
#import "REMApplicationInfo.h"
#import "REMStorage.h"
#import "REMCommonHeaders.h"

@interface REMLoginViewController ()
@property  (nonatomic,strong) NSArray *favoriteDashboard;
@end

@implementation REMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewTouchDown:(id)sender
{
    [self.view endEditing:YES];
}

- (void) gotoMainView
{
    NSDictionary *param = @{
                            @"customerId": [REMApplicationContext instance].currentCustomer.customerId
                            };
    __weak REMLoginViewController *weakSelf= self;
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSDashboardFavorite parameter:param];
    store.isStoreLocal = YES;
    store.isAccessLocal = YES;
    
    [REMDataAccessor access:store success:^(NSArray *ret){
        [weakSelf myfavoriteSuccess:ret];
        [weakSelf callServicesBesidesMyfavorite];
       // [self performSegueWithIdentifier:@"loginSegue" sender:self];
        
        //should call other service
    }error:^(NSError *error, id response){
        
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }];
}

- (void)myfavoriteSuccess:(NSArray *)ret
{
    self.favoriteDashboard=ret;
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"loginSegue"] == YES)
    {
        REMMainViewController *mainController=(REMMainViewController *)segue.destinationViewController;
        mainController.favoriateDashboard=self.favoriteDashboard;
    }
}


#pragma mark -
#pragma mark TODO: call other service
-(void)callServicesBesidesMyfavorite
{
    
}








@end
