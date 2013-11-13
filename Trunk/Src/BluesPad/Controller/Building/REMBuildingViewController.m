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


const static CGFloat buildingGap=10;

@interface REMBuildingViewController ()
//@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,strong) NSArray *originCenterXArray;
@property (nonatomic) CGFloat cumulateX;

@property (nonatomic,strong) NSMutableDictionary *imageViewStatus;


@property (nonatomic,strong) UIImage *defaultImage;
@property (nonatomic,strong) UIImage *defaultBlurImage;


@property (nonatomic,strong) NSMutableDictionary *customImageLoadedDictionary;

@property (nonatomic,strong) UIImageView *snapshot;

@property (nonatomic) CGFloat speed;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) NSTimer *stopTimer;

@property (nonatomic) CGFloat delta;

@property (nonatomic) CGFloat speedBase;


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
    self.speedBase=2000;
	self.customImageLoadedDictionary = [[NSMutableDictionary alloc]initWithCapacity:self.buildingInfoArray.count];
    self.view.backgroundColor=[UIColor blackColor];
    [self.view setFrame:CGRectMake(0, 0, kImageWidth, kImageHeight)];
    self.currentScrollOffset=-kBuildingCommodityViewTop;
    
    self.cumulateX=0;
    
    [self addObserver:self forKeyPath:@"currentScrollOffset" options:0 context:nil];
    
    
    if(self.buildingInfoArray.count>0){
        
        [self initDefaultImageView];
        
        UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipethis:)];
        [self.view addGestureRecognizer:rec];
        rec.delegate = self;
        
        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis:)];
        [self.view addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchThis:)];
        [self.view addGestureRecognizer:pinch];
    }
    
}



-(void)dealloc{
    
    [self removeObserver:self forKeyPath:@"currentScrollOffset"];
    for (REMImageView *view in self.imageArray) {
        [view removeFromSuperview];
    }
    self.imageArray=nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScrollOffset"] == YES){
        for (int i=0; i<self.imageArray.count; ++i) {
            if(i!= self.currentBuildingIndex){
                if([[self.imageViewStatus objectForKey:@(i)] isEqualToNumber:@(1)] == YES){
                    REMImageView *view=self.imageArray[i];
                    [view setScrollOffset:self.currentScrollOffset];
                }
            }
        }
    }
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ==YES ){
        if(self.imageArray.count<1)return YES;
        REMImageView *current = self.imageArray[self.currentBuildingIndex];
        return [current shouldResponseSwipe:touch];
            
        
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]==YES){
        return YES;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning :%@",[self class]);
    // Dispose of any resources that can be recreated.
}

- (void)initDefaultImageView
{
    NSString* defaultBuildingName = [[NSBundle mainBundle]pathForResource:@"DefaultBuilding" ofType:@"png"];
    self.defaultImage = [UIImage imageWithContentsOfFile:defaultBuildingName];
    UIImage *view = [REMImageHelper blurImage:self.defaultImage];
    self.defaultBlurImage=view;
    
    
    int i=0;
    //self.imageViewStatus = [[NSMutableDictionary alloc]initWithCapacity:self.buildingInfoArray.count];
    //NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:self.buildingInfoArray.count];
    
    //NSLog(@"ns nav:%@",NSStringFromCGRect(self.navigationController.view.frame));
    for (;i<self.buildingInfoArray.count;++i) {
        REMBuildingOverallModel *model = self.buildingInfoArray[i];
        
        REMBuildingImageViewController *subController=[[REMBuildingImageViewController alloc] init];
        subController.buildingInfo=model;
        subController.defaultImage=self.defaultImage;
        subController.defaultBlurImage=self.defaultBlurImage;
        
        subController.viewFrame=CGRectMake(i*(kImageWidth+buildingGap), self.view.frame.origin.y,kImageWidth,kImageHeight);
        
        //NSLog(@"subcontroller:%@",NSStringFromCGRect(subController.viewFrame));
        
        
        [self addChildViewController:subController];
        
        [self.view addSubview:subController.view];
        
        /*
        REMImageView *imageView = [[REMImageView alloc]initWithFrame:CGRectMake((kImageWidth+imageGap)*i, 0, kImageWidth, kImageHeight) withBuildingOveralInfo:model ];
        
        
        
        imageView.defaultImage=self.defaultImage;
        imageView.defaultBlurImage=self.defaultBlurImage;
        imageView.controller=self;
        
        [self.view addSubview:imageView];
        if(i==self.currentBuildingIndex || i==(self.currentBuildingIndex+1) || i == (self.currentBuildingIndex-1)){
            [imageView initWholeViewUseThumbnail:NO];
        }
        else{
            [imageView initWholeViewUseThumbnail:YES];
        }
        
        [array addObject:imageView];
         */
    }
    /*
    self.imageArray=array;
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:self.imageArray.count];
    
    for (i=0;i<self.imageArray.count;++i) {
        REMImageView *view = self.imageArray[i];
        NSNumber *num = [NSNumber numberWithFloat:view.center.x];
        [arr addObject:num];
    }
    
    
    
    int moveCount=self.currentBuildingIndex;
    
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
    for (int i=0; i<arr.count; ++i) {
        NSNumber *num = arr[i];
        float f = [num floatValue];
        f = f+(1024+imageGap)*moveCount*-1;
        NSNumber *num1 = [NSNumber numberWithFloat:f];
        [ar addObject:num1];
    }
    
    self.originCenterXArray=ar;
    
    for(int i=0;i<self.imageArray.count;++i)
    {
        NSNumber *s = self.originCenterXArray[i];
        CGFloat x= [s floatValue];
        REMImageView *image = self.imageArray[i];
        [image setCenter: CGPointMake( x,image.center.y)];
    }
    
    
    [self loadImageData];*/
    
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

- (void)loadImageData{
    REMImageView *image = self.imageArray[self.currentBuildingIndex];
    [image requireChartData];
}

- (void) swipethis:(UIPanGestureRecognizer *)pan
{

    if(self.timer!=nil){
        [self.timer invalidate];
        [self readyToComplete];
    }
    
    CGPoint trans= [pan translationInView:self.view];
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (int i=0;i<self.childViewControllers.count;++i)
        {
            UIViewController *controller=self.childViewControllers[i];
            CGFloat x;
            if(self.currentBuildingIndex == 0 && self.cumulateX>0){
                x=trans.x/2;
            }
            else if((self.currentBuildingIndex==(self.childViewControllers.count-1)) && self.cumulateX<0){
                x=trans.x/2;
            }
            else{
                x=trans.x;
            }
            
            [controller.view setCenter:CGPointMake(controller.view.center.x+trans.x, controller.view.center.y)];
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
                                } completion:^(BOOL finished){}];
            
        }
        else{
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
                self.delta=M_PI_4/128.0f;
                self.speed=self.speedBase*sign*self.delta;
                
                NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(switchCoverPage:) userInfo:nil repeats:YES];
                self.timer=timer;
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }
            
        }
        
    }
    [pan setTranslation:CGPointZero inView:self.view];
}

- (void) moveAllViews{
    for (int i=0; i<self.childViewControllers.count; ++i) {
        UIViewController *vc = self.childViewControllers[i];
        NSInteger gap=i-self.currentBuildingIndex;
        [vc.view setCenter:CGPointMake(gap*(self.view.frame.size.width+buildingGap)+self.view.frame.size.width/2, vc.view.center.y)];
    }
}

- (void) readyToComplete{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(stopCoverPage:) userInfo:nil repeats:NO];
    
    NSRunLoop *current=[NSRunLoop currentRunLoop];
    [current addTimer:timer forMode:NSDefaultRunLoopMode];
    self.stopTimer = timer;
}

- (void)stopCoverPage:(NSTimer *)timer{
    REMBuildingImageViewController *vc=self.childViewControllers[self.currentBuildingIndex];
    [vc loadContentView];
    return;
    if(self.currentBuildingIndex<self.childViewControllers.count){
        CGFloat sign=self.speed<0?-1:1;
        NSNumber *willIndex= @(self.currentBuildingIndex-1*sign);
        if(willIndex.intValue>=self.childViewControllers.count || willIndex.intValue<0){
            return;
        }
        REMBuildingImageViewController *nextController= self.childViewControllers[willIndex.intValue];
        [nextController loadContentView];
        //[nextView initWholeViewUseThumbnail:NO];
        //[nextView setScrollOffset:self.currentScrollOffset];
        
    }

}



- (void)switchCoverPage:(NSTimer *)timer{
    
    if (ABS(self.speed)<0.1) {
        [timer invalidate];
        [self readyToComplete];
        return;
    }
    
    CGFloat sign=self.speed<0?-1:1;
    CGFloat distance=self.speed;
    
    self.delta+=M_PI_4/128.0f;
    if(self.delta>M_PI)self.delta=M_PI;
    
    self.speed=self.speedBase*sin(self.delta)*sign;
    
    for(int i=0;i<self.childViewControllers.count;++i)
    {
        REMBuildingImageViewController *vc=self.childViewControllers[i];
        UIView *v=vc.view;
        CGFloat readyDis=v.center.x+distance;
        CGFloat gap=i-(int)self.currentBuildingIndex;
        CGFloat page=self.view.frame.size.width+buildingGap;
        CGFloat x=gap*page+self.view.frame.size.width/2;
        if((distance < 0 &&readyDis<x) || (distance>0 && readyDis>x)){
            self.speed=sign*0.01;
            readyDis=x;
        }
        
        [v setCenter: CGPointMake(readyDis,v.center.y)];
    }
    
}


- (void)switchToDashboard
{
    for (REMImageView *view in self.imageArray) {
        [view showDashboard];
    }
}

- (void)switchToBuildingInfo{
    for (REMImageView *view in self.imageArray) {
        [view showBuildingInfo];
    }
}

/*
-(void)tapthis:(UITapGestureRecognizer *)tap
{
    //NSLog(@"cumulatex:%f",self.cumulateX);
    if(self.cumulateX!=0) return;
    
    for (REMImageView *view in self.imageArray) {
        [view tapthis];
    }
}
*/


-(void)pinchThis:(UIPinchGestureRecognizer *)pinch
{
    if(pinch.state  == UIGestureRecognizerStateBegan){
        //NSLog(@"pinch: Began");
        UIImageView *fromViewSnapshot = [((id)self.fromController) snapshot];
        
        self.snapshot = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:self.view]];
        [self.view addSubview:fromViewSnapshot];
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
        
        UIImageView *fromViewSnapshot = [((id)self.fromController) snapshot];
        if(pinch.scale >= 1){ //scale did not change,
            CGPoint point = [pinch locationInView:self.view];
            
            if(point.x != self.view.center.x || point.y != self.view.center.y){ //but position changed
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.snapshot.center = self.view.center;
                } completion:^(BOOL finished) {
                    [fromViewSnapshot removeFromSuperview];
                    
                    [self.snapshot removeFromSuperview];
                    self.snapshot = nil;
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
                [fromViewSnapshot removeFromSuperview];
                
                [self.snapshot removeFromSuperview];
                self.snapshot = nil;
                
                [self.navigationController popViewControllerAnimated:NO];
            }];
        }
        
    }
}

#pragma mark -
#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kSegue_BuildingToMap] || [segue.identifier isEqualToString:kSegue_BuildingToGallery]){
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(NO, self.currentBuildingIndex, CGRectZero, self.view.frame)];
    }
    if([segue.identifier isEqualToString:@"maxWidgetSegue"]==YES){
        REMImageView *view = self.imageArray[self.currentBuildingIndex];
        
        REMDashboardController *dashboard=view.dashboardController;
        
        REMWidgetCollectionViewController *collection= dashboard.childViewControllers[dashboard.currentMaxDashboardIndex];
        
        
        REMWidgetMaxViewController *maxController = segue.destinationViewController;
        self.maxDashbaordController=dashboard;
        maxController.widgetCollectionController=collection;
        maxController.dashboardInfo=dashboard.dashboardArray[dashboard.currentMaxDashboardIndex];
        
    }
}

- (IBAction)exitMaxWidget:(UIStoryboardSegue *)sender
{
    
}


- (IBAction)dashboardButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"buildingToDashboardSegue" sender:self];
}

- (IBAction)shareButtonPressed:(id)sender {
    //[self performSegueWithIdentifier:kSegue_BuildingToSharePopover sender:self];
    
    REMBuildingShareViewController *shareController = [self.storyboard instantiateViewControllerWithIdentifier: @"sharePopover"];
    
    shareController.contentSizeForViewInPopover = CGSizeMake(156, 88);
    
    if(self.sharePopoverController == nil){
        self.sharePopoverController = [[UIPopoverController alloc] initWithContentViewController:shareController];
    }
    
    shareController.buildingController = self;
    
    [self.sharePopoverController setDelegate:self];
    [self.sharePopoverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES ];
}


-(IBAction)backButtonPressed:(id)sender
{
    //decide where to go
    NSString *segueIdentifier = [self.fromController class] == [REMGalleryViewController class] ? kSegue_BuildingToGallery : kSegue_BuildingToMap;
    
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

-(void)shareViaWeibo
{
    REMMaskManager *masker = [[REMMaskManager alloc]initWithContainer:[UIApplication sharedApplication].keyWindow];
    
    [masker showMask];
    
    [self performSelector:@selector(executeExport:) withObject:masker afterDelay:0.1];
}

-(void)executeWeiboExport:(REMMaskManager *)masker{
    REMImageView *view = self.imageArray[self.currentBuildingIndex];
    
    [view exportImage:^(UIImage *image, NSString* text){
        [masker hideMask];
        
        REMBuildingWeiboView* weiboView = [[REMBuildingWeiboView alloc]initWithSuperView:self.view text:text image:image];

        [weiboView show:YES];

    }];
}



@end
