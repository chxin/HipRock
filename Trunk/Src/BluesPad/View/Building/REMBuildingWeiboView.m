//
//  REMBuildingWeiboView.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/4/13.
//
//

#import "REMBuildingWeiboView.h"
#import "REMColor.h"

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
    buttonTextSize = 16;
    titleTextSize = 16;
    inputTextSize = 16;
    
    weiboContentView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - kWeiboWindowWidth) / 2, (self.frame.size.height - kWeiboWindowHeight) / 2, kWeiboWindowWidth, kWeiboWindowHeight)];
    weiboContentView.layer.cornerRadius = 5;
    weiboContentView.layer.masksToBounds = YES;
    weiboContentView.backgroundColor = toolbarBottomLineColor;
    
    UIView* topToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWeiboWindowWidth, kWeiboToolbarHeight)];
    topToolbar.backgroundColor = mainBackgroundColor;
    UILabel* toolbarLabel = [[UILabel alloc]initWithFrame:topToolbar.frame];
    [toolbarLabel setText:@"新浪微博"];
    toolbarLabel.textAlignment = NSTextAlignmentCenter;
    toolbarLabel.backgroundColor = [UIColor clearColor];
    [toolbarLabel setTextColor:[UIColor blackColor]];
    toolbarLabel.font = [UIFont fontWithName:@(kBuildingFontLight) size:titleTextSize];
    [topToolbar addSubview:toolbarLabel];
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(kWeiboButtonMargin, 0, kWeiboButtonWidth, kWeiboToolbarHeight)];
    cancelBtn.titleLabel.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:buttonTextSize];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn setTitleColor:buttonEnableTextColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setFrame:CGRectMake(kWeiboWindowWidth - kWeiboButtonWidth - kWeiboButtonMargin, 0, kWeiboButtonWidth, kWeiboToolbarHeight)];
    sendBtn.titleLabel.font = [UIFont fontWithName:@(kBuildingFontSC) size:buttonTextSize];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [sendBtn setTitleColor:buttonEnableTextColor forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:cancelBtn];
    [topToolbar addSubview:sendBtn];
    
    [weiboContentView addSubview:topToolbar];
    
    
    
    
    
    CGFloat textImageViewHeight = kWeiboWindowHeight - kWeiboToolbarHeight - kWeiboWindowLineHeight;
    CGFloat leftViewWidth = kWeiboWindowWidth - kWeiboImgOverviewWidth - kWeiboImgOverviewMargin * 2;
    
    UIView* textImageView = [[UIView alloc]initWithFrame:CGRectMake(0, kWeiboToolbarHeight + kWeiboWindowLineHeight, kWeiboWindowWidth, textImageViewHeight)];
    textImageView.backgroundColor = mainBackgroundColor;
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(kWeiboTextViewMargin, kWeiboTextViewMargin, leftViewWidth - kWeiboTextViewMargin, textImageViewHeight - kWeiboTextViewMargin - kWeiboCharactorLabelHeight - kWeiboCharactorLabelMarginBottom)];
    [textView setFont:[UIFont fontWithName:@(kBuildingFontSCRegular) size:inputTextSize]];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = YES;
    textView.editable = YES;
    [textImageView addSubview:textView];
    textView.text = self.weiboText;
    textView.delegate = self;
    
    charactorLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, textImageViewHeight - kWeiboCharactorLabelHeight - kWeiboCharactorLabelMarginBottom, 100, kWeiboCharactorLabelHeight)];
    charactorLabel.backgroundColor = [UIColor clearColor];
    [charactorLabel setFont:[UIFont fontWithName:@(kBuildingFontSCRegular) size:9]];
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
    [self close:YES];
}

-(void)show:(BOOL)fadeIn {
    [super show: fadeIn];
    [textView becomeFirstResponder];
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
