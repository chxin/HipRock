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
#import "REMCommonDefinition.h"

@interface REMBuildingShareViewController ()

@end

@implementation REMBuildingShareViewController

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
    
    [self.weiboButton addTarget:self action:@selector(weiboButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(mailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
    }];
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
            [REMAlertHelper alert:REMLocalizedString(@"Mail_AccountNotConfigured")];
            return ;
        }
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        
        [picker setSubject:REMLocalizedString(@"Mail_Title")];
        
        // Set up the recipients.
        //        NSArray *toRecipients = [NSArray arrayWithObjects:@"first@example.com", nil];
        //        NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
        //        NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com", nil];
        
        //        [picker setToRecipients:toRecipients];
        //        [picker setCcRecipients:ccRecipients];
        //        [picker setBccRecipients:bccRecipients];
        
        // Attach an image to the email.
        NSData *myData = UIImagePNGRepresentation(image);
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];
        
        // Fill out the email body text.
        NSString *emailBody = text;
        [picker setMessageBody:emailBody isHTML:NO];
        
        // Present the mail composition interface.
        [self.buildingController presentViewController:picker animated:YES completion:nil];
    

        
    }];
}




- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self.buildingController dismissViewControllerAnimated:YES completion:nil];
}

@end
