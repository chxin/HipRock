//
//  REMPrefaceViewController.m
//  Blues
//
//  Created by 张 锋 on 7/25/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "REMLoginCarouselController.h"
#import "REMAlertHelper.h"
#import "REMLoginPageController.h"
#import "REMColoredButton.h"

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
const CGFloat kBackgroundLeftShadowOffset = 20;
const CGFloat kBackgroundRightShadownOffset = kBackgroundLeftShadowOffset;
const CGFloat kBackgroundTopShadowOffset = 4;
const CGFloat kBackgroundBottomShadowOffset = 35;
const CGFloat kBackgroundBorderThickness = 12;
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
    
    self.scrollView.backgroundColor = [UIColor redColor];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.scrollView.subviews.count;
    
    int viewCount = self.scrollView.subviews.count;
    int contentWidth = viewCount*kScreenWidth;
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(viewOffset-kSubViewDistance/2, 0);
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initializationCarousel) userInfo:nil repeats:NO];
}

- (void)stylize
{
    [self styleJumpLoginButton];
}

-(UIView *)makeBackgroundView:(CGFloat)offset
{
    UIImage *backgroundImage = [[UIImage imageNamed:@"loginpage-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(53,58,53,58)];
    
    
    CGRect backgroundFrame = CGRectMake(offset-kBackgroundLeftContentOffset, kImagePaddingTop+kBackgroundTopContentOffset, kSubViewWidth+kBackgroundLeftContentOffset + kBackgroundRightContentOffset, kSubViewHeight+kBackgroundTopContentOffset + kBackgroundBottomContentOffset);
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:backgroundFrame];
    [backgroundView setImage:backgroundImage];
    [backgroundView setBackgroundColor:[UIColor blueColor]];
    
    return backgroundView;
}

-(UIView *)makeImageView:(int)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"preface-s%d.png", index]]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    return imageView;
}

- (void)initializationCarousel
{
    CGRect rect = CGRectMake(0, 0, kSubViewWidth+kSubViewDistance, kSubViewHeight);
    [UIView animateWithDuration:2 animations:^(void){
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }];
}


- (IBAction)pageChanged:(id)sender {
    UIPageControl *pager = (UIPageControl *)sender;
    [self showPage:pager.currentPage];
}

- (IBAction)jumpLoginButtonTouchDown:(id)sender {
    [self showPage:self.scrollView.subviews.count-1];
}

- (void)showPage:(int) page
{
    if(page<0 || page>=self.scrollView.subviews.count)
        return;
    
    int offset = (kSubViewWidth + kSubViewDistance) * page;
    
    CGRect visiableZone = self.scrollView.bounds;
    visiableZone.origin = CGPointMake(offset, self.scrollView.contentOffset.y);
    
    [self.scrollView scrollRectToVisible:visiableZone animated:YES];
}

- (void)styleJumpLoginButton
{
    UIImage *normalStateImage = [[UIImage imageNamed:@"jumplogin-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 18, 24, 18)];
    UIImage *pressedStateImage = [[UIImage imageNamed:@"jumplogin-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 18, 24, 18)];
    
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
