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
#import "REMColoredButton.h"

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
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"loginpage-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
    
    UIImageView *myView = (UIImageView *)self.view;
    [myView setFrame:CGRectMake(0, 0, 500, 350)];
    [myView setContentMode:UIViewContentModeScaleAspectFit];
    [myView setImage:backgroundImage];
    
    
    self.loginButton.buttonColor = REMColoredButtonBlue;
    self.loginButton.loadingText = @"正在登录...";
    
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
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    [loginInfo setValue:self.userNameTextField.text forKey:@"userName"];
    [loginInfo setValue:self.passwordTextField.text forKey:@"password"];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:loginInfo];
    store.maskContainer = nil;
    store.isAccessLocal = NO;
    store.isStoreLocal = YES;
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
            [[REMApplicationContext instance] setCurrentUser:user];
            
            NSArray *customers = (NSArray *)([REMApplicationContext instance].currentUser.customers);
            
            if(customers.count<=0){
                [self.userNameErrorLabel setHidden:NO];
                [self.userNameErrorLabel setText : @"登录失败，该用户未绑定客户" ];
            }
            if(customers.count == 1){
                [[REMApplicationContext instance] setCurrentCustomer:customers[0]];
            }
            else{
                [[REMApplicationContext instance] setCurrentCustomer:[self filterRequiredCustomer:customers]];
            }
            
            [[REMApplicationContext instance].currentUser save];
            [[REMApplicationContext instance].currentCustomer save];
            
            [self.loginButton setTitleForAllStatus:@"正在加载数据.."];
            [self.loginCarouselController.splashScreenController showBuildingView:^{
                [self.loginButton stopIndicator];
            }];
        }
        else
        {
            if(validationResult.status == REMUserValidationWrongName)
            {
                [self.userNameErrorLabel setHidden:NO];
                [self.userNameErrorLabel setText : @"该用户名不存在" ];
            }
            else if (validationResult.status == REMUserValidationWrongPassword)
            {
                [self.passwordErrorLabel setHidden:NO];
                [self.passwordErrorLabel setText : @"登录密码错误" ];
            }
            else
            {
            }
        }
    }
}

-(void) dataCallFail: (NSError *) error result:(NSObject *)response
{
    [self.loginButton stopIndicator];
    
    [REMAlertHelper alert:error.description];
}

-(REMCustomerModel *)filterRequiredCustomer:(NSArray *)customers
{
    for (int i=0; i<customers.count; i++)
    {
        if([((REMCustomerModel *)customers[i]).code isEqualToString:@"SOHOChina"])
        {
            return customers[i];
            break;
        }
    }
    
    return nil;
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
@end
