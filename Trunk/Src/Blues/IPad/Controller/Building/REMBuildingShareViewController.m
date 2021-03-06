/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingShareViewController.m
 * Created      : 张 锋 on 11/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "REMBuildingShareViewController.h"
#import "REMBuildingWeiboView.h"
#import "REMCommonHeaders.h"

@interface REMBuildingShareViewController ()

@end

@implementation REMBuildingShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, 156, 100)];
    
    if (REMISIOS7) {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    else{
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboButton setBackgroundImage:REMIMG_share_weibo forState:UIControlStateNormal];
    weiboButton.adjustsImageWhenHighlighted=YES;
    [weiboButton setTitle:REMIPadLocalizedString(@"Building_ShareWeibo") forState:UIControlStateNormal];
    weiboButton.titleLabel.font=[REMFont defaultFontOfSize:12];
    [weiboButton setTitleEdgeInsets:UIEdgeInsetsMake(48+30, 0, 0, 0)];
    [weiboButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:weiboButton];
    self.weiboButton=weiboButton;

    weiboButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    UIButton *mailButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [mailButton setBackgroundImage:REMIMG_share_email forState:UIControlStateNormal];
    [mailButton setImageEdgeInsets:weiboButton.imageEdgeInsets];
    mailButton.titleLabel.font=weiboButton.titleLabel.font;
    [mailButton setTitleEdgeInsets:weiboButton.titleEdgeInsets];
    [mailButton setTitle:REMIPadLocalizedString(@"Building_ShareEmail") forState:UIControlStateNormal];
    [mailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    mailButton.adjustsImageWhenHighlighted=YES;
    
    [self.view addSubview:mailButton];
    
    mailButton.translatesAutoresizingMaskIntoConstraints=NO;
    self.mailButton=mailButton;
    
    NSMutableArray *constaints=[NSMutableArray array];
    NSDictionary *constaintsDic=NSDictionaryOfVariableBindings(weiboButton,mailButton);
    NSDictionary *constaintsVar=@{@"height":@(48),@"width":@(48),@"margin":@(20)};
    
    [constaints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[weiboButton(width)]-margin-[mailButton(width)]-margin-|" options:0 metrics:constaintsVar views:constaintsDic]];
    [constaints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[weiboButton(height)]" options:0 metrics:constaintsVar views:constaintsDic]];
    [constaints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[mailButton(height)]" options:0 metrics:constaintsVar views:constaintsDic]];
    [self.view addConstraints:constaints];
    
    
    [self.weiboButton addTarget:self action:@selector(weiboButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(mailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)weiboButtonPressed:(UIButton *)button
{
    [self.buildingController.sharePopoverController dismissPopoverAnimated:YES];
    
    REMMaskManager *masker = [[REMMaskManager alloc]initWithContainer:[UIApplication sharedApplication].keyWindow];
    
    [masker showMask];
    
    [self performSelector:@selector(executeWeiboExport:) withObject:masker afterDelay:0.1];
}



- (void)executeWeiboExport:(REMMaskManager *)masker{
    [self.buildingController exportImage:^(UIImage *image, NSString* text){
        [masker hideMask];
        
        REMBuildingWeiboView* weiboView = [[REMBuildingWeiboView alloc]initWithSuperView:self.buildingController.view text:text image:image];
        
        [weiboView show:YES];
        
    } :NO];
}


-(void)mailButtonPressed:(UIButton *)button
{
    [self.buildingController.sharePopoverController dismissPopoverAnimated:YES];
    
    REMMaskManager *masker = [[REMMaskManager alloc]initWithContainer:[UIApplication sharedApplication].keyWindow];
    
    [masker showMask];
    
    [self performSelector:@selector(executeEmailExport:) withObject:masker afterDelay:0.1];
}

- (void)executeEmailExport:(REMMaskManager *)masker{
    [self.buildingController exportImage:^(UIImage *image, NSString* text){
        [masker hideMask];
        
            
        if(![MFMailComposeViewController canSendMail]){
            [REMAlertHelper alert:REMIPadLocalizedString(@"Mail_AccountNotConfigured")];
            return ;
        }
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        
        REMManagedBuildingModel *building = self.buildingController.buildingInfoArray[self.buildingController.currentBuildingIndex];
        //
        [picker setSubject:[NSString stringWithFormat:REMIPadLocalizedString(@"Mail_Title"), building.name]];
        
        // Attach an image to the email.
        NSData *myData = UIImagePNGRepresentation(image);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];
        
        // Fill out the email body text.
        NSString *emailBody = text;
        [picker setMessageBody:emailBody isHTML:YES];
        
        // Present the mail composition interface.
        [self.buildingController presentViewController:picker animated:YES completion:nil];
    } :YES];
}




- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.buildingController dismissViewControllerAnimated:YES completion:nil];
}

@end
