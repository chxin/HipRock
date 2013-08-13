//
//  REMBuildingViewController.m
//  Blues
//
//  Created by 张 锋 on 7/26/13.
//
//

#import "REMBuildingViewController.h"
#import "REMApplicationContext.h"

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
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis:)];
    [self.view addGestureRecognizer:tap];
    
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
        
        int sign= p.x>0?1:-1;
        
        
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
                                
                                [self loadImageData];
                                if(self.currentIndex<self.imageArray.count){
                                    NSNumber *status = self.imageViewStatus[@(self.currentIndex+1)];
                                    if([status isEqualToNumber:@(0)] ==YES){
                                        [self.view insertSubview:self.imageArray[self.currentIndex+1] belowSubview:self.logoutButton];
                                        
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
                                    //[self releaseOutOfWindowView:releaseArray];
                                }
                                else if((idx+2)<=self.imageArray.count){
                                    int i=self.imageArray.count-1;
                                    while (i>=(idx+2)) {
                                        [releaseArray addObject:@(i)];
                                        i--;
                                    }
                                    //[self releaseOutOfWindowView:releaseArray];
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

- (void) scrollInnerView:(UIPanGestureRecognizer *)pan
{
    //NSLog(@"cumulateX:%f",self.cumulateX);
    if(ABS(self.cumulateX)>0)return;
    self.inScrollY=YES;
    CGPoint trans= [pan translationInView:self.view];
    CGPoint velocity=[pan velocityInView:self.view];
    //NSLog(@"velocicty:%f",velocity.y);
    if (pan.state  == UIGestureRecognizerStateChanged &&
                    (ABS(velocity.y) < kScrollVelocityMax || ABS(trans.y)>kMoveLen)) {
        for (REMImageView *view in self.imageArray) {
            [view move:trans.y];
        }
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        //NSLog(@"movelen:%f",trans.y);
        //NSLog(@"velocicty:%f",velocity.y);
        /*if(ABS(velocity.y)>kScrollVelocitySmall && ABS(velocity.y)<kScrollVelocityMax){
            if(velocity.y<0)
            {
                for (REMImageView *view in self.imageArray) {
                    [view scrollUp];
                }
            }
            else{
                for (REMImageView *view in self.imageArray) {
                    [view scrollDown];
                }
            }
            
        }
        else */
        if(ABS(velocity.y)<kScrollVelocityMax){
            
            for (REMImageView *view in self.imageArray) {
                [view moveEnd];
            }
        }
        else{
            for (REMImageView *view in self.imageArray) {
                [view moveEndByVelocity:velocity.y];
            }
        }
        
            self.inScrollY=NO;
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
}

- (void)panthis:(UIPanGestureRecognizer *)pan
{
    
    CGPoint velocity= [pan velocityInView:self.view];
    if(self.inScrollY == NO && ( ABS(velocity.x)>ABS(velocity.y) || self.cumulateX!=0)){
        [self swipethis:pan];
    }
    else{
        [self scrollInnerView:pan];
    }
    
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
