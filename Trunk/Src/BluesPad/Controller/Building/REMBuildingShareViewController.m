//
//  REMBuildingShareViewController.m
//  Blues
//
//  Created by 张 锋 on 11/1/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "REMBuildingShareViewController.h"
#import "REMBuildingWeiboView.h"
#import "REMImageView.h"

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
    //here is weibo
    [self.buildingController.sharePopoverController dismissPopoverAnimated:YES];
    
    REMMaskManager *masker = [[REMMaskManager alloc]initWithContainer:[UIApplication sharedApplication].keyWindow];
    
    [masker showMask];
    
    [self.buildingController performSelector:@selector(executeWeiboExport:) withObject:masker afterDelay:0.1];
}


-(void)mailButtonPressed:(UIButton *)button
{
    int index = self.buildingController.currentBuildingIndex;
    
    REMImageView *view = [self.buildingController.imageArray objectAtIndex:index];
    
    [view exportImage:^(UIImage *image, NSString* text){
        [self.buildingController.sharePopoverController dismissPopoverAnimated:YES];
        
        if(![MFMailComposeViewController canSendMail]){
            [REMAlertHelper alert:@"未配置邮件账户"];
            return ;
        }
        
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        
        picker.mailComposeDelegate = self;
        
        [picker setSubject:@"test"];
        
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
