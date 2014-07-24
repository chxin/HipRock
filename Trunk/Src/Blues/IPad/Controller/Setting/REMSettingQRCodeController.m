/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingQRCodeContoller.m
 * Date Created : 张 锋 on 7/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingQRCodeController.h"
#import "REMCommonHeaders.h"

@interface REMSettingQRCodeController ()

@end

@implementation REMSettingQRCodeController

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
    
    self.title = REMIPadLocalizedString(@"Setting_QRCode");
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Done") style:UIBarButtonItemStylePlain target:self action:@selector(okButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //load main view
    UILabel *title = [[UILabel alloc] init];
    title.text = REMIPadLocalizedString(@"Setting_QRCodeTitle");
    title.font = [REMFont defaultFontOfSize:14.0];
    title.textColor = [UIColor blackColor];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:title];
    
    CGFloat top = REMISIOS7 ? 82 : 82-44;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:top]];
    
    
    //icon
    UIImageView *codeImage = [[UIImageView alloc] initWithImage:REMIMG_QDCode_EMOP];
    codeImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:codeImage];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:codeImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:codeImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeBottom multiplier:1.0 constant:40]];
    
    //description
    UILabel *description1 = [[UILabel alloc] init];
    description1.text = REMIPadLocalizedString(@"Setting_QRCodeDescription");
    description1.font = [REMFont defaultFontOfSize:14.0];
    description1.textColor = [UIColor blackColor];
    description1.numberOfLines = 2;
    description1.lineBreakMode = NSLineBreakByWordWrapping;
    description1.translatesAutoresizingMaskIntoConstraints = NO;
    description1.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:description1];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:description1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:description1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:description1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:codeImage attribute:NSLayoutAttributeBottom multiplier:1.0 constant:34]];
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
