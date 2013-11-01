//
//  REMLoginPageController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
#import "REMLoginCustomerViewController.h"
#import "REMLocalizeKeys.h"
#import "REMStoryboardDefinitions.h"

@interface REMLoginPageController ()

@end

@implementation REMLoginPageController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.loginButton.loadingText = @"正在登录...";
    
    [self stylize];
    
    [self.userNameTextField setDelegate:self];
    [self.passwordTextField setDelegate:self];
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
    
    //network
    if([REMNetworkHelper checkIsNoConnect] == YES){
        [REMAlertHelper alert:REMLocalizedString(kLNLogin_NoNetwork)];
        return;
    }
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    [loginInfo setValue:self.userNameTextField.text forKey:@"userName"];
    [loginInfo setValue:self.passwordTextField.text forKey:@"password"];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:loginInfo];
    store.maskContainer = nil;
    store.groupName = nil;
    
    //mask login button
    [self.loginButton startIndicator];
    
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

- (IBAction)textFieldChanged:(id)sender
{
    NSString *userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(self.loginButton.indicatorStatus == NO)
    {
        if([userName isEqualToString:@""] || [password isEqualToString:@""])
        {
            [self.loginButton setEnabled:NO];
        }
        else
        {
            [self.loginButton setEnabled:YES];
        }
    }
}

-(void) dataCallSuccess: (id) data
{
    if((NSNull *)data != [NSNull null] && data != nil) //login success
    {
        REMUserValidationModel *validationResult = [[REMUserValidationModel alloc] initWithDictionary:data];
        
        if(validationResult.status == REMUserValidationSuccess)
        {
            REMUserModel *user = validationResult.user;
            [REMAppContext setCurrentUser:user];
            
            NSArray *customers = (NSArray *)(REMAppCurrentUser.customers);
            
            if(customers.count<=0){
                [REMAlertHelper alert:REMLocalizedString(kLNLogin_NotAuthorized)];
                
                return;
            }
            
            if(customers.count == 1){
                [REMAppContext setCurrentCustomer:customers[0]];
                [self.loginCarouselController.splashScreenController showMapView:nil];
                
                return;
            }
            
            [self performSegueWithIdentifier:kSegue_LoginToCustomer sender:self];
            
        }
        else
        {
            [self.loginButton stopIndicator];
            
            if(validationResult.status == REMUserValidationWrongName)
            {
                [self.userNameErrorLabel setHidden:NO];
                [self.userNameErrorLabel setText : REMLocalizedString(kLNLogin_UserNotExist) ];
                [self.loginButton setEnabled:NO];
            }
            else if (validationResult.status == REMUserValidationWrongPassword)
            {
                [self.passwordErrorLabel setHidden:NO];
                [self.passwordErrorLabel setText : REMLocalizedString(kLNLogin_WrongPassword) ];
                [self.loginButton setEnabled:NO];
            }
            else if(validationResult.status == REMUserValidationInvalidSp)
            {
                [self.userNameErrorLabel setHidden:NO];
                [self.userNameErrorLabel setText :  REMLocalizedString(kLNLogin_AccountLocked)];
                [self.loginButton setEnabled:NO];
            }
            else
            {
                [self.loginCarouselController showLoginPage];
            }
        }
    }
}

-(void) dataCallFail: (NSError *) error result:(NSObject *)response
{
    [self.loginButton stopIndicator];
    
    [REMAlertHelper alert:REMLocalizedString(kLNCommon_ServerError)];
}

-(void)loginSuccess
{
    [REMAppCurrentUser save];
    [REMAppCurrentCustomer save];

    [self.loginCarouselController.splashScreenController showMapView:^{
        [self.loginButton stopIndicator];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kSegue_LoginToCustomer] == YES)
    {
        UINavigationController *navigationController = segue.destinationViewController;
        REMLoginCustomerViewController *customerController = navigationController.childViewControllers[0];
        customerController.loginPageController = self;
    }
}

#pragma mark - uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL retValue = NO;
    // see if we're on the username or password fields
    if ([textField isEqual:self.userNameTextField])
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if([textField isEqual:self.passwordTextField])
    {
        [self loginButtonPressed:nil];
        retValue = YES;
    }
    else
    {
    }
    return retValue;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self styleTextFieldFocusStatus:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self styleTextFieldNormalStatus:textField];
}

#pragma mark - style
-(void)stylize
{
    [self styleLoginButton];
    [self styleTextFieldNormalStatus:self.userNameTextField];
    [self styleTextFieldNormalStatus:self.passwordTextField];
}

-(void)styleLoginButton
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, 6.0, 0, 6.0);
    UIImage *normalImage = [[UIImage imageNamed:@"Login-Normal.png"] resizableImageWithCapInsets:imageInsets];
    UIImage *pressedImage = [[UIImage imageNamed:@"Login-Pressed.png"] resizableImageWithCapInsets:imageInsets];
    UIImage *disabledImage = [[UIImage imageNamed:@"Login-Disable.png"] resizableImageWithCapInsets:imageInsets];
    
    [self.loginButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:disabledImage forState:UIControlStateDisabled];
}

-(void)styleTextFieldNormalStatus:(UITextField *)textField
{
    [self setTextField:textField backgroundImage:@"LoginTextField.png"];
}
-(void)styleTextFieldFocusStatus:(UITextField *)textField
{
    [self setTextField:textField backgroundImage:@"LoginTextField-Focus.png"];
}
-(void)setTextField:(UITextField *)textField backgroundImage:(NSString *)imageName
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0,8.0, 0, 8.0);
    UIImage *normalImage = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:imageInsets];
    
    [textField setBackground:normalImage];
}




@end
