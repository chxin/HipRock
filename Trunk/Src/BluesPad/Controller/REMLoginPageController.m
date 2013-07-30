//
//  REMLoginPageController.m
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "REMLoginPageController.h"
#import "REMAlertHelper.h"
#import "REMAppDelegate.h"
#import "REMSplashScreenController.h"
#import "REMCommonHeaders.h"

@interface REMLoginPageController ()

@end

@implementation REMLoginPageController

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
    
    self.inputView.layer.borderWidth = 2;
    self.inputView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    self.inputView.layer.cornerRadius = 10;
    
    //[self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginButtonPressed:(id)sender
{
    if([self.userNameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
    {
        [REMAlertHelper alert:@"请输入完整的用户名和密码"];
        return;
    }
    [self.errorImage setHidden:YES];
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    [loginInfo setValue:self.userNameTextField.text forKey:@"userName"];
    [loginInfo setValue:self.passwordTextField.text forKey:@"password"];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:loginInfo];
    store.maskContainer = self.view;
    store.isAccessLocal = NO;
    store.isStoreLocal = YES;
    store.groupName = nil;
    
    void (^successHandler)(id data) = ^(id data)
    {
        [self dataCallSuccess:data];
    };
    
    void (^errorHandler)(NSError *error, id response) = ^(NSError *error, id response)
    {
        [self dataCallFail:error result:response];
    };
    
    [REMDataAccessor access:store success:successHandler error:errorHandler];
}


-(void) dataCallSuccess: (id) data
{
    if((NSNull *)data != [NSNull null] && data != nil) //login success
    {
        REMUserModel *user = [[REMUserModel alloc] initWithDictionary:data];
        [[REMApplicationContext instance] setCurrentUser:user];
        
        NSArray *customers = (NSArray *)([REMApplicationContext instance].currentUser.customers);
        
        int i=0;
        for (; i<customers.count; i++)
        {
            REMCustomerModel *customer = customers[i];
            if([customer.code isEqualToString:@"NancyCostCustomer2"])
            {
                [[REMApplicationContext instance] setCurrentCustomer:customer];
                break;
            }
        }
        
        [[REMApplicationContext instance].currentUser save];
        [[REMApplicationContext instance].currentCustomer save];
        
        [self.loginCarouselController.splashScreenController gotoMainView];
    }
    else //login fail
    {
        //[self.errorImage setHidden:NO];
        [REMAlertHelper alert:@"错误的用户名或密码"];
    }
}

-(void) dataCallFail: (NSError *) error result:(NSObject *)response
{
    [REMAlertHelper alert:error.description];
}
@end
