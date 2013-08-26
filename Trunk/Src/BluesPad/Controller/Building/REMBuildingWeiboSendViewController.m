//
//  REMBuildingWeiboSendViewController.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/26/13.
//
//

#import "REMBuildingWeiboSendViewController.h"

@interface REMBuildingWeiboSendViewController ()

@end

@implementation REMBuildingWeiboSendViewController

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
    const CFTimeInterval kWeiboWindowHeight = 200;
    const CFTimeInterval kToolbarHeight = 20;
    const CFTimeInterval kWeiboWindowWidth = 500;
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kWeiboWindowWidth, 50)];
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 50, 250, 200)];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 50, 50, 50)];
    [cancelBtn setFrame:CGRectMake(0, 10, 100, 40)];
    [sendBtn setFrame:CGRectMake(300, 10, 100, 40)];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:cancelBtn];
    [toolbar addSubview:sendBtn];
    
    [self.view addSubview:toolbar];
    [self.view addSubview:textView];
    [self.view addSubview:imageView];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendClicked:(id)sender {
    NSLog(@"SEND");
    
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
