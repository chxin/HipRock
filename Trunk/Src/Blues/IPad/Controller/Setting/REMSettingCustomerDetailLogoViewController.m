/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingCustomerDetailLogoViewController.m
 * Created      : tantan on 9/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMSettingCustomerDetailLogoViewController.h"
#import "REMApplicationContext.h"
@interface REMSettingCustomerDetailLogoViewController ()

@end

@implementation REMSettingCustomerDetailLogoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor grayColor]];
    //self.logoImageVIew.image = REMAppCurrentLogo;
    UIImageView *image=[[UIImageView alloc] initWithImage:REMAppCurrentLogo];
    [image setFrame:CGRectMake((self.navigationController.view.frame.size.width-image.frame.size.width)/2,100, image.frame.size.width, image.frame.size.height)];
    
    [self.view addSubview:image];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
