/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrialCardController.m
 * Date Created : 张 锋 on 11/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/

#import "REMLoginTrialCardController.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"
#import "REMUserValidationModel.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"
#import "REMLocalizeKeys.h"
#import "REMIndicatorButton.h"


@interface REMLoginTrialCardController ()

@property (nonatomic,weak) REMIndicatorButton *trialButton;

@end

@implementation REMLoginTrialCardController

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDMLogin_CardContentWidth,kDMLogin_CardContentHeight)];
    //self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addTitle];
    
    [self addTrialButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTitle
{
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 57)];
    titleBackground.backgroundColor = [REMColor colorByHexString:@"#e8e8e8"];
    
    UIView *titleSeperateLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleBackground.frame.size.height, 500, 2)];
    titleBackground.backgroundColor = [REMColor colorByHexString:@"#e0e0e0"];
    
    NSString *titleText = REMLocalizedString(@"Login_TrialCardTitle");
    UIFont *titleFont = [UIFont systemFontOfSize:24];
    CGSize titleLabelSize = [titleText sizeWithFont:titleFont];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((500-titleLabelSize.width)/2, (57-titleLabelSize.height)/2, titleLabelSize.width, titleLabelSize.height)];
    titleLabel.text = titleText;
    titleLabel.font = titleFont;
    titleLabel.textColor = [REMColor colorByHexString:@"#5b5b5b"];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    NSString *welcomeText = REMLocalizedString(@"Login_TrialWelcomeText");
    UIFont *welcomeFont = [UIFont systemFontOfSize:24];
    CGSize welcomeLabelSize = [welcomeText sizeWithFont:titleFont];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake((500-welcomeLabelSize.width)/2, 150, welcomeLabelSize.width, welcomeLabelSize.height)];
    welcomeLabel.text = welcomeText;
    welcomeLabel.font = welcomeFont;
    welcomeLabel.textColor = [REMColor colorByHexString:@"#5b5b5b"];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:titleBackground];
    [self.view addSubview:titleSeperateLine];
    [self.view addSubview:titleLabel];
    [self.view addSubview:welcomeLabel];
}

-(void)addTrialButton
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, 6.0, 0, 6.0);
    UIImage *normalImage = [REMIMG_Login_Normal resizableImageWithCapInsets:imageInsets];
    UIImage *pressedImage = [REMIMG_Login_Pressed resizableImageWithCapInsets:imageInsets];
    UIImage *disabledImage = [REMIMG_Login_Disable resizableImageWithCapInsets:imageInsets];
    
    REMIndicatorButton *button = [[REMIndicatorButton alloc] initWithFrame:CGRectMake(0, 0, 280, 48)];
    button.center = CGPointMake(kDMLogin_CardContentWidth/2, 280);
    [button setTitle:REMLocalizedString(@"Login_TrialButtonText") forState:UIControlStateNormal];
    [button setTitle:REMLocalizedString(@"Login_CreatingDemoUserText") forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(trialButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    
    [self.view addSubview:button];
    self.trialButton = button;
}

-(void)trialButtonPressed:(UIButton *)sender
{
    [self.trialButton setEnabled:NO];
    [self.trialButton startIndicator];
    
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(createDemoUser) userInfo:nil repeats:NO];
}

-(void)createDemoUser
{
    //use sp1 for all demo user
    REMUserModel *tempUser = [[REMUserModel alloc] init];
    tempUser.userId = 0;
    tempUser.name = @"";
    tempUser.spId = 1;
    [REMAppContext setCurrentUser:tempUser];
    
    //so demo user will be created in sp1
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSDemoUserValidate parameter:nil];
    [REMDataAccessor access:store success:^(id data) {
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
            
            [self.loginCarouselController performSegueWithIdentifier:kSegue_LoginToCustomer sender:self];
        }
        
        [self.trialButton setEnabled:YES];
        [self.trialButton stopIndicator];
        
    } error:^(NSError *error, id response) {
        //[REMAlertHelper alert:@""];
        [self.trialButton setEnabled:YES];
        [self.trialButton stopIndicator];
    }];
}

@end
