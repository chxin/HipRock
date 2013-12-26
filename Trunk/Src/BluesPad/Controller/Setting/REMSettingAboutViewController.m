/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingAboutViewController.m
 * Date Created : tantan on 12/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingAboutViewController.h"

@interface REMSettingAboutViewController ()

@end

@implementation REMSettingAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *imageView=[[UIImageView alloc]initWithImage:REMIMG_EMOP_APP_7];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    UILabel *productNamelabel=[[UILabel alloc]init];
    productNamelabel.backgroundColor=[UIColor clearColor];
    productNamelabel.text=@"";
    [self.view addSubview:productNamelabel];
    UILabel *versionLabel=[[UILabel alloc]init];
    versionLabel.backgroundColor=[UIColor clearColor];
    versionLabel.text=@"";
    [self.view addSubview:versionLabel];
    UILabel *copyrightLabel=[[UILabel alloc]init];
    copyrightLabel.backgroundColor=[UIColor clearColor];
    copyrightLabel.text=@"";
    [self.view addSubview:copyrightLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
