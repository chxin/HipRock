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

static NSInteger subViewWidth = 550;
static NSInteger subViewHeight = 580;
static NSInteger viewsDistance = 150;

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
}

- (void) initialize
{
    [self.scrollView setDelegate:self];
    self.scrollView.frame = CGRectMake((1024-subViewWidth+viewsDistance)/2, 50, subViewWidth+viewsDistance, subViewHeight);
    
    NSInteger viewOffset = viewsDistance/2;
    
    for(int i=0;i<=3;i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewOffset, 0, subViewWidth, subViewHeight)];
        
        CGRect frame = view.bounds;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"preface-s%d.png", i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = frame;
        //make image view round bordered
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 15;
        
        
        [view addSubview:imageView];
        
        [self.scrollView addSubview:view];
        
        viewOffset += view.frame.size.width + viewsDistance;
    }
    
    UIView *loginView = self.loginPageController.view;
    loginView.frame = CGRectMake(viewOffset, 0, subViewWidth, subViewHeight);
    
    
    [self.scrollView addSubview:loginView];
    
    [self setScrollPageViewStyle];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.scrollView.subviews.count;
    
    int viewCount = self.scrollView.subviews.count;
    int contentWidth = viewCount*(subViewWidth+viewsDistance);
    
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(viewOffset-viewsDistance/2, 0);
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initializationCarousel) userInfo:nil repeats:NO];
}

- (void)initializationCarousel
{
    CGRect rect = CGRectMake(0, 0, subViewWidth+viewsDistance, subViewHeight);
    [UIView animateWithDuration:1.5 animations:^(void){
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }];
}

- (void) setScrollPageViewStyle
{
    for(UIView *view in self.scrollView.subviews)
    {
        //view.layer.borderColor = [[UIColor alloc] initWithWhite:0.5 alpha:1].CGColor;
        //view.layer.borderWidth = 8;
        
        view.layer.cornerRadius = 15;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,0);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 15;
    }
}

- (IBAction)pageChanged:(id)sender {
    UIPageControl *pager = (UIPageControl *)sender;
    [self showPage:pager.currentPage];
}

- (IBAction)gotoLoginButtonTouchDown:(id)sender {
    [self showPage:self.scrollView.subviews.count-1];
}

- (void)showPage:(int) page
{
    if(page<0 || page>=self.scrollView.subviews.count)
        return;
    
    int offset = (subViewWidth + viewsDistance) * page;
    
    CGRect visiableZone = self.scrollView.bounds;
    visiableZone.origin = CGPointMake(offset, self.scrollView.contentOffset.y);
    
    [self.scrollView scrollRectToVisible:visiableZone animated:YES];
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
        [self.gotoLoginButton setEnabled:NO];
    if(page==0 || page == self.pageControl.numberOfPages-2)
        [self.gotoLoginButton setEnabled:YES];
}

@end
