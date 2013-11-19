/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPrefaceViewController.m
 * Created      : 张 锋 on 7/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <QuartzCore/QuartzCore.h>
#import "REMLoginCarouselController.h"
#import "REMAlertHelper.h"
#import "REMLoginPageController.h"
#import "REMImages.h"
#import "REMStoryboardDefinitions.h"
#import "REMLoginCard.h"

@interface REMLoginCarouselController ()

@property (nonatomic,weak) REMLoginPageController *loginPageController;

@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) UIButton *skipToLoginButton;
@property (weak, nonatomic) UIButton *skipToDemoButton;

@end

@implementation REMLoginCarouselController

const int cardCount = 4;

- (void)loadView
{
    [super loadView];
    if(self){
        //load scroll view
        [self loadScrollView];
        
        //load jump button
        [self loadSkipButtons];
    }
}

-(void)loadScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:kDMDefaultViewFrame];
    scrollView.contentSize = CGSizeMake(cardCount * kDMScreenWidth, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //load paging control
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(kDMScreenWidth/2, kDMLogin_PageControlTopOffset);
    pageControl.numberOfPages = cardCount;
    pageControl.currentPage = 0;
    pageControl.autoresizingMask = UIViewAutoresizingNone;
    pageControl.backgroundColor = [UIColor redColor];
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

-(void)loadSkipButtons
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, 12.0, 0, 12.0);
    NSString *title = REMLocalizedString(@"Login_SkipToLoginButtonText");
    UIColor *titleColor = [REMColor colorByHexString:kDMLogin_SkipToLoginButtonFontColor];
    
    UIButton *skipToLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipToLoginButton.frame = CGRectMake((kDMScreenWidth-kDMLogin_SkipToLoginButtonWidth)/2, kDMLogin_SkipToLoginButtonTopOffset, kDMLogin_SkipToLoginButtonWidth, kDMLogin_SkipToLoginButtonHeight);
    skipToLoginButton.titleLabel.font = [UIFont systemFontOfSize:kDMLogin_SkipToLoginButtonFontSize];
    
    [skipToLoginButton setTitleColor:titleColor forState:UIControlStateNormal];
    [skipToLoginButton setTitle:title forState:UIControlStateNormal];
    [skipToLoginButton setBackgroundImage:[REMIMG_JumpLogin_Normal resizableImageWithCapInsets:imageInsets] forState:UIControlStateNormal];
    [skipToLoginButton setBackgroundImage:[REMIMG_JumpLogin_Pressed resizableImageWithCapInsets:imageInsets] forState:UIControlStateHighlighted];
    [skipToLoginButton addTarget:self action:@selector(jumpLoginButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:skipToLoginButton];
    self.skipToLoginButton = skipToLoginButton;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(cardCount * kDMScreenWidth, 0);

    [self loadCards];
}

- (void)loadCards
{
    for (int i=0; i<cardCount; i++) {
        UIView *content = i < cardCount - 1 ? [self renderImageCard:i] : [self renderLoginCard];
        
        REMLoginCard *card = [[REMLoginCard alloc] initWithContentView:content];
        card.frame = CGRectMake(kDMScreenWidth * i, card.frame.origin.y, card.frame.size.width, card.frame.size.height);
        
        [self.scrollView addSubview:card];
    }
}


-(UIView *)renderImageCard:(int)index
{
    NSString *imageName = [NSString stringWithFormat: @"Propaganda_%d", index+1];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:REMLoadImageResource(imageName, @"jpg")];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    return imageView;
}

-(UIView *)renderLoginCard
{
    REMLoginPageController *loginPageController = [self.storyboard instantiateViewControllerWithIdentifier:kStoryboard_LoginPage];
    
    [self addChildViewController:loginPageController];
    self.loginPageController = loginPageController;
    self.loginPageController.loginCarouselController = self;
    
    return loginPageController.view;
}

- (void)playCarousel
{
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.scrollView scrollRectToVisible:kDMDefaultViewFrame animated:NO];
    } completion:nil];
}


- (void)pageChanged:(id)sender {
    UIPageControl *pager = (UIPageControl *)sender;
    [self showPage:pager.currentPage withEaseAnimation:NO];
}

- (void)jumpLoginButtonTouchDown:(id)sender {
    [self showLoginCard];
}

- (void)showLoginCard
{
    [self showPage:cardCount-1 withEaseAnimation:YES];
}

- (void)showPage:(int) page withEaseAnimation:(BOOL)ease
{
    if(page<0 || page>=self.scrollView.subviews.count)
        return;
    
    int offset = kDMScreenWidth * page;
    
    CGRect visiableZone = self.scrollView.bounds;
    visiableZone.origin = CGPointMake(offset, self.scrollView.contentOffset.y);
    
    if(ease == YES){
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.scrollView scrollRectToVisible:visiableZone animated:NO];
        } completion:nil];
    }
    else{
        [self.scrollView scrollRectToVisible:visiableZone animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    //NSLog(@"current page: %d",page);

    [self.pageControl setCurrentPage:page];
    if(page == self.pageControl.numberOfPages-1)
        [self.skipToLoginButton setEnabled:NO];
    if(page==0 || page == self.pageControl.numberOfPages-2)
        [self.skipToLoginButton setEnabled:YES];
}

@end
