//
//  REMBuildingWeiboSendViewController.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/26/13.
//
//

#import "REMBuildingWeiboSendViewController.h"
#import "REMStatusBar.h"

const CGFloat kWeiboWindowHeight = 200;
const CGFloat kToolbarHeight = 20;
const CGFloat kWeiboWindowWidth = 500;
const CGFloat kWeiboToolbarHeight = 40;
const CGFloat kWeiboButtonHeight = 30;
const CGFloat kWeiboButtonWidth = 60;
const CGFloat kWeiboButtonMargin = 10;
const CGFloat kWeiboImgOverviewWidth = 200;
const CGFloat kWeiboImgOverviewHeight = 200;

@interface REMBuildingWeiboSendViewController () {
    BOOL editing;
    UITextView* textView;
}
    
@end

@implementation REMBuildingWeiboSendViewController

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
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kWeiboWindowWidth, kWeiboToolbarHeight)];
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, kWeiboToolbarHeight, 300, kWeiboWindowHeight - kWeiboToolbarHeight)];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(300, kWeiboToolbarHeight, kWeiboImgOverviewWidth, kWeiboImgOverviewHeight)];
    UIGraphicsBeginImageContext(CGSizeMake(kWeiboImgOverviewWidth, kWeiboImgOverviewHeight));
    [self.weiboImage drawInRect:CGRectMake(0, 0, kWeiboImgOverviewWidth, kWeiboImgOverviewHeight)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageView setImage: reSizeImage];
    
    [cancelBtn setFrame:CGRectMake(kWeiboButtonMargin, (kWeiboToolbarHeight - kWeiboButtonHeight) / 2, kWeiboButtonWidth, kWeiboToolbarHeight)];
    [sendBtn setFrame:CGRectMake(kWeiboWindowWidth - kWeiboButtonWidth - kWeiboButtonMargin, (kWeiboToolbarHeight - kWeiboButtonHeight) / 2, kWeiboButtonWidth, kWeiboToolbarHeight)];
    textView.delegate = self;
    [textView setText:self.weiboText];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:cancelBtn];
    [toolbar addSubview:sendBtn];
    
    [self.view addSubview:toolbar];
    [self.view addSubview:textView];
    [self.view addSubview:imageView];
    [super viewDidLoad];
    
    editing = NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendClicked:(id)sender {
    [REMStatusBar showStatusMessage:@"微博发送中" autoHide:NO];
    [Weibo.weibo newStatus:textView.text pic:UIImagePNGRepresentation(self.weiboImage) completed:^(Status *status, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"failed to post:%@", error];
            NSLog(@"%@", message);
            [REMStatusBar showStatusMessage:@"微博发送失败"];
        }
        else {
            [REMStatusBar showStatusMessage:@"微博发送成功"];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    editing = YES;
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    self.view.superview.bounds = CGRectMake(0, -100, kWeiboWindowWidth, kWeiboWindowHeight);
    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 100)];
    [UIView commitAnimations];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    editing = NO;
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    self.view.superview.bounds = CGRectMake(0, 0, kWeiboWindowWidth, kWeiboWindowHeight);
    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 0)];
    [UIView commitAnimations];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //    CGRect curretnRect = self.view.superview.frame;
    //    CGRect appRect = [UIScreen mainScreen].applicationFrame;
    
    //self.view.superview.backgroundColor = [UIColor clearColor];
    //    CGFloat offsetY = (appRect.size.width + kToolbarHeight - kWeiboWindowHeight) / 2 - curretnRect.origin.y;
    //    CGFloat offsetX = (appRect.size.height - kWeiboWindowWidth) / 2 - curretnRect.origin.x;
    
    //    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 0)];
    if (editing == NO)
    self.view.superview.bounds = CGRectMake(0, 0, kWeiboWindowWidth, kWeiboWindowHeight);
}

@end
