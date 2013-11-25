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

@interface REMLoginTrialCardController ()

@end

@implementation REMLoginTrialCardController

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDMLogin_CardContentWidth,kDMLogin_CardContentHeight)];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addTrialButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addTrialButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 120, 48);
    button.center = CGPointMake(kDMLogin_CardContentWidth/2, kDMLogin_CardContentHeight/2);
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:REMLocalizedString(@"Login_TrialButtonText") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(trialButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

-(void)trialButtonPressed:(UIButton *)sender
{
    [REMAlertHelper alert:@"u have pressed me"];
}

@end
