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

@interface REMBuildingViewController ()
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic,strong) NSArray *originCenterXArray;
@property (nonatomic) CGFloat cumulateX;
@property (nonatomic) BOOL inScrollY;
@property (nonatomic,strong) NSMutableDictionary *imageViewStatus;
@property (nonatomic,strong) UIButton *logoutButton;
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
	
    self.view.backgroundColor=[UIColor blackColor];
    
    [self initImageView];
    
    self.currentIndex=0;
    self.cumulateX=0;
    
    [self initButtons];
    

    UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
    [self.view addGestureRecognizer:rec];
    rec.delegate = self;
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis:)];
    [self.view addGestureRecognizer:tap];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ==YES ){
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
    // Dispose of any resources that can be recreated.
    //self.buildingOverallArray=nil;
    
}

- (void) initButtons
{
    UIButton *logout=[[UIButton alloc]initWithFrame:CGRectMake(950, 20, 48, 48)];
    [logout setImage:[UIImage imageNamed:@"Logout.png"] forState:UIControlStateNormal];
    logout.titleLabel.text=@"注销";
    [logout addTarget:self action:@selector(logoutButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.logoutButton=logout;
    [self.view addSubview:logout];
    
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(950, 70, 48, 48)];
    [shareButton setImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:shareButton];
}

-(void)shareButtonTouchDown:(UIButton *)button
{
    NSString *content = @"Hello kitty!";
    NSData *image = nil;//[self cutImage]; //UIImagePNGRepresentation([UIImage imageNamed:@"Default"]);
    
    if (![Weibo.weibo isAuthenticated]) {
        [Weibo.weibo authorizeWithCompleted:^(WeiboAccount *account, NSError *error) {
            NSString *message = nil;
            if (!error) {
                message = [NSString stringWithFormat:@"Sign in successful: %@", account.user.screenName ];
                NSLog(@"%@", message);
                [REMAlertHelper alert:message];
                
                [self sendWeibo:content withImage:image];
            }
            else {
                message = [NSString stringWithFormat:@"Failed to sign in: %@", error];
                NSLog(@"%@", message);
                [REMAlertHelper alert:message];
            }
        }];
    }
    else {
        NSLog(@"%@", Weibo.weibo.currentAccount.user.screenName);
        
        [self sendWeibo:content withImage:image];
    }
}

-(void)sendWeibo:(NSString *)content withImage:(NSData *)imageData
{
    if(content.length > 135)
        content = [content substringToIndex:135];
    
    [Weibo.weibo newStatus:content pic:imageData completed:^(Status *status, NSError *error) {
        NSString *message = nil;
        if (error) {
            message = [NSString stringWithFormat:@"failed to post:%@", error];
        }
        else {
            message = [NSString stringWithFormat:@"success: %lld.%@", status.statusId, status.text];
        }
        
        NSLog(@"%@", message);
        [REMAlertHelper alert:message];
        //[Weibo.weibo signOut];
        
    }];
    
    
}

- (void)initImageView
{
    int width=1024,height=748,margin=5;
    int i=0;
    self.imageViewStatus = [[NSMutableDictionary alloc]initWithCapacity:self.buildingOverallArray.count];
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:self.buildingOverallArray.count];
    for (;i<self.buildingOverallArray.count;++i) {
        REMBuildingOverallModel *model = self.buildingOverallArray[i];
        REMImageView *imageView = [[REMImageView alloc]initWithFrame:CGRectMake((width+margin)*i, 0, width, height) withBuildingOveralInfo:model];
        //[self.view addSubview:imageView];
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
    
}


#pragma mark -
#pragma mark buildingview

- (void)loadImageData{
    REMImageView *image = self.imageArray[self.currentIndex];
    [image requireChartData];
}

- (void) swipethis:(UIPanGestureRecognizer *)pan
{
    //NSLog(@"swipethis");
    if(self.inScrollY == YES) return;
    CGPoint trans= [pan translationInView:self.view];
    
   // NSLog(@"state:%d",pan.state);
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (REMImageView *view in self.imageArray)
        {
//            [view setCenter:CGPointMake(view.center.x+trans.x, view.center.y)];
            [view moveCenter:trans.x];
        }
        
        self.cumulateX+=trans.x;
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        
        __block CGPoint p= [pan velocityInView:self.view];
        //NSLog(@"cumulatex:%f",self.cumulateX);
        
       __block int sign= p.x>0?1:-1;
        
        
        __block BOOL addIndex=YES;
        
        [UIView animateWithDuration:0.5 delay:0
                            options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
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
                                
                                [self loadImageData];
                                if(self.currentIndex<self.imageArray.count){
                                    NSNumber *willIndex= @(self.currentIndex-1*sign);
                                    NSNumber *status = self.imageViewStatus[willIndex];
                                    if([status isEqualToNumber:@(0)] ==YES){
                                        [self.view insertSubview:self.imageArray[willIndex.intValue] belowSubview:self.logoutButton];
                                        self.imageViewStatus[willIndex]=@(1);
                                        
                                    }
                                }
                                int idx = self.currentIndex;
                                
                                NSMutableArray *releaseArray=[[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
                                if((idx - 2) >=0){
                                    int i=0;
                                    while (i<=(idx-2)) {
                                        [releaseArray addObject:@(i)];
                                        i++;
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
                                }
                                
                                
                            }];
        
        [pan setTranslation:CGPointZero inView:self.view];
        
        
    }
    
}

- (void)releaseOutOfWindowView:(NSArray *)releaseViews{
    for (NSNumber *num in releaseViews) {
        REMImageView *image= self.imageArray[[num intValue]];
        if([self.imageViewStatus[num] isEqual:@(1)]== YES){
            [image removeFromSuperview];
            self.imageViewStatus[num]=@(0);
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

- (IBAction)logoutButtonPressed:(id)sender {
    REMUserModel *currentUser = [REMApplicationContext instance].currentUser;
    REMCustomerModel *currentCustomer = [REMApplicationContext instance].currentCustomer;
    
    [currentUser kill];
    [currentCustomer kill];
    currentUser = nil;
    currentCustomer = nil;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.splashScreenController showLoginView];
}

@end
