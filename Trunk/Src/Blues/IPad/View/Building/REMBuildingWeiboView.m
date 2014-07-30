/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingWeiboView.m
 * Created      : Zilong-Oscar.Xu on 9/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingWeiboView.h"
#import "REMColor.h"
#import "AFNetworking.h"
#import "REMCommonHeaders.h"

const CGFloat kWeiboWindowHeight = 165;
const CGFloat kWeiboWindowWidth = 390;
const CGFloat kWeiboWindowLineHeight = 1;

const CGFloat kWeiboToolbarHeight = 42;

const CGFloat kWeiboButtonHeight = 30;
const CGFloat kWeiboButtonWidth = 60;
const CGFloat kWeiboButtonMargin = 16;

const CGFloat kWeiboTextViewMargin = 9;

const CGFloat kWeiboCharactorLabelMarginBottom = 12;
const CGFloat kWeiboCharactorLabelHeight = 9;


const CGFloat kWeiboImgOverviewWidth = 90;
const CGFloat kWeiboImgOverviewHeight = 90;
const CGFloat kWeiboImgOverviewMargin = 16;

const NSInteger kWeiboMaxLength = 140;


@implementation REMBuildingWeiboView {
    UIColor *toolbarBottomLineColor;
    UIColor *mainBackgroundColor;
    UIColor *buttonEnableTextColor;
    UIColor *buttonDisableTextColor;
    NSInteger buttonTextSize;
    NSInteger titleTextSize;
    NSInteger inputTextSize;
    
    UIView* weiboContentView;
    
    UITextView* textView;
    UILabel* charactorLabel;
    UIButton* sendBtn;
    UIButton *cancelBtn;
    
    AFHTTPRequestOperation *weiboNetworkValidateOperation;
}

- (void)close:(BOOL)fadeOut {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super close:fadeOut];
}

- (REMModalView*)initWithSuperView:(UIView*)superView text:(NSString*)text image:(UIImage*)image {
    self = [super initWithSuperView:superView];
    self.weiboText = text;
    self.weiboImage = image;
    return self;
}

- (void)renderContentView
{
    toolbarBottomLineColor  = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1];
    mainBackgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    buttonEnableTextColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
    buttonDisableTextColor = [REMColor colorByHexString:@"#95959a"];
    buttonTextSize = 17;
    titleTextSize = 17;
    inputTextSize = 17;
    
    weiboContentView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - kWeiboWindowWidth) / 2, (self.frame.size.height - kWeiboWindowHeight) / 2, kWeiboWindowWidth, kWeiboWindowHeight)];
    weiboContentView.layer.cornerRadius = 5;
    weiboContentView.layer.masksToBounds = YES;
    weiboContentView.backgroundColor = toolbarBottomLineColor;
    
    UIView* topToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWeiboWindowWidth, kWeiboToolbarHeight)];
    topToolbar.backgroundColor = mainBackgroundColor;
    UILabel* toolbarLabel = [[UILabel alloc]initWithFrame:topToolbar.frame];
    [toolbarLabel setText:REMIPadLocalizedString(@"Weibo_WindowTitle")];
    toolbarLabel.textAlignment = NSTextAlignmentCenter;
    toolbarLabel.backgroundColor = [UIColor clearColor];
    [toolbarLabel setTextColor:[UIColor blackColor]];
    toolbarLabel.font = [REMFont defaultFontOfSize:titleTextSize];// [REMFont fontWithKey:@(kBuildingFontKeyTitle) size:titleTextSize];
    [topToolbar addSubview:toolbarLabel];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn setFrame:CGRectMake(kWeiboButtonMargin, 0, kWeiboButtonWidth, kWeiboToolbarHeight)];
    cancelBtn.titleLabel.font = [REMFont defaultFontOfSize:buttonTextSize];//[REMFont fontWithKey:@(kBuildingFontKeyRegular) size:buttonTextSize];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn setTitleColor:buttonEnableTextColor forState:UIControlStateNormal];
    [cancelBtn setTitle:REMIPadLocalizedString(@"Weibo_CancelButtonText") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [sendBtn setFrame:CGRectMake(kWeiboWindowWidth - kWeiboButtonWidth - kWeiboButtonMargin, 0, kWeiboButtonWidth, kWeiboToolbarHeight)];
    sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    sendBtn.titleLabel.font = [REMFont defaultFontOfSize:buttonTextSize];//[REMFont fontWithKey:@(kBuildingFontKeyTitle) size:buttonTextSize];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sendBtn setTitleColor:buttonEnableTextColor forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [sendBtn setTitle:REMIPadLocalizedString(@"Weibo_SendButtonText") forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:cancelBtn];
    [topToolbar addSubview:sendBtn];
    
    [weiboContentView addSubview:topToolbar];
    
    
    
    
    
    CGFloat textImageViewHeight = kWeiboWindowHeight - kWeiboToolbarHeight - kWeiboWindowLineHeight;
    CGFloat leftViewWidth = kWeiboWindowWidth - kWeiboImgOverviewWidth - kWeiboImgOverviewMargin * 2;
    
    UIView* textImageView = [[UIView alloc]initWithFrame:CGRectMake(0, kWeiboToolbarHeight + kWeiboWindowLineHeight, kWeiboWindowWidth, textImageViewHeight)];
    textImageView.backgroundColor = mainBackgroundColor;
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(kWeiboTextViewMargin, kWeiboTextViewMargin, leftViewWidth - kWeiboTextViewMargin, textImageViewHeight - kWeiboTextViewMargin - kWeiboCharactorLabelHeight - kWeiboCharactorLabelMarginBottom)];
    [textView setFont:[REMFont defaultFontOfSize:inputTextSize]];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = YES;
    textView.editable = YES;
    [textImageView addSubview:textView];
    textView.text = self.weiboText;
    textView.delegate = self;
    
    charactorLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, textImageViewHeight - kWeiboCharactorLabelHeight - kWeiboCharactorLabelMarginBottom, 100, kWeiboCharactorLabelHeight)];
    charactorLabel.backgroundColor = [UIColor clearColor];
    [charactorLabel setFont:[REMFont defaultFontOfSize:9]];
    [charactorLabel setTextColor:[UIColor grayColor]];
    [textImageView addSubview:charactorLabel];
    [charactorLabel setText:[NSString stringWithFormat:@"%i", (kWeiboMaxLength-self.weiboText.length)]];
    
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
    
    [textImageView addSubview:imageView];
    
    [weiboContentView addSubview:textImageView];
    
    
    
    
    [self addSubview:weiboContentView];
    
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardHideNotify:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShowNotify:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    weiboContentView.frame = CGRectMake((self.frame.size.width - kWeiboWindowWidth) / 2, (self.frame.size.height - kWeiboWindowHeight - keyboardRect.size.width) / 2, kWeiboWindowWidth, kWeiboWindowHeight);
    [UIView commitAnimations];
}

-(void)keyboardHideNotify:(NSNotification*)aNotification {
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    weiboContentView.frame = CGRectMake((self.frame.size.width - kWeiboWindowWidth) / 2, (self.frame.size.height - kWeiboWindowHeight) / 2, kWeiboWindowWidth, kWeiboWindowHeight);
    [UIView commitAnimations];
}

-(void)cancelClicked:(id)sender {
    [weiboNetworkValidateOperation cancel];
    [self close:YES];
}

-(void)show:(BOOL)fadeIn {
    [super show: fadeIn];
    [textView becomeFirstResponder];
}

-(void)sendClicked:(id)sender {
    //NetworkStatus reachability = [REMHttpHelper checkCurrentNetworkStatus];
    [sendBtn setEnabled:NO];
    
    weiboNetworkValidateOperation = [REMAppContext.sharedRequestOperationManager HEAD:@"http://api.weibo.com" parameters:nil success:^(AFHTTPRequestOperation *operation) {
        if (![Weibo.weibo isAuthenticated]) {
            //        [REMAlertHelper alert:@"未绑定微博账户。"];
            [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
                NSString *message = nil;
                if (!error) {
                    [self sendWeibo];
                }
                else {
                    message = [NSString stringWithFormat:REMIPadLocalizedString(@"Weibo_AccountBindingFail"), error];
                    [REMAlertHelper alert:message];
                }
            }];
        } else {
            [self sendWeibo];
        }
        [sendBtn setEnabled:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(error.code != -999){
            [REMAlertHelper alert:REMIPadLocalizedString(@"Weibo_NONetwork")];
        }
        [sendBtn setEnabled:YES];
    }];
    
    
    
    
//    if (reachability == NotReachable) {
//        
//    } else {
//    }
}

-(void)sendWeibo {
    //    [UIView beginAnimations:@"move" context:nil];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDuration:0.4f];
    //    self.view.superview.bounds = CGRectMake(0, -100, kWeiboWindowWidth, kWeiboWindowHeight);
    //    [self.view.superview.layer setShadowOffset:CGSizeMake(0, 100)];
    //    [UIView commitAnimations];
    
    [REMStatusBar showStatusMessage:REMIPadLocalizedString(@"Weibo_IsSending") autoHide:NO];
    [Weibo.weibo newStatus:textView.text pic:UIImagePNGRepresentation(self.weiboImage) completed:^(Status *status, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"failed to post:%@", error];
            NSLog(@"%@", message);
            [REMStatusBar showStatusMessage:REMIPadLocalizedString(@"Weibo_SentFail")];
        }
        else {
            [REMStatusBar showStatusMessage:REMIPadLocalizedString(@"Weibo_SentSuccess")];
        }
    }];
    [self close:YES];
}


- (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (void)textViewDidChange:(UITextView *)theTextView {
    NSUInteger textLength = [self convertToInt:textView.text];
    [charactorLabel setText:[NSString stringWithFormat:@"%i", (kWeiboMaxLength-textLength)]];
    if (((textLength > kWeiboMaxLength) || textLength == 0)) {
        if (sendBtn.enabled) {
            sendBtn.enabled = NO;
            [sendBtn setTitleColor:buttonDisableTextColor forState:UIControlStateNormal];
        }
    } else {
        if (!sendBtn.enabled) {
            sendBtn.enabled = YES;
            [sendBtn setTitleColor:buttonEnableTextColor forState:UIControlStateNormal];
        }
    }
}
@end
