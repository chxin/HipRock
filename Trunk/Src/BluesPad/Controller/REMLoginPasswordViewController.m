//
//  REMLoginPasswordViewController.m
//  Blues
//
//  Created by zhangfeng on 7/2/13.
//
//

#import "REMLoginPasswordViewController.h"
#import "REMLoginViewController.h"
#import "REMDataAccessor.h"
#import "REMServiceUrl.h"
#import "REMAppDelegate.h"
#import "REMDataStore.h"
#import "REMCommonHeaders.h"

@interface REMLoginPasswordViewController ()

@end

@implementation REMLoginPasswordViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.loginViewController = (REMLoginViewController *)self.parentViewController.parentViewController;
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)viewTouchDown:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)forgotPasswordButtonTouchDown:(id)sender {
    [self.view endEditing:YES];
    [self.loginViewController performSegueWithIdentifier:@"loginSegue" sender:self.loginViewController ];
    //[self.loginViewController gotoMainView];
}

- (IBAction)loginButtonTouchDown:(id)sender
{
    if([self.userNameTextBox.text isEqualToString:@""] || [self.passwordTextBox.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You must enter UserName and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    [self.errorImage setHidden:YES];
    
    [self.view endEditing:YES];
    
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    [loginInfo setValue:self.userNameTextBox.text forKey:@"userName"];
    [loginInfo setValue:self.passwordTextBox.text forKey:@"password"];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:loginInfo];
    store.maskContainer = self.loginViewController.view;
    store.isAccessLocal = YES;
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
        //[[REMAppDelegate app] setCurrentUser:(NSDictionary *)data];
        [[REMApplicationContext instance] setCurrentUser:(NSDictionary *)data];
        
        
        [self performSegueWithIdentifier:@"customerSelectSugue" sender:self];
    }
    else //login fail
    {
        [self.errorImage setHidden:NO];
    }
}

-(void) dataCallFail: (NSError *) error result:(NSObject *)response
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
