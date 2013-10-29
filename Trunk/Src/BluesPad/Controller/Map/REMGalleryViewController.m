//
//  REMGalleryViewController.m
//  Blues
//
//  Created by 张 锋 on 9/30/13.
//
//

#import "REMGalleryViewController.h"
#import "REMGalleryCollectionView.h"
#import "REMMapViewController.h"
#import "REMGalleryCollectionCell.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMStoryboardDefinitions.h"
#import "REMBuildingOverallModel.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingEntranceSegue.h"
#import "REMBuildingViewController.h"
#import "REMMapGallerySegue.h"

#define kGalleryBuildingImageGroupName @"GALLERY"

@interface REMGalleryViewController ()

@property (nonatomic) BOOL isPinching;

@end


@implementation REMGalleryViewController{
    REMGalleryCollectionView *galleryView;
}

- (void)loadView
{
    //[super loadView];
    //initialize UICollectionView
    
    if(galleryView == nil){
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        [layout setSectionInset:UIEdgeInsetsMake(109, 25, 0, 25)];
        
        //CGRect viewFrame = self.mapViewController.view == nil?CGRectZero:self.mapViewController.view.bounds;
        
        galleryView = [[REMGalleryCollectionView alloc] initWithFrame:self.mapViewController.view.frame collectionViewLayout:layout];
        galleryView.dataSource = self;
        galleryView.delegate = self;
        [galleryView registerClass:[REMGalleryCollectionCell class] forCellWithReuseIdentifier:kCellIdentifier_GalleryCell];
        [galleryView setBackgroundColor:[UIColor blackColor]];
        
        self.view = galleryView;
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
    //[self playZoomAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSwitchButton
{
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIButton alloc] initWithFrame:];
    [switchButton setFrame:kDMCommon_TopLeftButtonFrame];
    [switchButton setImage:[UIImage imageNamed:@"Map.png"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:switchButton];
}

-(void)switchButtonPressed
{
    REMMapGallerySegue *segue = [[REMMapGallerySegue alloc] initWithIdentifier:kSegue_GalleryToMap source:self destination:self.mapViewController];
    
    [self prepareForSegue:segue sender:self];
    [segue perform];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kSegue_GalleryToBuilding] == YES)
    {
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        customSegue.isNoAnimation = self.isPinching;
        customSegue.isInitialPresenting = NO;
        customSegue.initialZoomRect = self.initialZoomRect;
        customSegue.finalZoomRect = self.view.frame;
        customSegue.currentBuilding = self.selectedBuilding == nil?[self.buildingInfoArray[0] building]:self.selectedBuilding;
        
        if(self.selectedBuilding == nil){
            UICollectionViewCell *cell = [galleryView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            self.initialZoomRect = cell.frame;
        }
        
        self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
        
        REMBuildingViewController *buildingViewController = customSegue.destinationViewController;
        buildingViewController.buildingOverallArray = self.buildingInfoArray;
        buildingViewController.splashScreenController = self.splashScreenController;
        buildingViewController.fromController = self;
        buildingViewController.currentBuildingId = self.selectedBuilding.buildingId;
    }
}

- (void)galleryCellTapped:(REMGalleryCollectionCell *)cell
{
    [self.view setUserInteractionEnabled:NO];
    
    self.initialZoomRect = cell.frame;
    self.selectedBuilding = cell.building;
    self.isPinching = NO;
    
    [self performSegueWithIdentifier:kSegue_GalleryToBuilding sender:self];
}


-(void)galleryCellPinched:(REMGalleryCollectionCell *)cell :(UIPinchGestureRecognizer *)pinch
{
    if(pinch.state  == UIGestureRecognizerStateBegan){
        UIImageView *snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:cell]];
        cell.snapshot = snapshot;
        
        
        UIView *cover = [[UIView alloc] initWithFrame:cell.frame];
        [cover setBackgroundColor:[UIColor blackColor]];
        cell.blackCover = cover;
        
        [self.view addSubview:cell.blackCover];
        [self.view addSubview:cell.snapshot];
    }
    
    if(pinch.state  == UIGestureRecognizerStateChanged){
        CGFloat scale = pinch.scale < 1 ? 1 : pinch.scale;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        cell.snapshot.layer.affineTransform = scaleTransform;

        CGPoint point = [pinch locationInView:self.view];
        cell.snapshot.center = point;
    }
    
    if(pinch.state  == UIGestureRecognizerStateEnded || pinch.state  == UIGestureRecognizerStateCancelled || pinch.state  == UIGestureRecognizerStateFailed){
        
        if(pinch.scale <= 1){ //scale did not change,
            CGPoint pinchPoint = [pinch locationInView:self.view];
            CGPoint cellCenter = [REMViewHelper getCenterOfRect:cell.frame];
            
            if(pinchPoint.x != cellCenter.x || pinchPoint.y != cellCenter.y){ //but position changed
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.snapshot.center = self.view.center;
                } completion:^(BOOL finished) {
                    [cell.blackCover removeFromSuperview];
                    cell.blackCover = nil;
                    
                    [cell.snapshot removeFromSuperview];
                    cell.snapshot = nil;
                }];
            }
        }
        else{ //scale larger
            CGRect initialiZoomRect = cell.snapshot.frame;
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //from self.snapshot.frame to self.mapViewController.initialZoomRect;
                self.snapshot.transform = [REMViewHelper getScaleTransformFromOriginalFrame:initialiZoomRect andFinalFrame:self.view.frame];
                self.snapshot.center = [REMViewHelper getCenterOfRect:self.view.frame];
            } completion:^(BOOL finished) {
                [cell.blackCover removeFromSuperview];
                cell.blackCover = nil;
                
                [cell.snapshot removeFromSuperview];
                cell.snapshot = nil;
                
                self.initialZoomRect = cell.frame;
                self.selectedBuilding = cell.building;
                self.isPinching = YES;
                
                [self performSegueWithIdentifier:kSegue_GalleryToBuilding sender:self];
            }];
        }

    }
}

-(void)loadBuildingSmallImage:(NSArray *)imageIds :(void (^)(UIImage *))completed
{
    if(imageIds != nil && imageIds.count > 0){
        NSString *smallImagePath = [REMImageHelper buildingImagePathWithId:imageIds[0] andType:REMBuildingImageSmall];
        NSString *smallBlurImagePath = [REMImageHelper buildingImagePathWithId:imageIds[0] andType:REMBuildingImageSmallBlured];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:smallImagePath] == YES){
            completed([UIImage imageWithContentsOfFile:smallImagePath]);
        }
        else{
            NSDictionary *parameter = @{@"pictureId":imageIds[0], @"isSmall":@"true"};
            REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSBuildingPicture parameter:parameter];
            store.groupName = kGalleryBuildingImageGroupName;
            [REMDataAccessor access:store success:^(id data) {
                if(data == nil || [data length] <= 2)
                    return;
                
                UIImage *smallImage = [REMImageHelper parseImageFromNSData:data];
                [REMImageHelper writeImageFile:smallImage withFullPath:smallImagePath];
                
                UIImage *smallBlurImage = [REMImageHelper blurImage:smallImage];
                [REMImageHelper writeImageFile:smallBlurImage withFileName:smallBlurImagePath];
                
                completed([UIImage imageWithContentsOfFile:smallImagePath]);
            } error:^(NSError *error, id response) {
            }];
        }
    }
}

-(CGRect)getCurrentZoomRect:(NSNumber *)currentBuildingId
{
    for (REMGalleryCollectionCell *cell in galleryView.visibleCells){
        //NSLog(@"%@",NSStringFromCGRect(cell.frame));
        
        if(cell.building.buildingId == currentBuildingId)
            return cell.frame;
    }
    
    return CGRectZero;
}


#pragma mark collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buildingInfoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMGalleryCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GalleryCell forIndexPath:indexPath];
    
    REMBuildingModel *building = ((REMBuildingOverallModel *)self.buildingInfoArray[indexPath.row]).building;
    
    cell.building = building;
    cell.controller = self;
    
    [self loadBuildingSmallImage:building.pictureIds :^(UIImage *image) {
        cell.backgroundImage = image;
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(147, 110);
}

@end
