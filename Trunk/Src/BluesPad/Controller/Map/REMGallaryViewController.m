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
#import "REMMapBuildingSegue.h"
#import "REMBuildingViewController.h"

#define kGallaryBuildingImageGroupName @"GALLARY"

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
        
        gallaryView = [[REMGallaryView alloc] initWithFrame:self.mapViewController.view.frame collectionViewLayout:layout];
        gallaryView.dataSource = self;
        gallaryView.delegate = self;
        [gallaryView registerClass:[REMGallaryCell class] forCellWithReuseIdentifier:kCellIdentifier_GallaryCell];
        [gallaryView setBackgroundColor:[UIColor blackColor]];
        
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
    [switchButton setFrame:CGRectMake(25, 20, 32, 32)];
    [switchButton setImage:[UIImage imageNamed:@"LandMarker.png"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:switchButton];
}

-(void)switchButtonPressed
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kSegue_MapToBuilding] == YES)
    {
        REMMapBuildingSegue *customeSegue = (REMMapBuildingSegue *)segue;
        customeSegue.isInitialPresenting = NO;
        customeSegue.initialZoomRect = self.initialZoomRect;
        customeSegue.finalZoomRect = self.view.frame;
        
        if(self.selectedBuilding == nil){
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            self.initialZoomRect = cell.frame;
        }
        
        self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
        
        REMBuildingViewController *buildingViewController = customeSegue.destinationViewController;
        buildingViewController.buildingOverallArray = self.buildingInfoArray;
        buildingViewController.splashScreenController = self.splashScreenController;
        buildingViewController.mapViewController = self;
        buildingViewController.currentBuildingId = self.selectedBuilding.buildingId;
    }
}

-(void)presentBuildingView
{
    [self performSegueWithIdentifier:kSegue_MapToBuilding sender:self];
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)gallaryCellTapped:(REMGallaryCell *)cell
{
    self.snapshot = [[UIImageView alloc] initWithImage:[REMImageHelper imageWithView:self.view]];
    self.initialZoomRect = cell.frame;
    self.selectedBuilding = cell.building;
    
    [self.mapViewController presentBuildingView];
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
            NSDictionary *parameter = @{@"pictureId":imageIds[0], @"isSmall":@1};
            REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSBuildingPicture parameter:parameter];
            store.groupName = kGallaryBuildingImageGroupName;
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


#pragma mark collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buildingInfoArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMGallaryCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GallaryCell forIndexPath:indexPath];
    
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
