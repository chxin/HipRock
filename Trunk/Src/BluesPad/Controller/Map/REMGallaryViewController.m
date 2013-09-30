//
//  REMGallaryViewController.m
//  Blues
//
//  Created by 张 锋 on 9/30/13.
//
//

#import "REMGallaryViewController.h"
#import "REMGallaryView.h"
#import "REMMapViewController.h"

@interface REMGallaryViewController ()

@end

@implementation REMGallaryViewController{
    REMGallaryView *gallaryView;
}

- (void)loadView
{
    //initialize UICollectionView
    if(gallaryView == nil){
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        
        //CGRect viewFrame = self.mapViewController.view == nil?CGRectZero:self.mapViewController.view.bounds;
        
        gallaryView = [[REMGallaryView alloc] initWithFrame:self.startFrame collectionViewLayout:layout];
        gallaryView.dataSource = self;
        gallaryView.delegate = self;
        [gallaryView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gallaryCellIdentifier"];
        [gallaryView setBackgroundColor:[UIColor redColor]];
        
        self.view = gallaryView;
    }
    
    [self viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addSwitchButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    //zoom out to full screen
    CGFloat widthRatio = self.stopFrame.size.width/self.startFrame.size.width;
    CGFloat heightRatio = self.stopFrame.size.height/self.startFrame.size.height;
    CGAffineTransform tr = CGAffineTransformScale(self.view.transform, widthRatio, heightRatio);

    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = tr;
        self.view.center = CGPointMake(self.stopFrame.size.width/2,self.stopFrame.size.height/2);
    } completion:^(BOOL finished) {}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSwitchButton
{
    UIButton *switchButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 20, 32, 32)];
    [switchButton setImage:[UIImage imageNamed:@"LandMarker.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:switchButton];
}


#pragma mark collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"gallaryCellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

@end
