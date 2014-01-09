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
#import "REMLoginCardController.h"
#import "REMImages.h"
#import "REMStoryboardDefinitions.h"
#import "REMLoginCard.h"
#import "REMTrialCardController.h"
#import "REMLoginTitledCard.h"
#import "REMLoginCustomerTableViewController.h"

@interface REMLoginCarouselController ()


@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) UIButton *skipToLoginButton;
@property (weak, nonatomic) UIButton *skipToTrialButton;

@end

@implementation REMLoginCarouselController

static const int kCardCount = 5;
static const int kLoginCardIndex = kCardCount - 1;
static const int kTrialCardIndex = kCardCount - 2;

- (void)loadView
{
    //[super loadView];
    self.view = [[UIView alloc] initWithFrame: kDMDefaultViewFrame];
    
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
    scrollView.contentSize = CGSizeMake(kCardCount * kDMScreenWidth, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //load paging control
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(kDMScreenWidth/2, kDMLogin_PageControlTopOffset);
    pageControl.numberOfPages = kCardCount;
    pageControl.currentPage = 0;
    pageControl.autoresizingMask = UIViewAutoresizingNone;
    pageControl.backgroundColor = [UIColor redColor];
    pageControl.alpha = 0;
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

-(void)loadSkipButtons
{
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(5.0f, 12.0f, 18.0f, 12.0f);
    
    
    UIButton *skipToTrialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipToTrialButton.frame = CGRectMake((kDMScreenWidth-2*kDMLogin_SkipToLoginButtonWidth - kDMLogin_SkipToLoginButtonLeftOffset)/2, kDMLogin_SkipToLoginButtonTopOffset, kDMLogin_SkipToLoginButtonWidth, kDMLogin_SkipToLoginButtonHeight);
    skipToTrialButton.alpha = 0;
    skipToTrialButton.titleLabel.font = [UIFont systemFontOfSize:kDMLogin_SkipToTrialButtonFontSize];
    
    [skipToTrialButton setTitleColor:[REMColor colorByHexString:kDMLogin_SkipToTrialButtonFontColor] forState:UIControlStateNormal];
    [skipToTrialButton setTitle:REMLocalizedString(@"Login_SkipToTrialButtonText") forState:UIControlStateNormal];
    [skipToTrialButton setBackgroundImage:[REMIMG_JumpTrial resizableImageWithCapInsets:imageInsets] forState:UIControlStateNormal];
    [skipToTrialButton setBackgroundImage:[REMIMG_JumpTrial_Pressed resizableImageWithCapInsets:imageInsets] forState:UIControlStateHighlighted];
    [skipToTrialButton addTarget:self action:@selector(jumpTrialButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    skipToTrialButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    skipToTrialButton.titleEdgeInsets = UIEdgeInsetsMake(kDMLogin_SkipToTrialButtonTextTopOffset, 0, 0, 0);
    
    
    
    
    UIButton *skipToLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipToLoginButton.frame = CGRectMake(skipToTrialButton.frame.origin.x + kDMLogin_SkipToLoginButtonWidth + kDMLogin_SkipToLoginButtonLeftOffset, kDMLogin_SkipToLoginButtonTopOffset, kDMLogin_SkipToLoginButtonWidth, kDMLogin_SkipToLoginButtonHeight);
    skipToLoginButton.alpha = 0;
    skipToLoginButton.titleLabel.font = [UIFont systemFontOfSize:kDMLogin_SkipToLoginButtonFontSize];
    
    [skipToLoginButton setTitleColor:[REMColor colorByHexString:kDMLogin_SkipToLoginButtonFontColor] forState:UIControlStateNormal];
    [skipToLoginButton setTitle:REMLocalizedString(@"Login_SkipToLoginButtonText") forState:UIControlStateNormal];
    [skipToLoginButton setBackgroundImage:[REMIMG_JumpLogin resizableImageWithCapInsets:imageInsets] forState:UIControlStateNormal];
    [skipToLoginButton setBackgroundImage:[REMIMG_JumpLogin_Pressed resizableImageWithCapInsets:imageInsets] forState:UIControlStateHighlighted];
    [skipToLoginButton addTarget:self action:@selector(jumpLoginButtonTouchDown:) forControlEvents:UIControlEventTouchUpInside];
    skipToLoginButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    skipToLoginButton.titleEdgeInsets = UIEdgeInsetsMake(kDMLogin_SkipToLoginButtonTextTopOffset, 0, 0, 0);

    
    [self.view addSubview:skipToLoginButton];
    self.skipToLoginButton = skipToLoginButton;
    
    [self.view addSubview:skipToTrialButton];
    self.skipToTrialButton = skipToTrialButton;
}

- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden = YES;
    
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake((kCardCount) * kDMScreenWidth, 0);

    [self loadCards];
}

- (void)loadCards
{
    for (int i=0; i<kCardCount; i++) {
        
        UIView *card = nil;
        if(i == kLoginCardIndex){
            card = [self renderLoginCard];
        }
        else if(i == kTrialCardIndex){
            card = [self renderTrialCard];
        }
        else{
            UIView *content = [self renderImageCard:i];
            card = [[REMLoginCard alloc] initWithContentView:content];
        }
        
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
    REMLoginCardController *loginPageController = [[REMLoginCardController alloc] init];
    
    [self addChildViewController:loginPageController];
    self.loginCardController = loginPageController;
    self.loginCardController.loginCarouselController = self;
    
    return loginPageController.view;
}

-(UIView *)renderTrialCard
{
    REMTrialCardController *trialController = [[REMTrialCardController alloc] init];
    trialController.loginCarouselController = self;
    
    [self addChildViewController:trialController];
    self.trialCardController = trialController;
    
    return trialController.view;
}

-(void)playCarousel:(BOOL)isAnimated
{
    if(isAnimated){
        [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.skipToLoginButton.alpha = 1;
            self.skipToTrialButton.alpha = 1;
            self.pageControl.alpha = 1;
        } completion:nil];
        [UIView animateWithDuration:1.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.scrollView scrollRectToVisible:kDMDefaultViewFrame animated:NO];
        } completion:nil];
    }
    else{
        self.skipToLoginButton.alpha = 1;
        self.skipToTrialButton.alpha = 1;
        self.pageControl.alpha = 1;
        
        [self.loginCardController.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        [self.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        
        [self showPage:kLoginCardIndex withEaseAnimation:NO];
    }
}



- (void)pageChanged:(id)sender {
    UIPageControl *pager = (UIPageControl *)sender;
    [self showPage:pager.currentPage withEaseAnimation:NO];
}

- (void)jumpLoginButtonTouchDown:(id)sender {
    [self showLoginCard];
}

-(void)jumpTrialButtonTouchDown:(id)sender{
    [self showPage:kTrialCardIndex withEaseAnimation:YES];
}

- (void)showLoginCard
{
    [self showPage:kLoginCardIndex withEaseAnimation:YES];
}

- (void)showPage:(int) page withEaseAnimation:(BOOL)ease
{
    if(page<0 || page>=self.scrollView.subviews.count)
        return;
    
    int offset = kDMScreenWidth * page;
    
    CGRect visiableZone = self.scrollView.bounds;
    visiableZone.origin = CGPointMake(offset, self.scrollView.contentOffset.y);
    
    if(ease == YES){
        //[UIView animateWithDuration:(0.3 * ABS(self.pageControl.currentPage - page)) delay:0 options:
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

-(void)presentCustomerSelectionView
{
    REMLoginCustomerTableViewController *customerController = [[REMLoginCustomerTableViewController alloc] init];
    customerController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:customerController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = (NSInteger)round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    //NSLog(@"current page: %d",page);

    [self.pageControl setCurrentPage:page];
    
    [self.skipToLoginButton setEnabled:YES];
    [self.skipToTrialButton setEnabled:YES];
    
    if(page == kLoginCardIndex){
        [self.skipToLoginButton setEnabled:NO];
        [self.skipToTrialButton setEnabled:YES];
    }
    if(page == kTrialCardIndex){
        [self.skipToTrialButton setEnabled:NO];
        [self.skipToLoginButton setEnabled:YES];
    }
}

#pragma mark  Customer selection delegate

-(void)didSelectCustomer:(REMCustomerModel *)customer
{
    [REMAppContext setCurrentCustomer:customer];
    [self.loginCardController loginSuccess];
}

-(void)didDismissView
{
    [self.loginCardController.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
    [self.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
}

@end
