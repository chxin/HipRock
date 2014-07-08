/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMContactWeSiteViewController.m
 * Date Created : 张 锋 on 7/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingContactWeSiteViewController.h"
#import "REMCommonHeaders.h"

@interface REMSettingContactWeSiteViewController ()

@end

@implementation REMSettingContactWeSiteViewController

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
    self.title = REMIPadLocalizedString(@"Setting_ContactItemWeSite");
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Done") style:UIBarButtonItemStylePlain target:self action:@selector(okButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //resource
    UIFont *font = [REMFont defaultFontOfSize:14.0];
    UIColor *color = [UIColor blackColor];
    
    //title
    UILabel *title = [[UILabel alloc] init];
    title.text = REMIPadLocalizedString(@"Setting_WeSiteTitle");
    title.font = font;
    title.textColor = color;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:title];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:82]];
    
    //icon
    UIImageView *imageView = [[UIImageView alloc] initWithImage:REMIMG_QDCode_EMOPWeChat];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:imageView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeBottom multiplier:1.0 constant:40]];
    
    //description
    UILabel *description = [[UILabel alloc] init];
    description.text = REMIPadLocalizedString(@"Setting_WeSiteDescription");
    description.font = [REMFont defaultFontOfSize:14.0];
    description.textColor = [UIColor blackColor];
    description.numberOfLines = 2;
    description.lineBreakMode = NSLineBreakByWordWrapping;
    description.translatesAutoresizingMaskIntoConstraints = NO;
    description.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:description];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:description attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:description attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:description attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:34]];
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
