/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMaxViewController.m
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetMaxViewController.h"
#import "REMWidgetDetailViewController.h"
#import "REMWidgetCellViewController.h"
#import "REMScreenEdgetGestureRecognizer.h"
#import "REMDimensions.h"

const static CGFloat widgetGap=20;


@interface REMWidgetMaxViewController()

@property (nonatomic) CGFloat cumulateX;


@property (nonatomic,weak) NSTimer *stopTimer;


@property (nonatomic,weak) UIView *bloodView;
@property (nonatomic,weak) UIView *bloodWhiteView;
@property (nonatomic,weak) UIImageView *srcBg;
@property (nonatomic) CGRect origSrcBgFrame;

@property (nonatomic) BOOL readyToClose;

@property (nonatomic,weak) UIView *glassView;

/*
@property (nonatomic,strong) REMWidgetMaxDiagramViewController *chartController;
@property (nonatomic,strong) NSArray *currentStepList;
*/
@end

@implementation REMWidgetMaxViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveTestNotification:)
                                                     name:@"BizChanged"
                                                   object:nil];
    }
    
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BizChanged" object:nil];
}


- (void) receiveTestNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"BizChanged"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BizDetailChanged" object:notification.object userInfo:notification.userInfo];
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // iOS 7.0 supported
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    
    
    [self.view setFrame:CGRectMake(0, 0, kDMScreenWidth, REMDMCOMPATIOS7(kDMScreenHeight-kDMStatusBarHeight))];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.cumulateX=0;
    self.readyToClose=NO;
    [self addDashboardBg];
    for (int i=0; i<self.dashboardInfo.widgets.count; ++i) {
        REMWidgetObject *obj=self.dashboardInfo.widgets[i];
        
        REMWidgetDetailViewController *sub=[[REMWidgetDetailViewController alloc]init];
        sub.widgetInfo=obj;
        REMWidgetCellViewController *cellController= self.widgetCollectionController.childViewControllers[i];
        sub.energyData=cellController.chartData;
        
        
        [self addChildViewController:sub];
        
        UIView *view = sub.view;
        [view setFrame:CGRectMake(i*self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        
        NSInteger gap=i-self.currentWidgetIndex;
        [sub.view setCenter:CGPointMake(gap*(self.view.frame.size.width+widgetGap)+self.view.frame.size.width/2, self.view.center.y)];
        
        [self.view addSubview:sub.view];
        
        if(i==self.currentWidgetIndex || i==(self.currentWidgetIndex-1) || i == (self.currentWidgetIndex+1)){
            [sub showChart];
        }
    }
    
    //[self addBloodCell];
//    if(__IPHONE_7_0 == YES){
//        UIScreenEdgePanGestureRecognizer *rec=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
//        rec.edges=UIRectEdgeLeft;
//        [self.view addGestureRecognizer:rec];
//        UIScreenEdgePanGestureRecognizer *rec1=[[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
//        rec1.edges=UIRectEdgeRight;
//        [self.view addGestureRecognizer:rec1];
//    }
//    else{
        REMScreenEdgetGestureRecognizer *rec=[[REMScreenEdgetGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
        [self.view addGestureRecognizer:rec];
//    }
    
}



- (void) addBloodCell{
    NSBundle* mb = [NSBundle mainBundle];
    UIImageView *whiteView= [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[mb pathForResource:@"Oil_normal" ofType:@"png"]]];
    //whiteView.clipsToBounds = YES;
    CGFloat bloodCellX=self.view.frame.size.width-45-30;
    CGFloat bloodCellY=self.view.frame.size.height/2+whiteView.frame.size.height/2;
    [whiteView setFrame:CGRectMake(bloodCellX, bloodCellY, 45,45)];
    UIImageView* greenView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[mb pathForResource:@"Oil_pressed" ofType:@"png"]]];
    greenView.clipsToBounds=YES;
    greenView.contentMode=UIViewContentModeBottomRight;
    
    [greenView setFrame:CGRectMake(whiteView.frame.origin.x+whiteView.frame.size.width, whiteView.frame.origin.y, 0, whiteView.frame.size.height)];
    
    whiteView.backgroundColor=[UIColor clearColor];
    greenView.backgroundColor=[UIColor clearColor];
    UIViewController *vc= self.childViewControllers[0];
    [self.view insertSubview:greenView belowSubview:vc.view];
    [self.view insertSubview:whiteView belowSubview:greenView];
    self.bloodView=greenView;
    self.bloodWhiteView=whiteView;
    [self.bloodWhiteView setHidden:YES];
    [self.bloodView setHidden:YES];
    
    //NSLog(@"blood white view:%@",NSStringFromCGRect(self.bloodWhiteView.frame));
    
}

- (void) addDashboardBg{
    REMDashboardController *srcController=(REMDashboardController *) self.widgetCollectionController.parentViewController;
    REMBuildingImageViewController *imageController=(REMBuildingImageViewController *)srcController.parentViewController;

    UIImage *image=[REMImageHelper imageWithView:imageController.view];
    UIImageView *view = [[UIImageView alloc]initWithImage:image];
    [view setFrame:self.view.frame];
    [view setFrame:CGRectMake(200, 200, view.frame.size.width-400, view.frame.size.height-400)];
    self.origSrcBgFrame=view.frame;
    
    [self.view addSubview:view];
    self.srcBg=view;
    [self.srcBg setHidden:YES];
    
    UIView *glassView = [[UIView alloc]initWithFrame:self.view.frame];
    glassView.alpha=0;
    glassView.contentMode=UIViewContentModeScaleToFill;
    glassView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    [self.view addSubview:glassView];
    
    self.glassView=glassView;
}


- (void) readyToComplete{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(stopCoverPage:) userInfo:nil repeats:NO];
    
    NSRunLoop *current=[NSRunLoop currentRunLoop];
    [current addTimer:timer forMode:NSDefaultRunLoopMode];
    self.stopTimer = timer;
}

- (void) moveAllViews{
    for (int i=0; i<self.childViewControllers.count; ++i) {
        REMWidgetDetailViewController *vc = self.childViewControllers[i];
        NSInteger gap=i-self.currentWidgetIndex;
        [vc.view setCenter:CGPointMake(gap*(self.view.frame.size.width+widgetGap)+self.view.frame.size.width/2, vc.view.center.y)];
        //NSLog(@"view center:%@",NSStringFromCGRect(vc.view.frame));
        
    }
}

- (void)cancelAllRequest{
    for (REMWidgetObject *widget in self.dashboardInfo.widgets) {
        [REMDataAccessor cancelAccess:[NSString stringWithFormat:@"widget-%@",widget.widgetId]];
    }
}

- (void)panthis:(UIPanGestureRecognizer *)pan{
    
    //[self cancelAllRequest];
    
    
    
    CGPoint trans= [pan translationInView:self.view];
    
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (int i=0;i<self.childViewControllers.count;++i)
        {
            REMWidgetDetailViewController *vc = self.childViewControllers[i];
            if((self.currentWidgetIndex == 0 && self.cumulateX>0 ) ||
               ((self.currentWidgetIndex==(self.dashboardInfo.widgets.count-1)) && self.cumulateX<0)){
                //NSLog(@"src bg:%@",NSStringFromCGRect(self.srcBg.frame));
                [self.srcBg setHidden:NO];
                if(ABS(self.cumulateX)<300 && self.srcBg.frame.origin.x>=0){
                    CGFloat rate=200.0f/160.0f;
                    CGFloat delta=self.cumulateX*rate;
                    if (self.currentWidgetIndex!=0) {
                        delta*=-1;
                    }
                    CGFloat x=self.origSrcBgFrame.origin.x- delta;
                    if(x<0){
                        [self.srcBg setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    }
                    else{
                        [self.srcBg setFrame:CGRectMake(x, self.origSrcBgFrame.origin.y- delta, self.origSrcBgFrame.size.width+ 2*delta, self.origSrcBgFrame.size.height+ 2*delta)];
                        CGFloat blurLevel=0.8*ABS(self.cumulateX)/160.0f;
                        self.glassView.alpha=MAX(0,MIN(blurLevel,0.8));
                    }
                    //[self.bloodWhiteView setHidden:YES];
                    //[self.bloodView setHidden:YES];
                }
                //NSLog(@"bg frame:%@",NSStringFromCGRect(self.srcBg.frame));
                if(self.srcBg.frame.origin.x>0){
                    
                    self.readyToClose=NO;
                }
                else{
                    self.readyToClose=YES;
                }
                
            }/*
            else if((self.currentWidgetIndex==(self.dashboardInfo.widgets.count-1)) && self.cumulateX<0){
                //[self.bloodView setHidden:NO];
                //[self.bloodWhiteView setHidden:NO];
                if(ABS(self.cumulateX)<160 && self.bloodView.frame.size.width<=self.bloodWhiteView.frame.size.width){
                    [self.bloodView setFrame:CGRectMake(self.bloodWhiteView.frame.origin.x+self.bloodWhiteView.frame.size.width+self.cumulateX/3,self.bloodWhiteView.frame.origin.y, -self.cumulateX/3, self.bloodWhiteView.frame.size.height)];
                    [self.srcBg setHidden:YES];
                }
                else{
                    self.bloodView.frame=self.bloodWhiteView.frame;
                }
                if (self.bloodView.frame.origin.x>self.bloodWhiteView.frame.origin.x) {
                    self.readyToClose=NO;
                    //NSLog(@"blood view:%@",NSStringFromCGRect(self.bloodView.frame));
                }
                else{
                    
                    self.readyToClose=YES;
                }
                

            }*/
            else{
                //[self.bloodView setHidden:YES];
                //[self.bloodWhiteView setHidden:YES];
                [self.srcBg setHidden:YES];
            }
            [vc.view setCenter:CGPointMake(vc.view.center.x+trans.x, vc.view.center.y)];
            
        }
        
        self.cumulateX+=trans.x;
        //NSLog(@"cumulate x:%f",self.cumulateX);
    }
    
    if(pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled)
    {
        if(self.readyToClose==YES){
            [self popToBuildingCover];
            return;
        }
        
        CGPoint p= [pan velocityInView:self.view];
        
        int sign= p.x>0?1:-1;
        
        
        BOOL addIndex=YES;
        
        if((sign<0 && self.currentWidgetIndex==self.dashboardInfo.widgets.count-1)
           || (sign>0 && self.currentWidgetIndex==0) ||
           (ABS(p.x)<200 && ABS(self.cumulateX)<self.view.frame.size.width/8)){
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
            self.currentWidgetIndex = self.currentWidgetIndex+sign*-1;
            
            if(ABS(p.x)<200){
                [UIView animateWithDuration:0.4 delay:0
                                    options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                        
                                        [self moveAllViews];
                                    } completion:^(BOOL finished){
                                        //[self stopCoverPage:nil];
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


- (void)stopCoverPage:(NSTimer *)timer{
    //NSLog(@"currentIndex:%d",self.currentIndex);
    
    REMWidgetDetailViewController *current=self.childViewControllers[self.currentWidgetIndex];
    [current showChart];
    
    if(self.currentWidgetIndex<self.childViewControllers.count){
        NSInteger sign=[timer.userInfo[@"direction"] integerValue];
        NSNumber *willIndex= @(self.currentWidgetIndex-1*sign);
        if(willIndex.intValue>=self.childViewControllers.count || willIndex.intValue<0){
            return;
        }
        REMWidgetDetailViewController *vc= self.childViewControllers[willIndex.intValue];
        
        
       
        [vc showChart];
        
    }
    
}

- (void)popToBuildingCover{
    [self cancelAllRequest];
    [self performSegueWithIdentifier:@"exitWidgetSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
    for (int i=0; i<self.childViewControllers.count; ++i) {
        if(self.currentWidgetIndex!=i && (self.currentWidgetIndex-1)!=i && (self.currentWidgetIndex+1)!=i){
            REMWidgetDetailViewController *vc=self.childViewControllers[i];
            [vc releaseChart];
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
