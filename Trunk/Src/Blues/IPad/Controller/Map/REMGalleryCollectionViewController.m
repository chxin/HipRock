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
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setMinimumInteritemSpacing:1.0];
    [flowlayout setMinimumLineSpacing:kDMGallery_GalleryCellVerticleSpace];
    [flowlayout setItemSize:kDMGallery_GalleryCellSize];
    
    self = [super initWithCollectionViewLayout:flowlayout];
    if(self != nil){
        self.collectionKey = key;
        self.buildingInfoArray = buildingInfoArray;
    }
    
    return self;
}


-(CGRect)getCollectionFrame
{
    int rowCount = (self.buildingInfoArray.count / 6) + 1;
    CGFloat height = kDMGallery_GalleryCollectionViewTopMargin + kDMGallery_GalleryCollectionViewBottomMargin + (rowCount * kDMGallery_GalleryCellHeight) + ((rowCount - 1) * kDMGallery_GalleryCellVerticleSpace);
    
    return CGRectMake(0, kDMGallery_GalleryGroupTitleFontSize, kDMGallery_GalleryGroupViewWidth, height);
}


- (void)viewDidLoad
{
    CGRect collectionViewFrame = [self getCollectionFrame];
    
    self.view.frame = collectionViewFrame;
    
    self.collectionView.frame = CGRectMake(0,0,collectionViewFrame.size.width,collectionViewFrame.size.height);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = kDMGallery_GalleryCollectionViewInsets;
    self.collectionView.autoresizingMask = UIViewAutoresizingNone;
    
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView registerClass:[REMGalleryCollectionCell class] forCellWithReuseIdentifier:kCellIdentifier_GalleryCollectionCell];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview: self.collectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)galleryCellTapped:(REMGalleryCollectionCell *)cell
{
    if(!self.isPinching){
        cell.alpha = 0;
        [((REMGalleryViewController *)self.parentViewController) presentBuildingViewFromCell:cell animated:NO];
    }
    else{
        NSLog(@"Gallery in PINCH status, TAP forbidden.");
    }
}


-(void)galleryCellPinched:(REMGalleryCollectionCell *)cell :(UIPinchGestureRecognizer *)pinch
{
    REMGalleryViewController *galleryController = (REMGalleryViewController *)self.parentViewController;
    
    if(pinch.state  == UIGestureRecognizerStateBegan){
        [cell.backgroundButton setAdjustsImageWhenHighlighted:NO];
        self.isPinching = YES;
        [cell beginPinch]; //snapshot will be ready
        //galleryController.snapshot = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:galleryController.view]];
        [galleryController takeSnapshot];
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
        
        [cell.backgroundButton setAdjustsImageWhenHighlighted:YES];
        
        if(pinch.scale <= 1){ //scale did not change,
            CGPoint pinchPoint = [pinch locationInView:galleryController.view];
            CGPoint cellCenterInGalleryView = [self.collectionView convertPoint:cell.center toView:galleryController.view];

            if(pinchPoint.x != cellCenterInGalleryView.x || pinchPoint.y != cellCenterInGalleryView.y){ //but position changed
                [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.snapshot.center = cellCenterInGalleryView;
                } completion:^(BOOL finished) {
                    [cell endPinch];
                    self.isPinching = NO;
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
                galleryController.currentBuildingIndex = [REMGalleryViewController indexOfBuilding:cell.building inBuildingOverallArray:self.buildingInfoArray]; //[galleryController buildingIndexFromBuilding:cell.building];
                self.isPinching = YES;
                
                //show building view
                [((REMGalleryViewController *)self.parentViewController) presentBuildingViewFromCell:cell animated:self.isPinching];
                
                self.isPinching = NO;
            }];
        }
    }
}

-(void)loadBuildingSmallImage:(NSArray *)imageIds :(void (^)(UIImage *))completed
{
    
    if(imageIds != nil && imageIds.count > 0){
        NSString *smallImagePath = [REMImageHelper buildingImagePathWithId:[imageIds[0] id] andType:REMBuildingImageSmall];
        NSString *smallBlurImagePath = [REMImageHelper buildingImagePathWithId:[imageIds[0] id] andType:REMBuildingImageSmallBlured];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:smallImagePath] == YES){
            completed([UIImage imageWithContentsOfFile:smallImagePath]);
        }
        else{
            NSDictionary *parameter = @{@"pictureId":[imageIds[0] id], @"isSmall":@"true"};
            REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSBuildingPicture parameter:parameter accessCache:YES andMessageMap:nil];
            store.groupName = kGalleryBuildingImageGroupName;
            [store access:^(id image) {
                [REMImageHelper writeImageFile:image withFullPath:smallImagePath];
                
                UIImage *smallBlurImage = [REMImageHelper blurImage:image];
                [REMImageHelper writeImageFile:smallBlurImage withFullPath:smallBlurImagePath];
                
                completed(image);
            }];
        }
    }
}

-(REMGalleryCollectionCell *)cellForBuilding:(NSNumber *)buildingId
{
    int buildingIndex = 0;
    for(int i=0;i<self.buildingInfoArray.count;i++){
        if([[self.buildingInfoArray[i] id] isEqualToNumber:buildingId]){
            buildingIndex = i;
            break;
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:buildingIndex inSection:0];
    
    return (REMGalleryCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
}


#pragma mark collection view data source delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buildingInfoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMGalleryCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GalleryCollectionCell forIndexPath:indexPath];
    
    cell.building = self.buildingInfoArray[indexPath.row];
    cell.titleLabel.text = cell.building.name;
    cell.controller = self;
    
    [self loadBuildingSmallImage:[cell.building.pictures allObjects] :^(UIImage *image) {
        UIImage *scaled = [cell resizeImageForCell:image];
        
        [cell.backgroundButton setImage:scaled forState:UIControlStateNormal];
        cell.backgroundButton.imageView.contentMode = UIViewContentModeScaleToFill;
    }];
    
    return cell;
}



@end
