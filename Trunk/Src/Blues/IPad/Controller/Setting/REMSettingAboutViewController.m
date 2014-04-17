/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMSettingAboutViewController.m
 * Date Created : tantan on 12/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingAboutViewController.h"
#import "REMTimeHelper.h"
#import "REMColor.h"
#import "REMCommonHeaders.h"
@interface REMSettingAboutViewController ()

@end

@implementation REMSettingAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *image=[UIImage imageNamed:@"Logo_About"];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageView];
    UILabel *productNamelabel=[[UILabel alloc]init];
    productNamelabel.translatesAutoresizingMaskIntoConstraints=NO;
    productNamelabel.backgroundColor=[UIColor clearColor];
    productNamelabel.text=REMIPadLocalizedString(@"Setting_AboutProductName");//施耐德电气“云能效”管理平台
    productNamelabel.font=[UIFont systemFontOfSize:22];
    productNamelabel.textColor=[REMColor colorByHexString:@"#2f2f2f"];
    [self.view addSubview:productNamelabel];
    UILabel *versionLabel=[[UILabel alloc]init];
    versionLabel.translatesAutoresizingMaskIntoConstraints=NO;
    versionLabel.font=[UIFont systemFontOfSize:14];
    versionLabel.textColor=[REMColor colorByHexString:@"#6e6e6e"];
    versionLabel.backgroundColor=[UIColor clearColor];
    NSString *version=REMIPadLocalizedString(@"Setting_AboutVersion");//iPad版V%@
    NSString *versionNumber=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *dataSource = REMAppConfig.currentDataSourceKey;
    
    versionLabel.text=[NSString stringWithFormat:version,versionNumber,buildNumber,[[dataSource substringToIndex:1] lowercaseString]];
    [self.view addSubview:versionLabel];
    UILabel *copyrightChineseLabel=[[UILabel alloc]init];
    copyrightChineseLabel.translatesAutoresizingMaskIntoConstraints=NO;
    copyrightChineseLabel.textColor=[REMColor colorByHexString:@"#959595"];
    copyrightChineseLabel.font=[UIFont systemFontOfSize:12];
    copyrightChineseLabel.backgroundColor=[UIColor clearColor];
    copyrightChineseLabel.text=REMIPadLocalizedString(@"Setting_AboutCopyrightChinese");//施耐德电气 版权所有
    [self.view addSubview:copyrightChineseLabel];
    
    
    UILabel *copyrightEnglishLabel=[[UILabel alloc]init];
    copyrightEnglishLabel.translatesAutoresizingMaskIntoConstraints=NO;
    copyrightEnglishLabel.backgroundColor=[UIColor clearColor];
    copyrightEnglishLabel.textColor=[REMColor colorByHexString:@"#959595"];
    copyrightEnglishLabel.font=[UIFont systemFontOfSize:12];
    NSUInteger year = [REMTimeHelper getYear:[NSDate date] withCalendar:[NSCalendar currentCalendar]];
    
    copyrightEnglishLabel.text = [NSString stringWithFormat:REMIPadLocalizedString(@"Setting_AboutCopyrightEnglish%d"),year];
    [self.view addSubview:copyrightEnglishLabel];
    
    for (UIView *view in self.view.subviews) {
        NSLayoutConstraint *constraintCenter=[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self.view addConstraint:constraintCenter];
    }
    
    NSMutableArray *constraints = [NSMutableArray array];
    NSDictionary *constraintsDic = NSDictionaryOfVariableBindings(imageView,productNamelabel,versionLabel,copyrightChineseLabel,copyrightEnglishLabel);
    NSDictionary *constraintsMetrics = @{@"imageTop":@(110),@"productTop":@(6),@"versionTop":@(13),@"chineseCopyrightTop":@(113),@"englishCopyrightTop":@(9)};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-imageTop-[imageView]-productTop-[productNamelabel]-versionTop-[versionLabel]->=chineseCopyrightTop-[copyrightChineseLabel]-englishCopyrightTop-[copyrightEnglishLabel]-20-|" options:0 metrics:constraintsMetrics views:constraintsDic]];
    [self.view addConstraints:constraints];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
