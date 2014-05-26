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
@property (nonatomic,weak) UIImageView *srcBg;
@property (nonatomic) BOOL readyToClose;
@property (nonatomic,strong) NSArray *widgets;


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

-(NSArray *)widgets
{
    if(_widgets == nil){
        _widgets = [self.dashboardInfo.widgets.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 id] compare:[obj2 id]];
        }];
    }
    
    return _widgets;
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
    for (int i=0; i<self.widgets.count; ++i) {
        REMManagedWidgetModel *obj=self.widgets[i];
        
        REMWidgetDetailViewController *sub=[[REMWidgetDetailViewController alloc]init];
        sub.widgetInfo=obj;
        REMWidgetCellViewController *cellController= self.widgetCollectionController.childViewControllers[i];
        sub.energyData=cellController.chartData;
        sub.buildingInfo=self.buildingInfo;
        sub.dashboardInfo=self.dashboardInfo;
        sub.serverError=cellController.serverError;
        sub.isServerTimeout=cellController.isServerTimeout;
        [self addChildViewController:sub];
        if (i==self.currentWidgetIndex) {
            UIView *view = sub.view;
            [view setFrame:CGRectMake(i*self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            
            
            NSInteger gap=i-self.currentWidgetIndex;
            [sub.view setCenter:CGPointMake(gap*(self.view.frame.size.width+widgetGap)+self.view.frame.size.width/2, self.view.center.y)];
            
            [self.view addSubview:sub.view];
            
//            if(i==self.currentWidgetIndex || i==(self.currentWidgetIndex-1) || i == (self.currentWidgetIndex+1)){
//                [sub showChart];
//            }
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

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent==nil) {
        return;
    }
    for (int i=0; i<self.childViewControllers.count; ++i) {
        
        REMWidgetDetailViewController *sub=self.childViewControllers[i];
        
        
        UIView *view = sub.view;
        [view setFrame:CGRectMake(i*self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        
        NSInteger gap=i-self.currentWidgetIndex;
        [sub.view setCenter:CGPointMake(gap*(self.view.frame.size.width+widgetGap)+self.view.frame.size.width/2, self.view.center.y)];
        
        [self.view addSubview:sub.view];
        
        if(i==self.currentWidgetIndex /*|| i==(self.currentWidgetIndex-1) || i == (self.currentWidgetIndex+1)*/){
            [sub showChart];
        }
        
        
    }
}



- (void) addDashboardBg{
    REMDashboardController *srcController=(REMDashboardController *) self.widgetCollectionController.parentViewController;
    REMBuildingImageViewController *imageController=(REMBuildingImageViewController *)srcController.parentViewController;
    REMWidgetCellViewController *cellController=self.widgetCollectionController.childViewControllers[self.currentWidgetIndex];
    [cellController.view setHidden:YES];
    UIImage *image=[REMImageHelper imageWithView:imageController.view];
    UIImageView *view = [[UIImageView alloc]initWithImage:image];
    [view setFrame:self.view.frame];
    [view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    UIViewController *controller=self.childViewControllers[self.currentWidgetIndex];
    
    [self.view insertSubview:view belowSubview:controller.view];
    self.srcBg=view;
    self.srcBg.alpha=0;
    [cellController.view setHidden:NO];
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
        
    }
}

- (void)cancelAllRequest{
    for (REMManagedWidgetModel *widget in self.widgets) {
        [REMDataStore cancel:[NSString stringWithFormat:@"widget-%@",widget.id]];
    }
}

- (void)panthis:(UIPanGestureRecognizer *)pan{
    
    
    CGPoint trans= [pan translationInView:self.view];
    
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        CGFloat x;
        for (int i=0;i<self.childViewControllers.count;++i)
        {
            REMWidgetDetailViewController *vc = self.childViewControllers[i];
            
            if((self.currentWidgetIndex == 0 && self.cumulateX>0 ) ||
               ((self.currentWidgetIndex==(self.widgets.count-1)) && self.cumulateX<0)){
                if (self.srcBg==nil) {
                    [self addDashboardBg];
                }
                if(ABS(self.cumulateX)>90){
                    
                    
                    self.readyToClose=YES;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                        self.srcBg.alpha=1;
                    }completion:nil];
                }
                else{
                    self.readyToClose=NO;
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                        self.srcBg.alpha=0;
                    }completion:nil];
                }
                x=trans.x/4;
                
            }
            else{
                self.srcBg.alpha=0;
                x=trans.x;
            }
            [vc.view setCenter:CGPointMake(vc.view.center.x+x, vc.view.center.y)];
            
        }
        
        self.cumulateX+=x;
        //NSLog(@"cumulate x:%f",self.cumulateX);
    }
    
    if(pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled)
    {
        if(self.readyToClose==YES){
            self.lastPageXPosition=self.cumulateX;
            [self popToBuildingCover];
            return;
        }
        
        CGPoint p= [pan velocityInView:self.view];
        
        int sign= p.x>0?1:-1;
        
        
        BOOL addIndex=YES;
        
        if((sign<0 && self.currentWidgetIndex==self.widgets.count-1)
           || (sign>0 && self.currentWidgetIndex==0) ||
           (ABS(p.x)<200 && ABS(self.cumulateX)<self.view.frame.size.width/8) ||
           (p.x<0 && self.cumulateX>0) || (p.x>0 && self.cumulateX<0)){
            addIndex=NO;
        }
        else{
            [self.stopTimer invalidate];
            //NSLog(@"invalidate:%@",self.stopTimer);
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
            [self.srcBg removeFromSuperview];
            self.currentWidgetIndex = self.currentWidgetIndex+sign*-1;
            
            if(ABS(p.x)<200){
                [UIView animateWithDuration:0.4 delay:0
                                    options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                        
                                        [self moveAllViews];
                                    } completion:nil];
            }
            else{
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction|  UIViewAnimationOptionCurveEaseInOut animations:^(void){
                    [self moveAllViews];
                    
                }completion:^(BOOL finished){
                    [self.stopTimer invalidate];
                    //NSLog(@"before new timer:%@",self.stopTimer);
                    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(stopCoverPage:) userInfo:@{@"direction":@(sign)} repeats:NO];
                    NSRunLoop *current=[NSRunLoop currentRunLoop];
                    [current addTimer:timer forMode:NSDefaultRunLoopMode];
                    //NSLog(@"timer:%@",timer);
                    self.stopTimer = timer;
                }];
            }
            
        }
    }
    [pan setTranslation:CGPointZero inView:self.view];
}


- (void)stopCoverPage:(NSTimer *)timer{
    //NSLog(@"stop timer:%@",timer);
    
    REMWidgetDetailViewController *current=self.childViewControllers[self.currentWidgetIndex];
    [current showChart];
    /*
    if(self.currentWidgetIndex<self.childViewControllers.count){
        NSInteger sign=[timer.userInfo[@"direction"] integerValue];
        NSNumber *willIndex= @(self.currentWidgetIndex-1*sign);
        if(willIndex.intValue>=self.childViewControllers.count || willIndex.intValue<0){
            return;
        }
        REMWidgetDetailViewController *vc= self.childViewControllers[willIndex.intValue];
        
        
       
        [vc showChart];
        
    }*/
    
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
