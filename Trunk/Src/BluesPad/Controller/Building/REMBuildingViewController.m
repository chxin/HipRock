//
//  REMBuildingViewController.m
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import "REMBuildingViewController.h"
#import "REMApplicationContext.h"
#import "WeiboSDK.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingWeiboView.h"
#import "REMTrendChart.h"

@interface REMBuildingViewController ()
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,strong) NSArray *originCenterXArray;
@property (nonatomic) CGFloat cumulateX;

@property (nonatomic,strong) NSMutableDictionary *imageViewStatus;


@property (nonatomic,strong) UIImage *defaultImage;
@property (nonatomic,strong) UIImage *defaultBlurImage;


@property (nonatomic,strong) NSMutableDictionary *customImageLoadedDictionary;
@end



@implementation REMBuildingViewController

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
	self.customImageLoadedDictionary = [[NSMutableDictionary alloc]initWithCapacity:self.buildingOverallArray.count];
    self.view.backgroundColor=[UIColor blackColor];
    self.currentScrollOffset=-kBuildingCommodityViewTop;
    
    [self addObserver:self forKeyPath:@"currentScrollOffset" options:0 context:nil];
    
    if(self.buildingOverallArray.count>0){
    
        [self blurredImageView];
        
        
        UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
        [self.view addGestureRecognizer:rec];
        rec.delegate = self;
        
        UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis:)];
        [self.view addGestureRecognizer:tap];
    }
    
    self.currentIndex=0;
    self.cumulateX=0;
    
    
    
}



-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentScrollOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentScrollOffset"] == YES){
        for (int i=0; i<self.imageArray.count; ++i) {
            if(i!= self.currentIndex){
                if([[self.imageViewStatus objectForKey:@(i)] isEqualToNumber:@(1)] == YES){
                    REMImageView *view=self.imageArray[i];
                    [view setScrollOffset:self.currentScrollOffset];
                }
            }
        }
    }
}

- (void)notifyCustomImageLoaded:(NSNumber *)buildingId{
    return;
    if(self.customImageLoadedDictionary.count==self.imageArray.count)return;
    if ([self.customImageLoadedDictionary objectForKey:buildingId]!=nil) {
        return;
    }
    else{
        [self.customImageLoadedDictionary setObject:@(1) forKey:buildingId];
        if(self.customImageLoadedDictionary.count==self.imageArray.count){
            self.defaultImage=nil;
            self.defaultBlurImage=nil;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ==YES ){
        if(self.imageArray.count<1)return YES;
        REMImageView *current = self.imageArray[self.currentIndex];
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


- (void)settingButtonPressed:(UIButton *)button{
    [self performSegueWithIdentifier:@"buildingSettingSegue2" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"buildingSettingSegue2"]==YES){
        UINavigationController *c=  segue.destinationViewController;
        REMBuildingSettingViewController *vc= [c.childViewControllers lastObject];
        vc.splashScreenController=self.splashScreenController;
        vc.navigationController=self.navigationController;
    }
}


- (void)blurredImageView
{
    
    self.defaultImage = [UIImage imageNamed:@"DefaultBuilding"];
    //self.defaultImage = [UIImage imageWithContentsOfFile:@"DefaultBuilding"];
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //UIImage *image = self.defaultImage;
    dispatch_async(concurrentQueue, ^{
        UIImage *view = [REMImageHelper blurImage:self.defaultImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.defaultBlurImage=view;
            [self initImageView];
        });
    });
    
}

- (void)initImageView
{
    REMTrendChartConfig* chartConfig = [[REMTrendChartConfig alloc]init];
    //    chartConfig.xAxisConfig = [[REMTrendChartAxisConfig alloc]init];
    chartConfig.xAxisConfig = [REMTrendChartAxisConfig getWidgetXConfig];
    chartConfig.yAxisConfig = [NSArray arrayWithObjects:[REMTrendChartAxisConfig getWidgetYConfig],nil];
    chartConfig.verticalGridLine = NO;
    chartConfig.horizentalGridLineAmount = 4;
    chartConfig.horizentalReservedSpace = 20;
    
    REMTrendChartView* testV = [[REMTrendChartView alloc]initWithFrame:CGRectMake(0, 0, 500, 400) chartConfig:chartConfig];
    
    int i=0;
    self.imageViewStatus = [[NSMutableDictionary alloc]initWithCapacity:self.buildingOverallArray.count];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:self.buildingOverallArray.count];
    
    
    for (;i<self.buildingOverallArray.count;++i) {
        REMBuildingOverallModel *model = self.buildingOverallArray[i];
        REMImageView *imageView = [[REMImageView alloc]initWithFrame:CGRectMake((kImageWidth+kImageMargin)*i, 0, kImageWidth, kImageHeight) withBuildingOveralInfo:model ];
        imageView.defaultImage=self.defaultImage;
        imageView.defaultBlurImage=self.defaultBlurImage;
        imageView.controller=self;
        if(i==0 || i==1){
            [self.view addSubview:imageView];
            [self.imageViewStatus setObject:@(1) forKey:@(i)];
        }
        else{
            [self.imageViewStatus setObject:@(0) forKey:@(i)];
        }
        [array addObject:imageView];
    }
    self.imageArray=array;
  
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:self.imageArray.count];
    
    for (i=0;i<self.imageArray.count;++i) {
        REMImageView *view = self.imageArray[i];
        NSNumber *num = [NSNumber numberWithFloat:view.center.x];
        [arr addObject:num];
    }
    
    self.originCenterXArray=arr;
    
    [self loadImageData];
    

    
    [self.view addSubview:testV]; 
}


#pragma mark -
#pragma mark buildingview

- (void)loadImageData{
    REMImageView *image = self.imageArray[self.currentIndex];
    [image requireChartData];
}

- (void) swipethis:(UIPanGestureRecognizer *)pan
{

    CGPoint trans= [pan translationInView:self.view];
    
   // NSLog(@"state:%d",pan.state);
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (int i=0;i<self.imageArray.count;++i)
        {
            REMImageView *view = self.imageArray[i];
            if(self.currentIndex == 0 && self.cumulateX>0){
                [view moveCenter:trans.x/2];
            }
            else if((self.currentIndex==(self.imageArray.count-1)) && self.cumulateX<0){
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
        
        __block CGPoint p= [pan velocityInView:self.view];
        //NSLog(@"cumulatex:%f",self.cumulateX);
        
       __block int sign= p.x>0?1:-1;
        
        
        __block BOOL addIndex=YES;
        __block NSUInteger oldIndex=self.currentIndex;
        
        if((sign<0 && self.currentIndex==self.imageArray.count-1)
           || (sign>0 && self.currentIndex==0) ||
           (ABS(p.x)<100 && ABS(self.cumulateX)<512)){
            addIndex=NO;
        }
        else{
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
                                }
                                //NSLog(@"currentIndex:%d",self.currentIndex);
                                self.cumulateX=0;
                                
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
                                /*
                                if((idx - 2) >=0){
                                    int i=0;
                                    while (i<=(idx-2)) {
                                        [releaseArray addObject:@(i)];
                                        i++;
                                    }
                                    i=idx+1;
                                    while(i<self.imageArray.count){
                                        [releaseArray addObject:@(i)];
                                        ++i;
                                    }
                                    [self releaseOutOfWindowView:releaseArray];
                                }
                                else if((idx+2)<=self.imageArray.count){
                                    int i=self.imageArray.count-1;
                                    while (i>=(idx+2)) {
                                        [releaseArray addObject:@(i)];
                                        i--;
                                    }
                                    [self releaseOutOfWindowView:releaseArray];
                                }*/
                                for (int i=0; i<self.imageArray.count; i++) {
                                    if(i!=idx && i!=(idx+1) && i!=(idx-1)){
                                        [releaseArray addObject:@(i)];
                                    }
                                
                                }
                                [self releaseOutOfWindowView:releaseArray];
                                
                                
                                
                            }];
        
        [pan setTranslation:CGPointZero inView:self.view];
        
        
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

-(void)executeExport:(REMMaskManager *)masker{
    REMImageView *view = self.imageArray[self.currentIndex];
    
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
