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

@interface REMLoginCarouselController ()

@property (nonatomic,strong) REMLoginPageController *loginPageController;

@end

@implementation REMLoginCarouselController

const NSInteger kSlideImageCount = 3;
const NSInteger kScreenWidth = 1024;
const NSInteger kSubViewWidth = 500;
const NSInteger kSubViewHeight = 350;
const NSInteger kSubViewDistance = kScreenWidth - kSubViewWidth;
const NSInteger kImagePaddingTop = 84;
const CGFloat kBackgroundLeftShadowOffset = 10;
const CGFloat kBackgroundRightShadownOffset = kBackgroundLeftShadowOffset;
const CGFloat kBackgroundTopShadowOffset = 2;
const CGFloat kBackgroundBottomShadowOffset = 18;
const CGFloat kBackgroundBorderThickness = 6;
const CGFloat kBackgroundHorizontalShadownWidth = kBackgroundLeftShadowOffset + kBackgroundRightShadownOffset;
const CGFloat kBackgroundVerticalShadowWidth = kBackgroundTopShadowOffset + kBackgroundBottomShadowOffset;
const CGFloat kBackgroundLeftContentOffset = kBackgroundLeftShadowOffset + kBackgroundBorderThickness;
const CGFloat kBackgroundRightContentOffset = kBackgroundRightShadownOffset + kBackgroundBorderThickness;
const CGFloat kBackgroundTopContentOffset = kBackgroundTopShadowOffset + kBackgroundBorderThickness;
const CGFloat kBackgroundBottomContentOffset = kBackgroundBottomShadowOffset + kBackgroundBorderThickness;



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
    
    self.navigationController.navigationBarHidden = YES;
    
    self.loginPageController = (REMLoginPageController *)[self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
    self.loginPageController.loginCarouselController = self;

    [self initialize];
    [self stylize];
}

- (void)initialize
{
    [self.scrollView setDelegate:self];
    self.scrollView.frame = CGRectMake((kScreenWidth-kSubViewWidth+kSubViewDistance)/2, 50, kSubViewWidth+kSubViewDistance, kSubViewHeight);
    
    NSInteger viewOffset = kSubViewDistance/2;
    
    for(int i=0;i<kSlideImageCount + 1;i++)
    {
        UIView *backgroundView = [self makeBackgroundView:viewOffset];
        
        UIView *slideView = i<kSlideImageCount?[self makeImageView:i]:self.loginPageController.view;
        
        CGRect viewFrame = CGRectMake(kBackgroundLeftContentOffset, kBackgroundTopContentOffset, kSubViewWidth, kSubViewHeight);
        [slideView setFrame:viewFrame];
        
        [backgroundView addSubview:slideView];
        backgroundView.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:backgroundView];
        
        
        
        viewOffset += kSubViewWidth + kSubViewDistance;
    }
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.scrollView.subviews.count;
    
    int viewCount = self.scrollView.subviews.count;
    int contentWidth = viewCount*kScreenWidth;
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(viewOffset-kSubViewDistance/2, 0);
    
//    if(self.showAnimation == YES){
//        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initializationCarousel) userInfo:nil repeats:NO];
//    }
}

- (void)stylize
{
    [self styleJumpLoginButton];
}

-(UIView *)makeBackgroundView:(CGFloat)offset
{
    UIImage *backgroundImage = [REMIMG_SlidePageBackground resizableImageWithCapInsets:UIEdgeInsetsMake(9,21,26,21)];
    
    
    CGRect backgroundFrame = CGRectMake(offset-kBackgroundLeftContentOffset, kImagePaddingTop+kBackgroundTopContentOffset, kSubViewWidth+kBackgroundLeftContentOffset + kBackgroundRightContentOffset, kSubViewHeight+kBackgroundTopContentOffset + kBackgroundBottomContentOffset);
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:backgroundFrame];
    [backgroundView setImage:backgroundImage];
    
    return backgroundView;
}

-(UIView *)makeImageView:(int)index
{
    NSString *imageName = [NSString stringWithFormat: @"Propaganda_%d", index+1];
    NSString *imageType = @"jpg";
    UIImageView *imageView = [[UIImageView alloc] initWithImage:REMLoadImage(imageName, imageType)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    return imageView;
}

- (void)initializationCarousel
{
    CGRect rect = CGRectMake(0, 0, kSubViewWidth+kSubViewDistance, kSubViewHeight);
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.scrollView scrollRectToVisible:rect animated:NO];
    } completion:nil];
}


- (IBAction)pageChanged:(id)sender {
    UIPageControl *pager = (UIPageControl *)sender;
    [self showPage:pager.currentPage withEaseAnimation:NO];
}

- (IBAction)jumpLoginButtonTouchDown:(id)sender {
    [self showLoginPage];
}

-(void)showLoginPage
{
    [self showPage:self.scrollView.subviews.count-1 withEaseAnimation:YES];
}

- (void)showPage:(int) page withEaseAnimation:(BOOL)ease
{
    if(page<0 || page>=self.scrollView.subviews.count)
        return;
    
    int offset = (kSubViewWidth + kSubViewDistance) * page;
    
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

- (void)styleJumpLoginButton
{
    //UIEdgeInsetsMake(top, left, bottom, right);
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(0, 12.0, 0, 12.0);
    
    UIImage *normalStateImage = [REMIMG_JumpLogin_Normal resizableImageWithCapInsets:imageInsets];
    UIImage *pressedStateImage = [REMIMG_JumpLogin_Pressed resizableImageWithCapInsets:imageInsets];
    
    [self.jumpLoginButton setBackgroundImage:normalStateImage forState:UIControlStateNormal];
    [self.jumpLoginButton setBackgroundImage:pressedStateImage forState:UIControlStateHighlighted];
    
    
    
    //[self.jumpLoginButton setBackgroundColor:[UIColor redColor]];
    
//    self.jumpLoginButton set
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
        [self.jumpLoginButton setEnabled:NO];
    if(page==0 || page == self.pageControl.numberOfPages-2)
        [self.jumpLoginButton setEnabled:YES];
}

@end
