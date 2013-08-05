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
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view, typically from a nib.
    self.currentIndex=0;
    self.cumulateX=0;
    //NSLog(@"start pie:%f",M_PI_4);
    UIPanGestureRecognizer *rec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
    [self.view addGestureRecognizer:rec];
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark buildingview

- (void) swipethis:(UIPanGestureRecognizer *)pan
{
    NSLog(@"swipethis");
    CGPoint trans= [pan translationInView:self.view];
    
    NSLog(@"state:%d",pan.state);
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (UIImageView *view in self.imageArray)
        {
            [view setCenter:CGPointMake(view.center.x+trans.x, view.center.y)];
        }
        
        self.cumulateX+=trans.x;
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        
        __block CGPoint p= [pan velocityInView:self.view];
        NSLog(@"cumulatex:%f",self.cumulateX);
        
        int sign= p.x>0?1:-1;
        
        
        __block BOOL addIndex=YES;
        
        [UIView animateWithDuration:0.2 delay:0
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
                                for(int i=0;i<self.imageArray.count;++i)
                                {
                                    NSNumber *s = self.originCenterXArray[i];
                                    CGFloat x= [s floatValue];
                                    UIImageView *image = self.imageArray[i];
                                    [image setCenter: CGPointMake( x,image.center.y)];
                                }
                                
                                if(addIndex ==YES){
                                    self.currentIndex=self.currentIndex+sign*-1;
                                }
                                self.cumulateX=0;
                                
                            } completion:^(BOOL ret){
                                
                            }];
        
        [pan setTranslation:CGPointZero inView:self.view];
        
        
    }
    
}


- (void) scrollInnerView:(UIPanGestureRecognizer *)pan
{
    
    NSLog(@"scrollthis");
    
    CGPoint trans= [pan translationInView:self.view];
    CGPoint velocity=[pan velocityInView:self.view];
    
    if (pan.state  == UIGestureRecognizerStateChanged) {
        for (REMImageView *view in self.imageArray) {
            [view move:trans.y];
        }
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        if(ABS(velocity.y)>50 && ABS(velocity.y)<1000){
            if(velocity.y<0)
            {
                for (REMImageView *view in self.imageArray) {
                    [view scrollUp:YES];
                }
            }
            else{
                for (REMImageView *view in self.imageArray) {
                    [view scrollDown:YES];
                }
            }
            
        }
        else if(ABS(velocity.y)<50){
            
            for (REMImageView *view in self.imageArray) {
                [view moveEnd];
            }
        }
        else{
            for (REMImageView *view in self.imageArray) {
                [view moveEndByVelocity:velocity.y];
            }
        }
        
        
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
}

- (void)panthis:(UIPanGestureRecognizer *)pan
{
    
    CGPoint trans= [pan translationInView:self.view];
    CGPoint velocity= [pan velocityInView:self.view];
    NSLog(@"trans:%@",NSStringFromCGPoint(trans));
    NSLog(@"velocity:%@",NSStringFromCGPoint(velocity));
    NSLog(@"state:%d",pan.state);
    //if(trans.x == 0 && trans.y==0) return;
    //NSLog(@"tan:%f",tan(M_PI_4)*ABS(trans.x));
    //    double r;
    //    if(ABS(trans.x)==0)
    //    {
    //        r = 0;
    //    }
    //    else if(ABS(trans.y)==0)
    //    {
    //        r= 1;
    //    }
    //    else{
    //        r =  ABS(trans.y/trans.x);
    //    }
    //    NSLog(@"r:%f",r);
    if(ABS(velocity.x)>ABS(velocity.y)){
        [self swipethis:pan];
    }
    else{
        [self scrollInnerView:pan];
    }
    
}

- (void)log {
    NSLog(@"Bounds %@", NSStringFromCGRect(self.view.bounds));
    NSLog(@"Frame %@", NSStringFromCGRect(self.view.frame));
}



- (void)viewDidAppear:(BOOL)animated
{
    
    REMImageView *imageView = [[REMImageView alloc]initWithFrame:
                               CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                                   WithImageName:@"wangjingsoho"];
    imageView.contentMode= UIViewContentModeScaleToFill;
    [self.view addSubview:imageView];
    
    
    REMImageView *imageView1 = [[REMImageView alloc]initWithFrame:
                                CGRectMake(self.view.bounds.size.width+5, 0, self.view.bounds.size.width, self.view.bounds.size.height) WithImageName:@"yinhesoho"];
    imageView1.contentMode= UIViewContentModeScaleToFill;
    [self.view addSubview:imageView1];
    REMImageView *imageView2 = [[REMImageView alloc]initWithFrame:
                                CGRectMake(self.view.bounds.size.width*2+5*2, 0, self.view.bounds.size.width, self.view.bounds.size.height) WithImageName:@"sanlitunsoho"];
    imageView2.contentMode= UIViewContentModeScaleToFill;
    [self.view addSubview:imageView2];
    
    self.imageArray=@[imageView,imageView1,imageView2];
    self.currentIndex=0;
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:self.imageArray.count];
    
    for (REMImageView *view in self.imageArray) {
        
        NSNumber *num = [NSNumber numberWithFloat:view.center.x];
        [arr addObject:num];
    }
    NSLog(@"start center:%@",arr);
    self.originCenterXArray=arr;
}


-(void)tapthis:(UITapGestureRecognizer *)tap
{
    
    
    
    REMImageView *view=  self.imageArray[self.currentIndex];
    [view tapthis:YES];
    
    for(int i=0;i<self.imageArray.count;++i)
    {
        if(i!=self.currentIndex)
        {
            REMImageView *v = self.imageArray[i];
            [v tapthis:NO];
            dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(concurrentQueue, ^{
                
                
                
                UIImage *image = [v blurthis];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [v setBlurred:image];
                    
                    
                });
                
            });
        }
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
    
    [self.splashScreenController gotoLoginView];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
