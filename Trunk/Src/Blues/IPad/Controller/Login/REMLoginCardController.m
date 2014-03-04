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

#import "REMLoginPersistenceProcessor.h"

@interface REMLoginCardController ()

@property (weak, nonatomic) UITextField *userNameTextField;
@property (weak, nonatomic) UITextField *passwordTextField;
@property (weak, nonatomic) UILabel *userNameErrorLabel;
@property (weak, nonatomic) UILabel *passwordErrorLabel;

@end

@implementation REMLoginCardController

-(void)loadView
{
    UIView *contentView = [self renderContent];
    self.view = [[REMLoginTitledCard alloc] initWithTitle:REMIPadLocalizedString(@"Login_LoginCardTitle") andContentView:contentView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
#ifdef DEBUG
    NSString *debugUser = REMAppConfig.currentDataSource[@"debug-user"];
    if(!REMIsNilOrNull(debugUser) && ![debugUser isEqualToString:@""] && [debugUser rangeOfString:@"|"].length>0){
        NSArray *debugUserInfo = [debugUser componentsSeparatedByString:@"|"];
        self.userNameTextField.text = debugUserInfo[0];
        self.passwordTextField.text = debugUserInfo[1];
        [self.loginButton setEnabled:YES];
    }
#endif
    
    return content;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSDictionary *)validateInput
{
    NSString *username = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.passwordTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(REMStringNilOrEmpty(username) || REMStringNilOrEmpty(password)) {
        [REMAlertHelper alert:REMIPadLocalizedString(@"Login_InputNotComplete")];
        return nil;
    }
    
    NSTextCheckingResult *usernameMatch = REMREGEXMatch_UserName(username);
    if(username.length < 1 || username.length > 30 || usernameMatch == nil){
        [self setErrorLabelTextWithStatus:REMUserValidationWrongName];
        return nil;
    }
    
    NSTextCheckingResult *passwordMatch1 = REMREGEXMatch_Password(password, 1), *passwordMatch2 = REMREGEXMatch_Password(password, 2), *passwordMatch3 = REMREGEXMatch_Password(password, 3), *passwordMatch4 = REMREGEXMatch_Password(password, 4);
    
    if (password.length < 6 || password.length > 20 || [password rangeOfString:@" "].length > 0 || passwordMatch1==nil || passwordMatch2==nil || passwordMatch3==nil || passwordMatch4!=nil) {
        [self setErrorLabelTextWithStatus:REMUserValidationWrongPassword];
        return nil;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setValue:username forKey:@"userName"];
    [parameter setValue:password forKey:@"password"];
    
    return parameter;
}


- (void)loginButtonPressed:(id)sender
{
    [self.userNameErrorLabel setHidden:YES];
    [self.passwordErrorLabel setHidden:YES];
    
    NSDictionary *parameter = [self validateInput];
    if(parameter == nil){
        return;
    }
    
    [self.view endEditing:YES];
    
    //mask login button
    [self.loginButton setLoginButtonStatus:REMLoginButtonWorkingStatus];
    [self.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonDisableStatus];
    
    NSDictionary *messageMap = REMDataAccessMessageMake(@"Login_NoNetwork",@"Login_NetworkFailed",@"Login_ServerError",@"");
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserValidate parameter:parameter accessCache:NO andMessageMap:messageMap];
    //store.persistenceProcessor = [[REMLoginPersistenceProcessor alloc]init];
    [store access:^(id data) {
        if(REMIsNilOrNull(data)){ //TODO: empty response?
            return ;
        }
        
        REMUserValidationModel *validationResult = [[REMUserValidationModel alloc] initWithDictionary:data];
        
        if(validationResult.status == REMUserValidationSuccess) {
            REMUserModel *user = validationResult.user;
            [REMAppContext setCurrentUser:user];
            
            NSArray *customers = (NSArray *)(REMAppCurrentUser.customers);
            
            if(customers.count<=0){
                [REMAlertHelper alert:REMIPadLocalizedString(@"Login_NoCustomer")];
                [self.loginCarouselController setLoginButtonStatusNormal];
                
                return;
            }
            
            if(customers.count == 1){
                [REMAppContext setCurrentCustomer:customers[0]];
                [self.loginCarouselController loginSuccess];
            }
            else{
                [self.loginCarouselController presentCustomerSelectionView];
            }
        }
        else {
            [self setErrorLabelTextWithStatus:validationResult.status];
            [self.loginCarouselController setLoginButtonStatusNormal];
        }
    } error:^(NSError *error, REMDataAccessErrorStatus status, id response) {
        [self.loginCarouselController setLoginButtonStatusNormal];
    }];
    
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

-(void)setErrorLabelTextWithStatus:(REMUserValidationStatus)status
{
    switch (status) {
        case REMUserValidationWrongName:
            [self.userNameErrorLabel setHidden:NO];
            [self.userNameErrorLabel setText : REMIPadLocalizedString(kLNLogin_UserNotExist)];
            break;
        case REMUserValidationWrongPassword:
            [self.passwordErrorLabel setHidden:NO];
            [self.passwordErrorLabel setText : REMIPadLocalizedString(kLNLogin_WrongPassword) ];
            break;
        case REMUserValidationInvalidSp:
            [self.userNameErrorLabel setHidden:NO];
            [self.userNameErrorLabel setText :  REMIPadLocalizedString(kLNLogin_AccountLocked)];
            break;
            
        default:
            break;
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
    NSString *promptLabelText = REMIPadLocalizedString(@"Login_LoginPrompt");
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
    userNameTextBox.placeholder = REMIPadLocalizedString(@"Login_LoginUsernamePlaceHolder");
    userNameTextBox.delegate = self;
    userNameTextBox.returnKeyType = UIReturnKeyNext;
    userNameTextBox.font = [UIFont systemFontOfSize:kDMLogin_TextBoxFontSize];
    userNameTextBox.textColor = [REMColor colorByHexString:kDMLogin_TextBoxFontColor];
    userNameTextBox.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameTextBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [userNameTextBox addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
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
    passwordTextBox.placeholder = REMIPadLocalizedString(@"Login_LoginPasswordPlaceHolder");
    passwordTextBox.delegate = self;
    passwordTextBox.secureTextEntry = YES;
    passwordTextBox.returnKeyType = UIReturnKeyGo;
    passwordTextBox.font = [UIFont systemFontOfSize:kDMLogin_TextBoxFontSize];
    passwordTextBox.textColor = [REMColor colorByHexString:kDMLogin_TextBoxFontColor];
    [passwordTextBox addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
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
                                 @(REMLoginButtonNormalStatus):REMIPadLocalizedString(@"Login_LoginButtonNormalText"),
                                 @(REMLoginButtonWorkingStatus):REMIPadLocalizedString(@"Login_LoginButtonWorkingText"),
                                 @(REMLoginButtonDisableStatus):REMIPadLocalizedString(@"Login_LoginButtonNormalText"),
                                 };
    
    //login button
    REMLoginButton *button = [[REMLoginButton alloc] initWithFrame:frame andStatusTexts:statusText];
    [button addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textColor = [REMColor colorByHexString:kDMLogin_LoginButtonFontColor];
    button.titleLabel.font = [UIFont systemFontOfSize:kDMLogin_LoginButtonFontSize];
    button.enabled = NO;
    
    return button;
}

@end
