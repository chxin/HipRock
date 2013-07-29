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

@interface REMLoginCarouselController ()

@property (nonatomic,strong) REMLoginPageController *loginPageController;

@end

@implementation REMLoginCarouselController

static NSInteger subViewWidth = 600;
static NSInteger subViewHeight = 600;
static NSInteger viewsDistance = 140;

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
    self.scrollView.frame = CGRectMake(142, 50, 740, 600);
    
    NSInteger viewOffset = viewsDistance/2;
    
    for(int i=0;i<3;i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(viewOffset, 0, subViewWidth, subViewHeight)];
        
        CGRect frame = view.bounds;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"preface-s%d.png", i+1]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = frame;
        
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
}

- (void) setScrollPageViewStyle
{
    for(UIView *view in self.scrollView.subviews)
    {
        //view.layer.borderColor = [[UIColor alloc] initWithWhite:0.5 alpha:1].CGColor;
        //view.layer.borderWidth = 8;
        
        view.layer.cornerRadius = 10;
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,0);
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 10;
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

    [self.pageControl setCurrentPage:page];
}

@end
