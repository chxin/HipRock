/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingContactInformationViewController.m
 * Date Created : 张 锋 on 7/8/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingContactInformationViewController.h"
#import "REMCommonHeaders.h"

@interface REMSettingContactInformationViewController ()

@end

@implementation REMSettingContactInformationViewController

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
    self.title = REMIPadLocalizedString(@"Setting_ContactItemContactInformation");
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Done") style:UIBarButtonItemStylePlain target:self action:@selector(okButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIFont *font = [REMFont defaultFontOfSize:14.0];
    UIColor *black = [UIColor blackColor];
    
    //title
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = font;
    titleLable.textColor = black;
    titleLable.text = REMIPadLocalizedString(@"Setting_InformationTitle");
    titleLable.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:titleLable];
    
    CGFloat top = REMISIOS7 ? 97.0 : 97.0-44.0;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:27.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:top] ];
    
    //phones
    UILabel *phoneTitleLabel = [[UILabel alloc] init];
    phoneTitleLabel.text = REMIPadLocalizedString(@"Setting_InformationPhoneTitle");
    phoneTitleLabel.font = font;
    phoneTitleLabel.textColor = black;
    
    UILabel *phone1Label = [[UILabel alloc] init];
    phone1Label.text = REMIPadLocalizedString(@"Setting_ContactPhone1");
    phone1Label.font = font;
    phone1Label.textColor = black;
    
    UILabel *phone2Label = [[UILabel alloc] init];
    phone2Label.text = REMIPadLocalizedString(@"Setting_ContactPhone2");
    phone2Label.font = font;
    phone2Label.textColor = black;
    
    UILabel *phone3Label = [[UILabel alloc] init];
    phone3Label.text = REMIPadLocalizedString(@"Setting_ContactPhone3");
    phone3Label.font = font;
    phone3Label.textColor = black;
    
    [self.view addSubview:phoneTitleLabel];
    [self.view addSubview:phone1Label];
    [self.view addSubview:phone2Label];
    [self.view addSubview:phone3Label];
    
    //mails
    UILabel *mailTitleLabel = [[UILabel alloc] init];
    mailTitleLabel.text = REMIPadLocalizedString(@"Setting_InformationMailTitle");
    mailTitleLabel.font = font;
    mailTitleLabel.textColor = black;
    
    UILabel *mailLabel = [[UILabel alloc] init];
    mailLabel.text = REMIPadLocalizedString(@"Setting_InformationMailAddress");
    mailLabel.font = font;
    mailLabel.textColor = black;
    
    [self.view addSubview:mailTitleLabel];
    [self.view addSubview:mailLabel];
    
    //constraint
    for(UIView *lable in @[phoneTitleLabel,phone1Label,phone2Label,phone3Label, mailTitleLabel, mailLabel]){
        lable.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lable attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:27.0]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phoneTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLable attribute:NSLayoutAttributeBottom multiplier:1.0 constant:35.0] ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phone1Label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:phoneTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:11.0] ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phone2Label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:phone1Label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:11.0] ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:phone3Label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:phone2Label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:11.0] ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mailTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:phone3Label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:36.0] ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mailLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mailTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:11.0] ];
}

- (IBAction)okButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
