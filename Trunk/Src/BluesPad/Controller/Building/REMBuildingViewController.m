/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingViewController.m
 * Created      : 张 锋 on 7/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingViewController.h"
#import "REMApplicationContext.h"
#import "WeiboSDK.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingWeiboView.h"
#import "REMMapViewController.h"
#import "REMBuildingEntranceSegue.h"
#import "REMCommonHeaders.h"
#import "REMStoryboardDefinitions.h"
#import "REMMaxWidgetSegue.h"
#import "REMDashboardController.h"
#import "REMWidgetDetailViewController.h"
#import "REMWidgetMaxViewController.h"
#import "REMWidgetCellViewController.h"
#import "REMBuildingShareViewController.h"
#import "REMDimensions.h"
#import "REMBuildingChartContainerView2.h"
#import <GPUImage/GPUImage.h>

const static CGFloat buildingGap=20;

@interface REMBuildingViewController ()

@property (nonatomic) CGFloat cumulateX;

@property (nonatomic,strong) UIImage *defaultImage;
@property (nonatomic,strong) UIImage *defaultBlurImage;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic,weak) UIImageView *sourceSnapshot;

@property (nonatomic,weak) NSTimer *stopTimer;


@property (nonatomic) BOOL isPinching;


@end



@implementation REMBuildingViewController{
}

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
    self.view.backgroundColor=[UIColor blackColor];
    [self.view setFrame:CGRectMake(0, 0, kDMScreenWidth, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight))];
    self.currentScrollOffset=-kBuildingCommodityViewTop;
    
    self.cumulateX=0;
    
    //[self addObserver:self forKeyPath:@"currentScrollOffset" options:0 context:nil];
    
    
    if(self.buildingInfoArray.count>0){
        
        [self initDefaultImageView];
        
        UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipethis:)];
        [self.view addGestureRecognizer:rec];
        rec.delegate = self;
        
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchThis:)];
        [self.view addGestureRecognizer:pinch];
    }
    
}



-(void)dealloc{
    
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ==YES ){
        if(self.childViewControllers.count<1)return YES;
        //NSLog(@"touch:%@",touch.view);
        if( [touch.view isKindOfClass:[CPTGraphHostingView class]] == YES) return NO;
        return YES;
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]==YES){
        return YES;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    BOOL needRelease=YES;
    if (self.currentCoverStatus == REMBuildingCoverStatusCoverPage) {
        for (REMBuildingImageViewController *imageController in self.childViewControllers){
            UIViewController *dashboardController= imageController.childViewControllers[1];
            if(dashboardController.isViewLoaded==YES){
                needRelease=NO;
                break;
            }
        }
    }
    else if(self.currentCoverStatus == REMBuildingCoverStatusDashboard){
        for (REMBuildingImageViewController *imageController in self.childViewControllers){
            UIViewController *coverController= imageController.childViewControllers[0];
            if(coverController.isViewLoaded==YES){
                needRelease=NO;
                break;
            }
        }
    }
    
    if(needRelease==YES){
        for (int i=0; i<self.childViewControllers.count; ++i) {
            if(i!=self.currentBuildingIndex && i!=(self.currentBuildingIndex-1) && i!=(self.currentBuildingIndex+1)){
                REMBuildingImageViewController *imageController=self.childViewControllers[i];
                [imageController releaseContentView];
            }
        }
    }
    
}

- (void)initDefaultImageView
{
    self.defaultImage = REMIMG_DefaultBuilding;
    UIImage *view = [REMImageHelper blurImage:self.defaultImage];
    self.defaultBlurImage=view;
    
    
    int i=0,count=self.buildingInfoArray.count;
    //count=2;
    for (;i<count;++i) {
        REMBuildingOverallModel *model = self.buildingInfoArray[i];
        
        REMBuildingImageViewController *subController=[[REMBuildingImageViewController alloc] init];
        subController.buildingInfo=model;
        subController.defaultImage=self.defaultImage;
        subController.defaultBlurImage=self.defaultBlurImage;
        
        subController.viewFrame=CGRectMake(i*(self.view.frame.size.width+buildingGap), self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
        
        
        [self addChildViewController:subController];
        
        [self.view addSubview:subController.view];
        
        NSInteger gap=i-self.currentBuildingIndex;
        [subController.view setCenter:CGPointMake(gap*(self.view.frame.size.width+buildingGap)+self.view.frame.size.width/2, self.view.center.y)];
        //NSLog(@"center:%@",NSStringFromCGPoint(subController.view.center));
    }
    
    [self stopCoverPage:nil];
}

- (void)setViewOffset:(CGFloat)offsetY
{
    for (REMBuildingImageViewController *controller in self.childViewControllers) {
        [controller setCurrentOffset:offsetY];
    }
}

#pragma mark -
#pragma mark buildingview


- (void) swipethis:(UIPanGestureRecognizer *)pan
{
    
    CGPoint trans= [pan translationInView:self.view];
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        for (int i=0;i<self.childViewControllers.count;++i)
        {
            UIViewController *controller=self.childViewControllers[i];
            CGFloat x;
            if(self.currentBuildingIndex == 0 && self.cumulateX>0){
                x=trans.x/4;
            }
            else if((self.currentBuildingIndex==(self.childViewControllers.count-1)) && self.cumulateX<0){
                x=trans.x/4;
            }
            else{
                x=trans.x;
            }
            
            [controller.view setCenter:CGPointMake(controller.view.center.x+x, controller.view.center.y)];
        }
        
        self.cumulateX+=trans.x;
        
        
    }
    
    if(pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled)
    {
        
        CGPoint p= [pan velocityInView:self.view];
        
        int sign= p.x>0?1:-1;
        
        
        BOOL addIndex=YES;
        
        if((sign<0 && self.currentBuildingIndex==self.childViewControllers.count-1)
           || (sign>0 && self.currentBuildingIndex==0) ||
           (ABS(p.x)<100 && ABS(self.cumulateX)<512) ||
           (p.x<0 && self.cumulateX>0) || (p.x>0 && self.cumulateX<0)){
            addIndex=NO;
        }
        else{
            [self.stopTimer invalidate];
            addIndex=YES;
        }
        self.cumulateX=0;
        
        
        if(addIndex == NO){
            [UIView animateWithDuration:0.4 delay:0
                                options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                    
                                    [self moveAllViews];
                                } completion:^(BOOL finished){
                                
                                }];
            
        }
        else{
            //[self cancelRequest:self.currentBuildingIndex];
            self.currentBuildingIndex = self.currentBuildingIndex+sign*-1;
            
            if(ABS(p.x)<200){
                [UIView animateWithDuration:0.4 delay:0
                                    options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                        
                                        [self moveAllViews];
                                    } completion:^(BOOL finished){
                                        [self stopCoverPage:nil];
                                    }];
            }
            else{
                
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|  UIViewAnimationOptionCurveEaseInOut animations:^(void){
                    [self moveAllViews];
                    
                }completion:^(BOOL finished){
                    [self.stopTimer invalidate];
                    NSTimer *timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(stopCoverPage:) userInfo:@{@"direction":@(sign)} repeats:NO];
                    NSRunLoop *current=[NSRunLoop currentRunLoop];
                    [current addTimer:timer forMode:NSDefaultRunLoopMode];
                    self.stopTimer = timer;
                }];
                
            }
            
        }
        
    }
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void)cancelRequest:(int)index{
    REMBuildingOverallModel *buildingInfo= self.buildingInfoArray[index];
    NSString *text=[NSString stringWithFormat:@"building-data-%@",buildingInfo.building.buildingId];
    
    [REMDataAccessor cancelAccess:text];
    
}


- (void) moveAllViews{
    for (int i=0; i<self.childViewControllers.count; ++i) {
        UIViewController *vc = self.childViewControllers[i];
        NSInteger gap=i-self.currentBuildingIndex;
        [vc.view setCenter:CGPointMake(gap*(self.view.frame.size.width+buildingGap)+self.view.frame.size.width/2, vc.view.center.y)];
    }
}


- (void)stopCoverPage:(NSTimer *)timer{
    //NSLog(@"complete:%d",self.currentBuildingIndex);
    REMBuildingImageViewController *vc=self.childViewControllers[self.currentBuildingIndex];
    [vc loadContentView];
    if(self.currentBuildingIndex<self.childViewControllers.count){
        NSInteger sign=[timer.userInfo[@"direction"] integerValue];
        NSNumber *willIndex= @(self.currentBuildingIndex-1*sign);
        if(willIndex.intValue>=self.childViewControllers.count || willIndex.intValue<0){
            return;
        }
        REMBuildingImageViewController *nextController= self.childViewControllers[willIndex.intValue];
        [nextController loadContentView];
        
    }
    
}






- (void)setCurrentCoverStatus:(REMBuildingCoverStatus)currentCoverStatus{
    if(_currentCoverStatus!=currentCoverStatus){
        _currentCoverStatus=currentCoverStatus;
        if(currentCoverStatus== REMBuildingCoverStatusDashboard){
            for (REMBuildingImageViewController *controller in self.childViewControllers) {
                controller.currentCoverStatus=REMBuildingCoverStatusDashboard;
            }
        }
        else{
            for (REMBuildingImageViewController *controller in self.childViewControllers) {
                controller.currentCoverStatus=REMBuildingCoverStatusCoverPage;
            }
        }
    }
}



-(void)pinchThis:(UIPinchGestureRecognizer *)pinch
{
    if(pinch.state  == UIGestureRecognizerStateBegan){
        //NSLog(@"pinch: Began");
        self.isPinching = YES;
        self.sourceSnapshot = [((id)self.fromController) snapshot];
        
        self.snapshot = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:self.view]];
        [self.view addSubview:self.sourceSnapshot];
        [self.view addSubview:self.snapshot];
    }
    
    if(pinch.state  == UIGestureRecognizerStateChanged){
        CGFloat scale = pinch.scale > 1 ? 1 : pinch.scale;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        self.snapshot.layer.affineTransform = scaleTransform;
        
        CGPoint point = [pinch locationInView:self.view];
        self.snapshot.center = point;
        
        //NSLog(@"pinch: Changed, scale: %f, point: %@", pinch.scale, NSStringFromCGPoint(point));
        
    }
    
    if(pinch.state  == UIGestureRecognizerStateEnded || pinch.state  == UIGestureRecognizerStateCancelled || pinch.state  == UIGestureRecognizerStateFailed){
        //NSLog(@"pinch: Ended, state: %d, touch numbers: %d", pinch.state, pinch.numberOfTouches);
        
        if(pinch.scale >= 1){ //scale did not change,
            CGPoint point = [pinch locationInView:self.view];
            
            if(point.x != self.view.center.x || point.y != self.view.center.y){ //but position changed
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.snapshot.center = self.view.center;
                } completion:^(BOOL finished) {
                    [self.sourceSnapshot removeFromSuperview];
                    
                    [self.snapshot removeFromSuperview];
                    self.snapshot = nil;
                    self.isPinching = NO;
                }];
            }
        }
        else{ //scale smaller
            CGRect initialiZoomRect = [((id)self.fromController) getDestinationZoomRect:self.currentBuildingIndex];
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //from self.snapshot.frame to self.mapViewController.initialZoomRect;
                self.snapshot.transform = [REMViewHelper getScaleTransformFromOriginalFrame:initialiZoomRect andFinalFrame:self.view.frame];
                self.snapshot.center = [REMViewHelper getCenterOfRect:initialiZoomRect];
            } completion:^(BOOL finished) {
                [self.sourceSnapshot removeFromSuperview];
                
                [self.snapshot removeFromSuperview];
                self.snapshot = nil;
                
                [self back];
                self.isPinching = NO;
            }];
        }
        
    }
}

#pragma mark -
#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kSegue_BuildingToMap] || [segue.identifier isEqualToString:kSegue_BuildingToGallery]){
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(self.isPinching, self.currentBuildingIndex, CGRectZero, self.view.frame)];
    }
    if([segue.identifier isEqualToString:@"maxWidgetSegue"]==YES){
        REMBuildingImageViewController *controller = self.childViewControllers[self.currentBuildingIndex];
        
        REMDashboardController *dashboard=(REMDashboardController *)controller.childViewControllers[1];
        
        REMWidgetCollectionViewController *collection= dashboard.childViewControllers[dashboard.currentMaxDashboardIndex];
        
        
        REMWidgetMaxViewController *maxController = segue.destinationViewController;
        self.maxDashbaordController=dashboard;
        maxController.widgetCollectionController=collection;
        maxController.dashboardInfo=dashboard.buildingInfo.dashboardArray[dashboard.currentMaxDashboardIndex];
        
    }
}

- (IBAction)exitMaxWidget:(UIStoryboardSegue *)sender
{
    
}


- (IBAction)shareButtonPressed:(UIButton *)sender {
    //[self performSegueWithIdentifier:kSegue_BuildingToSharePopover sender:self];
    
    //REMBuildingShareViewController *shareController = [self.storyboard instantiateViewControllerWithIdentifier: @"sharePopover"];
    REMBuildingShareViewController *shareController=[[REMBuildingShareViewController alloc]init];
    shareController.contentSizeForViewInPopover = CGSizeMake(156, 88);
    
    if(self.sharePopoverController == nil){
        self.sharePopoverController = [[UIPopoverController alloc] initWithContentViewController:shareController];
        [self.sharePopoverController setPopoverContentSize:CGSizeMake(156, 88)];
        //[self.sharePopoverController setBackgroundColor:[UIColor clearColor]];
    }
    
    shareController.buildingController = self;
    
    //[self.sharePopoverController setDelegate:self];
    
    [self.sharePopoverController presentPopoverFromRect:CGRectMake(sender.frame.origin.x, sender.frame.origin.y+REMDMCOMPATIOS7(0), sender.frame.size.width,sender.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES ];
}


-(IBAction)backButtonPressed:(id)sender
{
    [self back];
}

-(void)back
{
    if ([self.fromController respondsToSelector:@selector(uncoverCell)]) {
        [(id)self.fromController uncoverCell];
    }
    
    [REMDataAccessor cancelAccess];
    
    //decide where to go
    NSString *segueIdentifier = [self.fromController class] == [REMGalleryViewController class] ? kSegue_BuildingToGallery : kSegue_BuildingToMap;
    
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}




- (void)exportImage:(void (^)(UIImage *, NSString*))callback
{
    REMBuildingImageViewController *viewController=self.childViewControllers[self.currentBuildingIndex];
    
    [viewController exportImage:callback];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



#pragma mark - IOS7 style
-(UIStatusBarStyle)preferredStatusBarStyle{
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return UIStatusBarStyleLightContent;
#else
    return UIStatusBarStyleDefault;
#endif
}

@end
