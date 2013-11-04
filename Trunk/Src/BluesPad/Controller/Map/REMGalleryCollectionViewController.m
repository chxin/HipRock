//
//  REMGalleryCollectionViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//
//  Created by 张 锋 on 10/29/13.
//
//

#import "REMGalleryCollectionViewController.h"
#import "REMGalleryViewController.h"
#import "REMMapViewController.h"
#import "REMGalleryCollectionCell.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMStoryboardDefinitions.h"
#import "REMBuildingOverallModel.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingViewController.h"
#import "REMImages.h"

@interface REMGalleryCollectionViewController ()

@property (nonatomic) BOOL isPinching;

@end

@implementation REMGalleryCollectionViewController


#define kGalleryBuildingImageGroupName @"GALLERY"

-(id)initWithKey:(NSString *)key andBuildingInfoArray:(NSArray *)buildingInfoArray
{
    self = [super init];
    if(self != nil){
        self.collectionKey = key;
        self.buildingInfoArray = buildingInfoArray;
    }
    
    return self;
}

- (void)loadView
{
	// Do any additional setup after loading the view.
    // initialize UICollectionView
    CGRect collectionViewFrame = [self getCollectionFrame];
    
    self.view = [[UIView alloc] initWithFrame:collectionViewFrame];
    self.view.clipsToBounds = NO;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setSectionInset:kDMGallery_GalleryCollectionViewInsets];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.frame = collectionViewFrame;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[REMGalleryCollectionCell class] forCellWithReuseIdentifier:kCellIdentifier_GalleryCollectionCell];
    [collectionView setBackgroundColor:[UIColor clearColor]];
//    collectionView.layer.borderColor = [UIColor redColor].CGColor;
//    collectionView.layer.borderWidth = 1.0;
    
    self.collectionView = collectionView;
    
    [self.view addSubview:self.collectionView];
    [self viewDidLoad];
}

-(CGRect)getCollectionFrame
{
    int rowCount = (self.buildingInfoArray.count / 6) + 1;
    CGFloat height = kDMGallery_GalleryCollectionViewTopMargin + kDMGallery_GalleryCollectionViewBottomMargin + (rowCount * kDMGallery_GalleryCellHeight) + ((rowCount - 1) * kDMGallery_GalleryCellVerticleSpace);
    
    NSLog(@"collection view height: %d", kDMGallery_GalleryGroupViewWidth);
    
    return CGRectMake(0, 0, kDMGallery_GalleryGroupViewWidth, height);
}


- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    
    NSLog(@"collectionviewframe1: %@",NSStringFromCGRect(self.collectionView.frame));
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"collectionviewframe2: %@",NSStringFromCGRect(self.collectionView.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)galleryCellTapped:(REMGalleryCollectionCell *)cell
{
    [((REMGalleryViewController *)self.parentViewController) presentBuildingViewFromCell:cell];
}


-(void)galleryCellPinched:(REMGalleryCollectionCell *)cell :(UIPinchGestureRecognizer *)pinch
{
    REMGalleryViewController *galleryController = (REMGalleryViewController *)self.parentViewController;
    
    if(pinch.state  == UIGestureRecognizerStateBegan){
        [cell beginPinch]; //snapshot will be ready
        [galleryController.view addSubview:cell.snapshot];
    }
    
    if(pinch.state  == UIGestureRecognizerStateChanged){
        CGFloat scale = pinch.scale < 1 ? 1 : pinch.scale;
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        CGPoint point = [pinch locationInView:galleryController.view];
        
        cell.snapshot.layer.affineTransform = scaleTransform;
        cell.snapshot.center = point;
    }
    
    if(pinch.state  == UIGestureRecognizerStateEnded || pinch.state  == UIGestureRecognizerStateCancelled || pinch.state  == UIGestureRecognizerStateFailed){
        if(pinch.scale <= 1){ //scale did not change,
            CGPoint pinchPoint = [pinch locationInView:galleryController.view];
            CGPoint cellCenterInGalleryView = [self.collectionView convertPoint:cell.center toView:galleryController.view];

            if(pinchPoint.x != cellCenterInGalleryView.x || pinchPoint.y != cellCenterInGalleryView.y){ //but position changed
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.snapshot.center = cellCenterInGalleryView;
                } completion:^(BOOL finished) {
                    [cell endPinch];
                }];
            }
        }
        else{ //scale larger
            CGFloat scale = galleryController.view.frame.size.width / cell.frame.size.width;
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.snapshot.layer.affineTransform = CGAffineTransformMakeScale(scale, scale);
                cell.snapshot.center = galleryController.view.center;
            } completion:^(BOOL finished) {
                [cell endPinch];
                
                galleryController.initialZoomRect = [self.collectionView convertRect:cell.frame toView:galleryController.view];
                galleryController.currentBuildingIndex = [galleryController buildingIndexFromBuilding:cell.building];
                self.isPinching = YES;
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

-(REMGalleryCollectionCell *)cellForBuilding:(NSNumber *)buildingId
{
    int buildingIndex = 0;
    for(int i=0;i<self.buildingInfoArray.count;i++){
        if([[self.buildingInfoArray[i] building].buildingId isEqualToNumber:buildingId]){
            buildingIndex = i;
            break;
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:buildingIndex inSection:0];
    
    return (REMGalleryCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}


#pragma mark collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buildingInfoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMGalleryCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GalleryCollectionCell forIndexPath:indexPath];
    
    cell.building = [self.buildingInfoArray[indexPath.row] building];
    cell.titleLabel.text = cell.building.name;
    cell.controller = self;
    ((UIImageView *)cell.backgroundView).image = REMIMG_DefaultBuilding_Small;
    
    [self loadBuildingSmallImage:cell.building.pictureIds :^(UIImage *image) {
        ((UIImageView *)cell.backgroundView).image = image;
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kDMGallery_GalleryCellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDMGallery_GalleryCellVerticleSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kDMGallery_GalleryCellHorizontalSpace;
}


@end
