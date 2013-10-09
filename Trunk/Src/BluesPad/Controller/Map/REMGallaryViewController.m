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
        
        gallaryView = [[REMGallaryView alloc] initWithFrame:self.viewFrame collectionViewLayout:layout];
        gallaryView.dataSource = self;
        gallaryView.delegate = self;
        [gallaryView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gallaryCellIdentifier"];
        [gallaryView setBackgroundColor:[UIColor redColor]];
        
        CGAffineTransform tr = [self translatedAndScaledTransformUsingViewRect:self.originalFrame fromRect:self.viewFrame];
        gallaryView.transform = tr;
        
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
//    CGFloat widthRatio = self.stopFrame.size.width/self.startFrame.size.width;
//    CGFloat heightRatio = self.stopFrame.size.height/self.startFrame.size.height;
//    CGAffineTransform tr = CGAffineTransformScale(self.view.transform, widthRatio, heightRatio);

    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.transform = [self translatedAndScaledTransformUsingViewRect:self.viewFrame fromRect:self.originalFrame];
    } completion:^(BOOL finished) {
        //[self addSwitchButton];
        NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSwitchButton
{
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIButton alloc] initWithFrame:];
    [switchButton setFrame:CGRectMake(25, 20, 32, 32)];
    [switchButton setImage:[UIImage imageNamed:@"LandMarker.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:switchButton];
}

- (CGAffineTransform)translatedAndScaledTransformUsingViewRect:(CGRect)viewRect fromRect:(CGRect)fromRect {
    CGSize scales = CGSizeMake(viewRect.size.width/fromRect.size.width, viewRect.size.height/fromRect.size.height);
    CGPoint offset = CGPointMake(CGRectGetMidX(viewRect) - CGRectGetMidX(fromRect), CGRectGetMidY(viewRect) - CGRectGetMidY(fromRect));
    
    return CGAffineTransformMake(scales.width, 0, 0, scales.height, offset.x, offset.y);
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
