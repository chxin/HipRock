//
//  REMBuildingWeiboSendViewController.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/26/13.
//
//

#import "REMBuildingWeiboSendViewController.h"
#import "REMStatusBar.h"
#import "REMBuildingConstants.h"

const CGFloat kWeiboWindowHeight = 165;
const CGFloat kWeiboWindowWidth = 390;
const CGFloat kWeiboWindowLineHeight = 1;

const CGFloat kWeiboToolbarHeight = 42;

const CGFloat kWeiboButtonHeight = 30;
const CGFloat kWeiboButtonWidth = 60;
const CGFloat kWeiboButtonMargin = 10;

const CGFloat kWeiboTextViewMargin = 3;

const CGFloat kWeiboCharactorLabelMarginBottom = 12;
const CGFloat kWeiboCharactorLabelHeight = 9;


const CGFloat kWeiboImgOverviewWidth = 90;
const CGFloat kWeiboImgOverviewHeight = 90;
const CGFloat kWeiboImgOverviewMargin = 16;

const NSInteger kWeiboMaxLength = 140;

@interface REMBuildingWeiboSendViewController () {
    BOOL editing;
    UITextView* textView;
    UILabel* charactorLabel;
    UIButton* cancelBtn;
    UIButton* sendBtn;
}
    
@end

@implementation REMBuildingWeiboSendViewController
- (void)textViewDidChange:(UITextView *)theTextView {
    if (textView.text.length > kWeiboMaxLength) {
        sendBtn.enabled = NO;
        sendBtn.titleLabel.font = [UIFont fontWithName:@(kBuildingFontUltra) size:16];
    } else {
        sendBtn.enabled = YES;
        sendBtn.titleLabel.font = [UIFont fontWithName:@(kBuildingFontLight) size:16];
    }
    [charactorLabel setText: [NSString stringWithFormat:@"%i", (kWeiboMaxLength - [NSNumber numberWithUnsignedInteger:textView.text.length].intValue)]];
}

- (void)initTopToolbar {
    UIView* topToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWeiboWindowWidth, kWeiboToolbarHeight)];
    topToolbar.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    UILabel* toolbarLabel = [[UILabel alloc]initWithFrame:topToolbar.frame];
    [toolbarLabel setText:@"新浪微博"];
    toolbarLabel.textAlignment = NSTextAlignmentCenter;
    toolbarLabel.backgroundColor = [UIColor clearColor];
    [toolbarLabel setTextColor:[UIColor blackColor]];
    toolbarLabel.font = [UIFont fontWithName:@(kBuildingFontLight) size:16];
    //toolbarLabel.font.
    [topToolbar addSubview:toolbarLabel];
    
    
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(kWeiboButtonMargin, 0, kWeiboButtonWidth, kWeiboToolbarHeight)];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@(kBuildingFontUltra) size:16];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setFrame:CGRectMake(kWeiboWindowWidth - kWeiboButtonWidth - kWeiboButtonMargin, 0, kWeiboButtonWidth, kWeiboToolbarHeight)];
    sendBtn.titleLabel.font = [UIFont fontWithName:@(kBuildingFontLight) size:16];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sendBtn setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:cancelBtn];
    [topToolbar addSubview:sendBtn];
    
    topToolbar.layer.borderColor = [UIColor redColor].CGColor;
    topToolbar.layer.borderWidth = 1;
    toolbarLabel.layer.borderColor = [UIColor grayColor].CGColor;
    toolbarLabel.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [UIColor greenColor].CGColor;
    cancelBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [UIColor greenColor].CGColor;
    sendBtn.layer.borderWidth = 1;
    
    [self.view addSubview:topToolbar];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didKeyboardShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(didKeyboardHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initTextAndImage {
    CGFloat secondViewHeight = kWeiboWindowHeight - kWeiboToolbarHeight - kWeiboWindowLineHeight;
    CGFloat leftViewWidth = kWeiboWindowWidth - kWeiboImgOverviewWidth - kWeiboImgOverviewMargin * 2;
    
    UIView* secondView = [[UIView alloc]initWithFrame:CGRectMake(0, kWeiboToolbarHeight + 1, kWeiboWindowWidth, secondViewHeight)];
    secondView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(kWeiboTextViewMargin, kWeiboTextViewMargin, leftViewWidth - kWeiboTextViewMargin, secondViewHeight - kWeiboTextViewMargin - kWeiboCharactorLabelHeight - kWeiboCharactorLabelMarginBottom)];
    [textView setFont:[UIFont fontWithName:@(kBuildingFontLight) size:16]];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = YES;
    [secondView addSubview:textView];
    
    charactorLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, secondViewHeight - kWeiboCharactorLabelHeight - kWeiboCharactorLabelMarginBottom, 100, kWeiboCharactorLabelHeight)];
    charactorLabel.backgroundColor = [UIColor clearColor];
    [charactorLabel setFont:[UIFont fontWithName:@(kBuildingFontLight) size:9]];
    [charactorLabel setTextColor:[UIColor grayColor]];
    [secondView addSubview:charactorLabel];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWeiboWindowWidth - kWeiboImgOverviewMargin - kWeiboImgOverviewWidth, kWeiboImgOverviewMargin, kWeiboImgOverviewWidth, kWeiboImgOverviewHeight)];
    CGFloat resizeWidth = 0;
    CGFloat resizeHeight = 0;
    CGFloat overviewWidthHeightRatio = kWeiboImgOverviewWidth / kWeiboImgOverviewHeight;
    CGFloat weiboPicWidthHeightRatio = self.weiboImage.size.width / self.weiboImage.size.height;
    if (overviewWidthHeightRatio > weiboPicWidthHeightRatio) {
        resizeWidth = kWeiboImgOverviewWidth;
        resizeHeight = self.weiboImage.size.height * kWeiboImgOverviewWidth / self.weiboImage.size.width;
    } else {
        resizeHeight = kWeiboImgOverviewHeight;
        resizeWidth = self.weiboImage.size.width * kWeiboImgOverviewHeight / self.weiboImage.size.height;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(kWeiboImgOverviewWidth, kWeiboImgOverviewHeight));
    [self.weiboImage drawInRect:CGRectMake(0, 0, resizeWidth, resizeHeight)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageView setImage: reSizeImage];
    
    [secondView addSubview:imageView];
    [self.view addSubview:secondView];
    [textView becomeFirstResponder];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1];
    [self initTopToolbar];
    [self initTextAndImage];
    
    textView.delegate = self;
    [textView setText:self.weiboText];
    [charactorLabel setText:@"140"];
    
    [super viewDidLoad];
    
    editing = NO;
    
    [self textViewDidChange:textView];
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
    if (![Weibo.weibo isAuthenticated]) {
//        [REMAlertHelper alert:@"未绑定微博账户。"];
        [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
            NSString *message = nil;
            if (!error) {
                [self sendWeibo];
            }
            else {
                message = [NSString stringWithFormat:@"微博账户绑定失败: %@", error];
                [REMAlertHelper alert:message];
            }
        }];
    } else {
        [self sendWeibo];
    }
}
-(void)sendWeibo {
//    [UIView beginAnimations:@"move" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.4f];
//    self.view.superview.bounds = CGRectMake(0, -100, kWeiboWindowWidth, kWeiboWindowHeight);
//    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 100)];
//    [UIView commitAnimations];

    [REMStatusBar showStatusMessage:@"新浪微博发送中…" autoHide:NO];
    [Weibo.weibo newStatus:textView.text pic:UIImagePNGRepresentation(self.weiboImage) completed:^(Status *status, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"failed to post:%@", error];
            NSLog(@"%@", message);
            [REMStatusBar showStatusMessage:@"新浪微博发送失败"];
        }
        else {
            [REMStatusBar showStatusMessage:@"新浪微博发送成功"];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    editing = YES;
//    [UIView beginAnimations:@"move" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.4f];
//    self.view.superview.bounds = CGRectMake(0, -100, kWeiboWindowWidth, kWeiboWindowHeight);
//    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 100)];
//    [UIView commitAnimations];
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView {
//    editing = NO;
//    [UIView beginAnimations:@"move" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.4f];
//    self.view.superview.bounds = CGRectMake(0, 0, kWeiboWindowWidth, kWeiboWindowHeight);
//    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 0)];
//    [UIView commitAnimations];
//}

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
