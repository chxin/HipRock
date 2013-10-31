//
//  REMBuildingViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 7/26/13.
//
//

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

@interface REMBuildingViewController ()
@property (nonatomic,strong) NSArray *imageArray;
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
    self.speedBase=1280;
	self.customImageLoadedDictionary = [[NSMutableDictionary alloc]initWithCapacity:self.buildingInfoArray.count];
    self.view.backgroundColor=[UIColor blackColor];
    self.currentScrollOffset=-kBuildingCommodityViewTop;
    
    
    [self addObserver:self forKeyPath:@"currentScrollOffset" options:0 context:nil];
    
//    if (self.currentBuilding != nil) {
//        for (int i=0; i<self.buildingInfoArray.count; ++i) {
//            REMBuildingOverallModel *model = self.buildingInfoArray[i];
//            if([model.building.buildingId isEqualToNumber:self.currentBuilding.building.buildingId]==YES){
//                self.currentIndex=i;
//                break;
//            }
//        }
//    }
//    else{
//        self.currentIndex=0;
//    }
    
    
    
    if(self.buildingInfoArray.count>0){
        
         [self blurredImageView];
        
        UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
        [self.view addGestureRecognizer:rec];
        rec.delegate = self;
        
        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis:)];
        [self.view addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchThis:)];
        [self.view addGestureRecognizer:pinch];
    }
    
    
    
    
    self.cumulateX=0;
    
    
    
}



-(void)dealloc{
    
    [self removeObserver:self forKeyPath:@"currentScrollOffset"];
    return;
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
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"buildingToMapSegue"]==YES){
//        REMMapViewController *mapController = segue.destinationViewController;
//        mapController.buildingInfoArray = self.buildingOverallArray;
//    }
    if([segue.identifier isEqualToString:kSegue_BuildingToMap] == YES){
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(NO, self.currentBuildingIndex, [((id)self.fromController) initialZoomRect], self.view.frame)];
    }
    if([segue.identifier isEqualToString:@"maxWidgetSegue"]==YES){
        REMImageView *view = self.imageArray[self.currentIndex];
        
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




- (void)blurredImageView
{
    NSString* defaultBuildingName = [[NSBundle mainBundle]pathForResource:@"DefaultBuilding" ofType:@"png"];
    self.defaultImage = [UIImage imageWithContentsOfFile:defaultBuildingName];
    //self.defaultImage = [UIImage imageWithContentsOfFile:@"DefaultBuilding"];
    //dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //UIImage *image = self.defaultImage;
    //dispatch_async(concurrentQueue, ^{
        UIImage *view = [REMImageHelper blurImage:self.defaultImage];
     //   dispatch_async(dispatch_get_main_queue(), ^{
            self.defaultBlurImage=view;
            [self initImageView];
     //   });
   // });
    
}

- (void)initImageView
{
    int i=0;
    self.imageViewStatus = [[NSMutableDictionary alloc]initWithCapacity:self.buildingInfoArray.count];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:self.buildingInfoArray.count];
    
    
    for (;i<self.buildingInfoArray.count;++i) {
        REMBuildingOverallModel *model = self.buildingInfoArray[i];
        REMImageView *imageView = [[REMImageView alloc]initWithFrame:CGRectMake((kImageWidth+kImageMargin)*i, 0, kImageWidth, kImageHeight) withBuildingOveralInfo:model ];
        imageView.defaultImage=self.defaultImage;
        imageView.defaultBlurImage=self.defaultBlurImage;
        imageView.controller=self;
        //if(i==self.currentIndex || i==(self.currentIndex+1) || i == (self.currentIndex-1)){
        
        [self.view addSubview:imageView];
        if(i==self.currentBuildingIndex || i==(self.currentBuildingIndex+1) || i == (self.currentBuildingIndex-1)){
            [imageView initWholeViewUseThumbnail:NO];
        }
        else{
            [imageView initWholeViewUseThumbnail:YES];
        }
        //    [self.imageViewStatus setObject:@(1) forKey:@(i)];
        //}
        //else{
        //    [self.imageViewStatus setObject:@(0) forKey:@(i)];
        //}
        [array addObject:imageView];
    }
    self.imageArray=array;
  
    //[self loadOtherImageView];
    
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
        f = f+(1024+5)*moveCount*-1;
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
    
    
    [self loadImageData];
    
    
}

- (void)loadOtherImageView{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //UIImage *image = self.defaultImage;
    dispatch_async(concurrentQueue, ^{
        for (int i=0; i<self.imageArray.count; ++i) {
            if(i!=self.currentBuildingIndex && i!=(self.currentBuildingIndex+1) && i != (self.currentBuildingIndex-1)){
                REMImageView *imageView=self.imageArray[i];
                [imageView initWholeViewUseThumbnail:NO];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    });

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
    
   // NSLog(@"state:%d",pan.state);
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (int i=0;i<self.imageArray.count;++i)
        {
            REMImageView *view = self.imageArray[i];
            if(self.currentBuildingIndex == 0 && self.cumulateX>0){
                [view moveCenter:trans.x/2];
            }
            else if((self.currentBuildingIndex==(self.imageArray.count-1)) && self.cumulateX<0){
                [view moveCenter:trans.x/2];
            }
            else{
                [view moveCenter:trans.x];
            }
        }
        
        self.cumulateX+=trans.x;
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled)
    {
        
         CGPoint p= [pan velocityInView:self.view];
        //NSLog(@"cumulatex:%f",self.cumulateX);
        
        int sign= p.x>0?1:-1;
        
        
         BOOL addIndex=YES;
        
        if((sign<0 && self.currentBuildingIndex==self.imageArray.count-1)
           || (sign>0 && self.currentBuildingIndex==0) ||
           (ABS(p.x)<100 && ABS(self.cumulateX)<512)){
            addIndex=NO;
        }
        else{
            [self.stopTimer invalidate];
            NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
            for (int i=0; i<self.imageArray.count; ++i) {
                NSNumber *num = self.originCenterXArray[i];
                float f = [num floatValue];
                f = f+sign*(1024+5);
                NSNumber *num1 = [NSNumber numberWithFloat:f];
                
                [ar addObject:num1];
            }
            
            self.originCenterXArray=ar;
            
            //NSLog(@"array:%@",ar);
        }
        self.cumulateX=0;
        if(addIndex == NO){
            [UIView animateWithDuration:0.4 delay:0
                                options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                    
                                    //NSLog(@"array:%@",self.originCenterXArray);
                                    for(int i=0;i<self.imageArray.count;++i)
                                    {
                                        NSNumber *s = self.originCenterXArray[i];
                                        CGFloat x= [s floatValue];
                                        REMImageView *image = self.imageArray[i];
                                        [image setCenter: CGPointMake( x,image.center.y)];
                                    }
                                } completion:^(BOOL finished){}];
            
        }
        else{
            
            
            
            self.currentBuildingIndex = self.currentBuildingIndex+sign*-1;

            
            self.delta=M_PI_4/128.0f;
            self.speed=self.speedBase*sign*self.delta;
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(switchCoverPage:) userInfo:nil repeats:YES];
            self.timer=timer;
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            
            
        }
        [pan setTranslation:CGPointZero inView:self.view];
        
        /*
        [UIView animateWithDuration:0.4 delay:0
                            options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                
                                //NSLog(@"array:%@",self.originCenterXArray);
                                for(int i=0;i<self.imageArray.count;++i)
                                {
                                    NSNumber *s = self.originCenterXArray[i];
                                    CGFloat x= [s floatValue];
                                    REMImageView *image = self.imageArray[i];
                                    [image setCenter: CGPointMake( x,image.center.y)];
                                }
                                
                                if(addIndex ==YES){
                                    self.currentIndex=self.currentIndex+sign*-1;
                                    self.currentBuildingId=((REMBuildingOverallModel *)self.buildingOverallArray[self.currentIndex]).building.buildingId;
                                }
                                //NSLog(@"currentIndex:%d",self.currentIndex);
                                
                                
                            } completion:^(BOOL ret){
                                if(addIndex == NO) return;
                                [self.imageArray[oldIndex] moveOutOfWindow];
                                [self loadImageData];
                                if(self.currentIndex<self.imageArray.count){
                                    NSNumber *willIndex= @(self.currentIndex-1*sign);
                                    NSNumber *status = self.imageViewStatus[willIndex];
                                    if([status isEqualToNumber:@(0)] ==YES){
                                        REMImageView *nextView= self.imageArray[willIndex.intValue];
                                        nextView.defaultImage=self.defaultImage;
                                        nextView.defaultBlurImage=self.defaultBlurImage;
                                        [self.view addSubview: nextView];
                                        [nextView setScrollOffset:self.currentScrollOffset];
                                        self.imageViewStatus[willIndex]=@(1);
                                        
                                    }
                                }
                                int idx = self.currentIndex;
                                
                                NSMutableArray *releaseArray=[[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
                                
                                for (int i=0; i<self.imageArray.count; i++) {
                                    if(i!=idx && i!=(idx+1) && i!=(idx-1)){
                                        [releaseArray addObject:@(i)];
                                    }
                                
                                }
                                [self releaseOutOfWindowView:releaseArray];
                                
                                
                                
                            }];
        
        [pan setTranslation:CGPointZero inView:self.view];
        */
        
    }
    
}

- (void) readyToComplete{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(stopCoverPage:) userInfo:nil repeats:NO];
    
    NSRunLoop *current=[NSRunLoop currentRunLoop];
    [current addTimer:timer forMode:NSDefaultRunLoopMode];
    self.stopTimer = timer;
}

- (void)stopCoverPage:(NSTimer *)timer{
    //NSLog(@"currentIndex:%d",self.currentIndex);
    REMImageView *imageView=self.imageArray[self.currentBuildingIndex];
    [imageView initWholeViewUseThumbnail:NO];
    [imageView setScrollOffset:self.currentScrollOffset];

    [imageView requireChartData];
    if(self.currentBuildingIndex<self.imageArray.count){
        CGFloat sign=self.speed<0?-1:1;
        NSNumber *willIndex= @(self.currentBuildingIndex-1*sign);
        if(willIndex.intValue>=self.imageArray.count || willIndex.intValue<0){
            return;
        }
        REMImageView *nextView= self.imageArray[willIndex.intValue];
        nextView.defaultImage=self.defaultImage;
        nextView.defaultBlurImage=self.defaultBlurImage;
        [nextView initWholeViewUseThumbnail:NO];
        [nextView setScrollOffset:self.currentScrollOffset];
        
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
    
    for(int i=0;i<self.imageArray.count;++i)
    {
        NSNumber *s = self.originCenterXArray[i];
        CGFloat x= [s floatValue];
        REMImageView *image = self.imageArray[i];
        //NSLog(@"image:%@",NSStringFromCGRect(image.frame));
        CGFloat readyDis=image.center.x+distance;
        
        if((distance < 0 &&readyDis<x) || (distance>0 && readyDis>x)){
            self.speed=sign*0.01;
            readyDis=x;
        }
        
        [image setCenter: CGPointMake( readyDis,image.center.y)];
    }
    
    
    
}

- (void)releaseOutOfWindowView:(NSArray *)releaseViews{
    //NSLog(@"release views:%@",releaseViews);
    @autoreleasepool {
        for (NSNumber *num in releaseViews) {
            REMImageView *image= self.imageArray[[num intValue]];
            if([self.imageViewStatus[num] isEqual:@(1)]== YES){
                [image removeFromSuperview];
                self.imageViewStatus[num]=@(0);
            }
        }
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


- (void)panthis:(UIPanGestureRecognizer *)pan
{
    [self swipethis:pan];
}



-(void)tapthis:(UITapGestureRecognizer *)tap
{
    //NSLog(@"cumulatex:%f",self.cumulateX);
    if(self.cumulateX!=0) return;
    
    for (REMImageView *view in self.imageArray) {
        [view tapthis];
    }
}



-(void)pinchThis:(UIPinchGestureRecognizer *)pinch
{
    if(pinch.state  == UIGestureRecognizerStateBegan){
        NSLog(@"pinch: Began");
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
        
        NSLog(@"pinch: Changed, scale: %f, point: %@", pinch.scale, NSStringFromCGPoint(point));
        
    }
    
    if(pinch.state  == UIGestureRecognizerStateEnded || pinch.state  == UIGestureRecognizerStateCancelled || pinch.state  == UIGestureRecognizerStateFailed){
        NSLog(@"pinch: Ended, state: %d, touch numbers: %d", pinch.state, pinch.numberOfTouches);
        
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
            CGRect initialiZoomRect = [((id)self.fromController) initialZoomRect];
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
- (IBAction)dashboardButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"buildingToDashboardSegue" sender:self];
}

- (IBAction)shareButtonPressed:(id)sender {
    REMMaskManager *masker = [[REMMaskManager alloc]initWithContainer:[UIApplication sharedApplication].keyWindow];
    
    [masker showMask];
    
    //REMImageView *v= self.imageArray[self.currentIndex];
    //[v prepareShare];
    
    [self performSelector:@selector(executeExport:) withObject:masker afterDelay:0.1];
}

-(IBAction)backButtonPressed:(id)sender
{
    REMBuildingEntranceSegue *segue = [[REMBuildingEntranceSegue alloc] initWithIdentifier:kSegue_BuildingToMap source:self destination:self.fromController];
    
    [self prepareForSegue:segue sender:self];
    [segue perform];
}

-(void)executeExport:(REMMaskManager *)masker{
    REMImageView *view = self.imageArray[self.currentBuildingIndex];
    
    [view exportImage:^(UIImage *image, NSString* text){
        [masker hideMask];
        
        REMBuildingWeiboView* weiboView = [[REMBuildingWeiboView alloc]initWithSuperView:self.view text:text image:image];
//        [weiboView setWeiboText: text];
//        [weiboView setWeiboImage:image];
        [weiboView show:YES];
//        
//        REMBuildingWeiboSendViewController* vc = [[REMBuildingWeiboSendViewController alloc]init];
//        [vc setWeiboText: text];
//        [vc setWeiboImage:image];
//        [self performSegueWithIdentifier:@"sendWeiboSegue" sender: @{@"image": image, @"text": text}];
        
        
//        UINavigationController *modalViewNavController =
//        [[UINavigationController alloc]
//         initWithRootViewController:vc];
//        modalViewNavController.toolbarHidden = YES;
//        modalViewNavController.navigationBarHidden = YES;
//        modalViewNavController.view.backgroundColor = [UIColor clearColor];
//        modalViewNavController.view.superview.alpha = 0.1;
//        self.modalPresentationStyle = UIModalPresentationCurrentContext;
//        self presentViewController:vc animated:<#(BOOL)#> completion:<#^(void)completion#>
////        modalViewNavController.view.alpha = 0.1;
//        [self.navigationController presentViewController:modalViewNavController animated:YES completion:Nil];
        
    }];
}

@end
