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
#import "REMUserValidationModel.h"
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
    
    //[self.loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginButtonPressed:(id)sender
{
    [self.userNameErrorLabel setHidden:YES];
    [self.passwordErrorLabel setHidden:YES];
    
    if([self.userNameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
    {
        [REMAlertHelper alert:@"请输入完整的用户名和密码"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    [loginInfo setValue:self.userNameTextField.text forKey:@"userName"];
    [loginInfo setValue:self.passwordTextField.text forKey:@"password"];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:loginInfo];
    store.maskContainer = nil;
    store.isAccessLocal = NO;
    store.isStoreLocal = YES;
    store.groupName = nil;
    
    //mask login button
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat halfButtonHeight = self.loginButton.bounds.size.height / 2;
    CGFloat buttonWidth = self.loginButton.bounds.size.width;
    indicator.center = CGPointMake(buttonWidth - halfButtonHeight , halfButtonHeight);
    [self.loginButton addSubview:indicator];
    [indicator startAnimating];
    [self.loginButton setEnabled:NO];
    [self.loginButton setTitle:@"正在登录..." forState:UIControlStateNormal];
    
    void (^successHandler)(id data) = ^(id data)
    {
        [self dataCallSuccess:data];
    };
    
    void (^errorHandler)(NSError *error, id response) = ^(NSError *error, id response)
    {
        [self dataCallFail:error result:response];
        
        //unmask login button
        [indicator stopAnimating];
    };
    
    [REMDataAccessor access:store success:successHandler error:errorHandler];
}

- (IBAction)textFieldChanged:(id)sender
{
    BOOL enabled = [[((UITextField *)sender).text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""];
    //NSLog(@"%@, %@",textField.text, enabled?@"yes":@"no");
    [self.loginButton setEnabled:!enabled];
}

-(void) dataCallSuccess: (id) data
{
    if((NSNull *)data != [NSNull null] && data != nil) //login success
    {
        REMUserValidationModel *validationResult = [[REMUserValidationModel alloc] initWithDictionary:data];
        
        if(validationResult.status == REMUserValidationSuccess)
        {
            REMUserModel *user = validationResult.user;
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
        else if(validationResult.status == REMUserValidationWrongName)
        {
            [self.userNameErrorLabel setHidden:NO];
            [self.userNameErrorLabel setText : @"该用户名不存在" ];
        }
        else if(validationResult.status == REMUserValidationWrongPassword)
        {
            [self.passwordErrorLabel setHidden:NO];
            [self.passwordErrorLabel setText : @"登录密码错误" ];
        }
        else
        {
            //do nothing
        }
    }
}

-(void) dataCallFail: (NSError *) error result:(NSObject *)response
{
    [REMAlertHelper alert:error.description];
}
@end
