/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginPageController.m
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <QuartzCore/QuartzCore.h>
#import "REMLoginCardController.h"
#import "REMAlertHelper.h"
#import "REMAppDelegate.h"
#import "REMSplashScreenController.h"
#import "REMUserValidationModel.h"
#import "REMCommonHeaders.h"
#import "REMLocalizeKeys.h"
#import "REMStoryboardDefinitions.h"
#import "REMImages.h"
#import "REMLoginTitledCard.h"
#import "REMInsetsTextField.h"
#import "REMTrialCardController.h"
#import "REMLoginButton.h"


#ifdef DEBUG

#define kDefaultUserName @"SchneiderElectricChina"
#define kDefaultPassword @"P@ssw0rdChina"

#elif InternalRelease

#define kDefaultUserName @"SchneiderElectricChina"
#define kDefaultPassword @"P@ssw0rdChina"

#else

#define kDefaultUserName @""
#define kDefaultPassword @""

#endif

@interface REMLoginCardController ()

@property (weak, nonatomic) UITextField *userNameTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UILabel *userNameErrorLabel;
@property (weak, nonatomic) UILabel *passwordErrorLabel;

@end

@implementation REMLoginCardController

-(void)loadView
{
    //[super loadView];
    
    UIView *contentView = [self renderContent];
    self.view = [[REMLoginTitledCard alloc] initWithTitle:REMLocalizedString(@"Login_LoginCardTitle") andContentView:contentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

-(UIView *)renderContent
{
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDMLogin_CardContentWidth, kDMLogin_CardContentHeight-kDMLogin_CardTitleViewHeight)];
    
    UILabel *promptLabel = [self renderPromptLabel];
    UITextField *userNameTextBox = [self renderUserNameField];
    UILabel *userNameErrorLabel = [self renderUserNameErrorLabel];
    UITextField *passwordTextBox = [self renderPasswordField];
    UILabel *passwordErrorLabel = [self renderPasswordErrorLabel];
    REMLoginButton *loginButton = [self renderLoginButton];
    
    [content addSubview:promptLabel];
    [content addSubview:userNameTextBox];
    [content addSubview:userNameErrorLabel];
    [content addSubview:passwordTextBox];
    [content addSubview:passwordErrorLabel];
    [content addSubview:loginButton];
    
    self.userNameTextField = userNameTextBox;
    self.passwordTextField = passwordTextBox;
    self.userNameErrorLabel = userNameErrorLabel;
    self.passwordErrorLabel = passwordErrorLabel;
    self.loginButton = loginButton;
    
    return content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginButtonPressed:(id)sender
{
    [self.userNameErrorLabel setHidden:YES];
    [self.passwordErrorLabel setHidden:YES];
    
    NSString *username = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(username == nil || [username isEqualToString:@""] ||  password == nil || [self.passwordTextField.text isEqualToString:@""])
    {
        [REMAlertHelper alert:REMLocalizedString(@"Login_InputNotComplete")];
        return;
    }
    
    [self.view endEditing:YES];
    
    //network
    if([REMNetworkHelper checkIsNoConnect] == YES){
        [REMAlertHelper alert:REMLocalizedString(kLNLogin_NoNetwork)];
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setValue:username forKey:@"userName"];
    [parameter setValue:password forKey:@"password"];
    
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:parameter];
    store.maskContainer = nil;
    store.groupName = nil;
    
    //mask login button
    [self.loginButton setLoginButtonStatus:REMLoginButtonWorkingStatus];
    [self.loginCarouselController.trialCardController.trialButton setEnabled:NO];
    
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

- (void)textFieldChanged:(id)sender
{
    NSString *username = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(self.loginButton.indicatorStatus == NO)
    {
        if(username!=nil && ![username isEqualToString:@""] && password!=nil && ![password isEqualToString:@""]){
            [self.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        }
        else
        {
            [self.loginButton setLoginButtonStatus:REMLoginButtonDisableStatus];
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
                
                [self.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
                [self.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
                return;
            }
            
            if(customers.count == 1){
                [REMAppContext setCurrentCustomer:customers[0]];
                
                [REMAppCurrentUser save];
                [REMAppCurrentCustomer save];
                
                [self.loginCarouselController.splashScreenController showMapView:nil];
                
                return;
            }
            
            //[self.loginCarouselController performSegueWithIdentifier:kSegue_LoginToCustomer sender:self];
            [self.loginCarouselController presentCustomerSelectionView];
        }
        else
        {
            [self.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
            [self.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
            
            if(validationResult.status == REMUserValidationWrongName)
            {
                [self.userNameErrorLabel setHidden:NO];
                [self.userNameErrorLabel setText : REMLocalizedString(kLNLogin_UserNotExist) ];
            }
            else if (validationResult.status == REMUserValidationWrongPassword)
            {
                [self.passwordErrorLabel setHidden:NO];
                [self.passwordErrorLabel setText : REMLocalizedString(kLNLogin_WrongPassword) ];
            }
            else if(validationResult.status == REMUserValidationInvalidSp)
            {
                [self.userNameErrorLabel setHidden:NO];
                [self.userNameErrorLabel setText :  REMLocalizedString(kLNLogin_AccountLocked)];
            }
            else
            {
                [self.loginCarouselController showLoginCard];
            }
        }
    }
}

-(void) dataCallFail: (NSError *) error result:(NSObject *)response
{
    [self.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
    [self.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
    
    if(error.code != -1001 && error.code != 306) {
        [REMAlertHelper alert:REMLocalizedString(kLNCommon_ServerError)];
    }
}

-(void)loginSuccess
{
    [REMAppCurrentUser save];
    [REMAppCurrentCustomer save];
    
    
    if([REMNetworkHelper checkIsNoConnect]){
        [REMAlertHelper alert:REMLocalizedString(@"Login_NoNetwork")];
        [self.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        [self.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        
        return;
    }
    else{
        [self.loginCarouselController.splashScreenController showMapView:^{
            [self.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
            [self.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        }];
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
        if(self.loginButton.isEnabled == YES){ //only call login when login button is enabled
            [self loginButtonPressed:nil];
            retValue = YES;
        }
    }
    else
    {
    }
    return retValue;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setTextField:textField backgroundImage:REMIMG_LoginTextField_Focus];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setTextField:textField backgroundImage:REMIMG_LoginTextField];
}

-(void)setTextField:(UITextField *)textField backgroundImage:(UIImage *)image
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0,8.0, 0, 8.0);
    UIImage *resizedImage = [image resizableImageWithCapInsets:imageInsets];
    
    [textField setBackground:resizedImage];
}


#pragma mark - render
-(UILabel *)renderPromptLabel
{
    //text label
    NSString *promptLabelText = REMLocalizedString(@"Login_LoginPrompt");
    UIFont *promptLabelFont = [UIFont systemFontOfSize:kDMLogin_LoginCardPromptLabelFontSize];
    CGSize promptLabelSize = [promptLabelText sizeWithFont:promptLabelFont];
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDMLogin_LoginCardPromptLabelLeftOffset, kDMLogin_LoginCardPromptLabelTopOffset, kDMLogin_LoginCardPromptLabelWidth, promptLabelSize.height)];
    promptLabel.text = promptLabelText;
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textColor = [REMColor colorByHexString:kDMLogin_LoginCardPromptLabelFontColor];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    
    return promptLabel;
}

-(UITextField *)renderUserNameField
{
    //username textbox
    UITextField *userNameTextBox = [[REMInsetsTextField alloc] initWithFrame:CGRectMake(kDMLogin_UserNameTextBoxLeftOffset, kDMLogin_UserNameTextBoxTopOffset, kDMLogin_TextBoxWidth, kDMLogin_TextBoxHeight) andInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
    userNameTextBox.placeholder = REMLocalizedString(@"Login_LoginUsernamePlaceHolder");
    userNameTextBox.delegate = self;
    userNameTextBox.returnKeyType = UIReturnKeyNext;
    userNameTextBox.text = kDefaultUserName;
    userNameTextBox.font = [UIFont systemFontOfSize:kDMLogin_TextBoxFontSize];
    userNameTextBox.textColor = [REMColor colorByHexString:kDMLogin_TextBoxFontColor];
    [userNameTextBox addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventValueChanged];
    [self setTextField:userNameTextBox backgroundImage:REMIMG_LoginTextField];
    
    return userNameTextBox;
}

-(UILabel *)renderUserNameErrorLabel
{
    //username error label
    UILabel *userNameErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDMLogin_UserNameErrorLabelLeftOffset, kDMLogin_UserNameErrorLabelTopOffset, kDMLogin_ErrorLabelWidth, kDMLogin_ErrorLabelFontSize)];
    userNameErrorLabel.font = [UIFont systemFontOfSize:kDMLogin_ErrorLabelFontSize];
    userNameErrorLabel.backgroundColor = [UIColor clearColor];
    userNameErrorLabel.textAlignment = NSTextAlignmentLeft;
    userNameErrorLabel.textColor = [REMColor colorByHexString:kDMLogin_ErrorLabelFontColor];
    
    return userNameErrorLabel;
}

-(UITextField *)renderPasswordField
{
    //password textbox
    UITextField *passwordTextBox = [[REMInsetsTextField alloc] initWithFrame:CGRectMake(kDMLogin_PasswordTextBoxLeftOffset, kDMLogin_PasswordTextBoxTopOffset, kDMLogin_TextBoxWidth, kDMLogin_TextBoxHeight) andInsets:UIEdgeInsetsMake(15, 10, 15, 10)];
    passwordTextBox.placeholder = REMLocalizedString(@"Login_LoginPasswordPlaceHolder");
    passwordTextBox.delegate = self;
    passwordTextBox.secureTextEntry = YES;
    passwordTextBox.returnKeyType = UIReturnKeyGo;
    passwordTextBox.text = kDefaultPassword;
    passwordTextBox.font = [UIFont systemFontOfSize:kDMLogin_TextBoxFontSize];
    passwordTextBox.textColor = [REMColor colorByHexString:kDMLogin_TextBoxFontColor];
    [passwordTextBox addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventValueChanged];
    [self setTextField:passwordTextBox backgroundImage:REMIMG_LoginTextField];
    
    return passwordTextBox;
}

-(UILabel *)renderPasswordErrorLabel
{
    //password error label
    UILabel *passwordErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDMLogin_PasswordErrorLabelLeftOffset, kDMLogin_PasswordErrorLabelTopOffset, kDMLogin_ErrorLabelWidth, kDMLogin_ErrorLabelFontSize)];
    passwordErrorLabel.font = [UIFont systemFontOfSize:kDMLogin_ErrorLabelFontSize];
    passwordErrorLabel.backgroundColor = [UIColor clearColor];
    passwordErrorLabel.textAlignment = NSTextAlignmentLeft;
    passwordErrorLabel.textColor = [REMColor colorByHexString:kDMLogin_ErrorLabelFontColor];
    
    return passwordErrorLabel;
}

-(REMLoginButton *)renderLoginButton
{
    CGRect frame = CGRectMake(kDMLogin_LoginButtonLeftOffset, kDMLogin_LoginButtonTopOffset, kDMLogin_LoginButtonWidth, kDMLogin_LoginButtonHeight);
    NSDictionary *statusText = @{
                                 @(REMLoginButtonNormalStatus):REMLocalizedString(@"Login_LoginButtonNormalText"),
                                 @(REMLoginButtonWorkingStatus):REMLocalizedString(@"Login_LoginButtonWorkingText"),
                                 @(REMLoginButtonDisableStatus):REMLocalizedString(@"Login_LoginButtonNormalText"),
                                 };
    
    //login button
    REMLoginButton *button = [[REMLoginButton alloc] initWithFrame:frame andStatusTexts:statusText];
    [button addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textColor = [REMColor colorByHexString:kDMLogin_LoginButtonFontColor];
    button.titleLabel.font = [UIFont systemFontOfSize:kDMLogin_LoginButtonFontSize];
    
    return button;
}

@end
