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
#import "REMGallaryCell.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMStoryboardDefinitions.h"
#import "REMBuildingOverallModel.h"
#import <QuartzCore/QuartzCore.h>

@interface REMGallaryViewController ()

@end

@implementation REMGallaryViewController{
    REMGallaryView *gallaryView;
}

- (void)loadView
{
    //[super loadView];
    //initialize UICollectionView
    
    if(gallaryView == nil){
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setSectionInset:UIEdgeInsetsMake(109, 25, 0, 25)];
        
        //CGRect viewFrame = self.mapViewController.view == nil?CGRectZero:self.mapViewController.view.bounds;
        
        gallaryView = [[REMGallaryView alloc] initWithFrame:self.viewFrame collectionViewLayout:layout];
        gallaryView.dataSource = self;
        gallaryView.delegate = self;
        [gallaryView registerClass:[REMGallaryCell class] forCellWithReuseIdentifier:kCellIdentifier_GallaryCell];
        [gallaryView setBackgroundColor:[UIColor blackColor]];
        
        gallaryView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.originalFrame andFinalFrame:self.viewFrame];
        gallaryView.center = [REMViewHelper getCenterOfRect:self.originalFrame];
        
        self.view = gallaryView;
    }
    
    [self viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    
    [self addSwitchButton];
    
    [self.view addSubview:self.mapViewController.customerLogoButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self playZoomAnimation:YES];
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
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:switchButton];
}

-(void)switchButtonPressed
{
    [self playZoomAnimation:NO];
}

-(void)playZoomAnimation:(BOOL)isZoomIn
{
    NSTimeInterval duration = 0.5;
    if(isZoomIn == YES){
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.view.transform = transform;
            self.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        } completion:^(BOOL finished) {
        }];
    }
    else{
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            gallaryView.transform = [REMViewHelper getScaleTransformFromOriginalFrame:self.originalFrame andFinalFrame:self.viewFrame];
            gallaryView.center = [REMViewHelper getCenterOfRect:self.originalFrame];
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    }
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)gallaryCellTapped:(REMGallaryCell *)cell
{
//    CGRect frame = cell.frame;
//    CGRect bounds = cell.bounds;
//    NSLog(@"frame: %@",NSStringFromCGRect(frame));
//    NSLog(@"bounds: %@",NSStringFromCGRect(bounds));
    self.mapViewController.initialZoomRect = cell.frame;
    self.mapViewController.selectedBuilding = cell.building;
    [self.mapViewController presentBuildingView];
}


#pragma mark collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buildingInfoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMGallaryCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GallaryCell forIndexPath:indexPath];
    cell.building = ((REMBuildingOverallModel *)self.buildingInfoArray[indexPath.row]).building;
    cell.controller = self;
    
    //cell.backgroundColor=[UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(147, 110);
}

@end
