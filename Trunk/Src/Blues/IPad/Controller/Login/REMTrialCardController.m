/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrialCardController.m
 * Date Created : 张 锋 on 11/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/

#import "REMTrialCardController.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"
#import "REMUserValidationModel.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"
#import "REMLocalizeKeys.h"
#import "REMIndicatorButton.h"
#import "REMLoginTitledCard.h"
#import "REMLoginCardController.h"
#import "REMLoginPersistenceProcessor.h"


@interface REMTrialCardController ()

//@property (nonatomic,weak) UITextField *emailTextField;
//@property (nonatomic,weak) UILabel *errorLabel;


@end

@implementation REMTrialCardController

- (void)loadView
{
    [super loadView];
    
    UIView *contentView = [self renderContent];
    self.view = [[REMLoginTitledCard alloc] initWithTitle:REMIPadLocalizedString(@"Login_TrialCardTitle") andContentView:contentView];
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

-(UIView *)renderContent
{
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDMLogin_CardContentWidth, kDMLogin_CardContentHeight-kDMLogin_CardTitleViewHeight)];
    
    NSString *welcomeText = REMIPadLocalizedString(@"Login_TrialWelcomeText");
    UIFont *welcomeFont = [REMFont defaultFontOfSize:kDMLogin_TrialCardWelcomeTextFontSize];
    CGSize welcomeLabelSize = [welcomeText sizeWithFont:welcomeFont];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDMLogin_TrialCardWelcomeTextTopOffset, kDMLogin_CardContentWidth, welcomeLabelSize.height)];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = welcomeText;
    welcomeLabel.font = welcomeFont;
    welcomeLabel.textColor = [REMColor colorByHexString:kDMLogin_TrialCardWelcomeTextFontColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    
    
//    UITextField *textfield = [[UITextField alloc] init];
//    textfield.frame = CGRectMake(kDMLogin_LoginButtonLeftOffset,kDMLogin_LoginButtonTopOffset-90,330,45);
//    textfield.placeholder = @"邮箱";
//    textfield.layer.borderWidth = 1.0;
//    textfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    textfield.layer.cornerRadius = 3;
//    textfield.delegate = self;
//    textfield.returnKeyType = UIReturnKeyGo;
    
//    CGRect labelFrame = CGRectMake(kDMLogin_LoginButtonLeftOffset, kDMLogin_LoginButtonTopOffset-38, 330, 12);
//    UILabel *errorLabel = [[UILabel alloc] initWithFrame:labelFrame];
//    errorLabel.textColor = [UIColor redColor];
//    errorLabel.font = [UIFont systemFontOfSize:12];
//    [errorLabel setHidden:YES];
    
    CGRect buttonFrame = CGRectMake(kDMLogin_LoginButtonLeftOffset, kDMLogin_LoginButtonTopOffset, kDMLogin_LoginButtonWidth, kDMLogin_LoginButtonHeight);
    NSDictionary *statusTexts = @{
                                  @(REMLoginButtonNormalStatus):REMIPadLocalizedString(@"Login_TrialButtonText"),
                                  @(REMLoginButtonWorkingStatus):REMIPadLocalizedString(@"Login_CreatingDemoUserText"),
                                  @(REMLoginButtonDisableStatus):REMIPadLocalizedString(@"Login_TrialButtonText"),
                                };
    REMLoginButton *button = [[REMLoginButton alloc] initWithFrame:buttonFrame andStatusTexts:statusTexts];
    button.titleLabel.textColor = [REMColor colorByHexString:kDMLogin_LoginButtonFontColor];
    button.titleLabel.font = [REMFont defaultFontOfSize:kDMLogin_LoginButtonFontSize];
    [button addTarget:self action:@selector(trialButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [content addSubview:welcomeLabel];
//    [content addSubview:errorLabel];
//    [content addSubview:textfield];
    [content addSubview:button];
    
//    self.emailTextField = textfield;
//    self.errorLabel = errorLabel;
    self.trialButton = button;
    
    return content;
}

-(void)trialButtonPressed:(UIButton *)sender
{
//    [self.errorLabel setHidden:YES];
//    
//    NSString *email = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if(email == nil || [email isEqualToString:@""] || [email rangeOfString:@"."].length <= 0 || [email rangeOfString:@"@"].length <= 0){
//        [self.errorLabel setHidden:NO];
//        self.errorLabel.text = @"请输入正确的邮箱地址";
//        
//        return;
//    }
    
//    [self.view endEditing:YES];
    
    [self.trialButton setLoginButtonStatus:REMLoginButtonWorkingStatus];
    [self.loginCarouselController.loginCardController.loginButton setLoginButtonStatus:REMLoginButtonDisableStatus];
    
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(createDemoUser) userInfo:nil repeats:NO];
}

-(void)createDemoUser
{
    //use sp1 for all demo user
    [self setTempUser];
    
    //so demo user will be created in sp1
    NSDictionary *messageMap = REMDataAccessMessageMake(@"Login_TrialNoNetwork", @"Login_TrialNetworkFailed", @"Login_TrialServerError", @"");
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSDemoUserValidate parameter:nil accessCache:NO andMessageMap:messageMap];
    store.persistenceProcessor = [[REMLoginPersistenceProcessor alloc] init];
    [store access:^(REMUserValidationModel *validationResult) {
        
        //REMUserValidationModel *validationResult = [[REMUserValidationModel alloc] initWithDictionary:data];
        
        if(validationResult.status == REMUserValidationSuccess) {
            REMManagedUserModel *user = validationResult.managedUser;
            REMAppContext.currentUser = user;
            
            NSArray *customers = REMAppContext.currentUser.customers.array;
            
            if(customers.count<=0){
                [REMAlertHelper alert:REMIPadLocalizedString(@"Login_TrialNoCustomer")];
                [self.loginCarouselController setLoginButtonStatusNormal];
                
                return;
            }
            
            if(customers.count == 1){
                REMAppContext.currentCustomer = customers[0];
                [self.loginCarouselController loginSuccess];
            }
            else{
                [self.loginCarouselController presentCustomerSelectionView];
            }
        }
        else {
            [self.loginCarouselController setLoginButtonStatusNormal];
        }
    } failure:^(NSError *error, REMDataAccessStatus status, id response) {
        [self.loginCarouselController setLoginButtonStatusNormal];
    }];
}

-(void)setTempUser
{
    REMManagedUserModel *tempUser =  (REMManagedUserModel *)[REMDataStore createManagedObject:[REMManagedUserModel class]];
    tempUser.id = 0;
    tempUser.name = @"";
    tempUser.spId = @(1);
    REMAppContext.currentUser = tempUser;
}


#pragma mark - uitextfield delegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    BOOL retValue = NO;
//    // see if we're on the username or password fields
//    if([textField isEqual:self.emailTextField])
//    {
//        if(self.trialButton.isEnabled == YES){ //only call login when login button is enabled
//            [self trialButtonPressed:nil];
//            retValue = YES;
//        }
//    }
//    else
//    {
//    }
//    return retValue;
//}

@end
