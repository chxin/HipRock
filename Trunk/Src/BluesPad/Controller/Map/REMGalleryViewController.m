//
//  REMGalleryViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/30/13.
//
//

#import "REMGalleryViewController.h"
#import "REMMapViewController.h"
#import "REMGalleryCollectionCell.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMStoryboardDefinitions.h"
#import "REMBuildingOverallModel.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingEntranceSegue.h"
#import "REMBuildingViewController.h"
#import "REMGalleryGroupView.h"
#import "REMGalleryCollectionViewController.h"
#import "REMImages.h"


@interface REMGalleryViewController ()

@property (nonatomic,strong) NSMutableDictionary *buildingGroups;
@property (nonatomic,weak) UITableView *galleryTableView;

@end


@implementation REMGalleryViewController



-(void)viewDidLoad
{
    //set self styles
    [self stylize];
    
    //add buttons
    [self addButtons];
    
    //process data
    [self groupBuildings];
    
    //add gallery table view
    [self addGalleryGroupView];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)addButtons
{
    //add switch button
    UIButton *switchButton = [[UIButton alloc]initWithFrame:kDMCommon_TopLeftButtonFrame];
    [switchButton setBackgroundImage:REMIMG_Map forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchButton];
    
    //add customer logo button
    [self.view addSubview:self.customerLogoButton];
}

-(void)stylize
{
    self.view.frame = kDMDefaultViewFrame;
    self.view.backgroundColor = kDMGallery_BackgroundColor;
}

-(void)addGalleryGroupView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:kDMGallery_GalleryTableViewFrame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[REMGalleryGroupView class] forCellReuseIdentifier:kCellIdentifier_GalleryGroupCell];
//    tableView.layer.borderColor = [UIColor blueColor].CGColor;
//    tableView.layer.borderWidth = 1.0;
    
    self.galleryTableView = tableView;
    [self.view addSubview:self.galleryTableView];
}


-(void)switchButtonPressed
{
    [self performSegueWithIdentifier:kSegue_GalleryToMap sender:self];
}

-(void)groupBuildings
{
    if(self.buildingGroups == nil){
        self.buildingGroups = [[NSMutableDictionary alloc] init];
        
        for (REMBuildingOverallModel *buildingInfo in self.buildingInfoArray) {
            NSString *province = buildingInfo.building.province;
            
            if([self.buildingGroups objectForKey:province] == nil){
                NSMutableArray *buildingArray = [[NSMutableArray alloc] init];
                [buildingArray addObject:buildingInfo];
                
                [self.buildingGroups setObject:buildingArray forKey:province];
            }
            else{
                NSMutableArray *buildingArray = [self.buildingGroups objectForKey:province];
                [buildingArray addObject:buildingInfo];
                
                [self.buildingGroups setObject:buildingArray forKey:province];
            }
        }
    }
}

-(CGRect)getGalleryGroupCellFrame:(int)buildingCount
{
    int rowCount = (buildingCount / 6) + 1;
    CGFloat cellHeight = kDMGallery_GalleryGroupTitleFontSize + kDMGallery_GalleryCollectionViewTopMargin + kDMGallery_GalleryCollectionViewBottomMargin + (rowCount * kDMGallery_GalleryCellHeight) + ((rowCount - 1) * kDMGallery_GalleryCellVerticleSpace);
    
    return CGRectMake(0, 0, kDMGallery_GalleryGroupViewWidth, cellHeight+1);
}

#pragma mark -UITableView data source delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.buildingGroups allKeys].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.buildingGroups allKeys][indexPath.row];
    NSArray *array = [self.buildingGroups objectForKey:key];
    
    REMGalleryCollectionViewController *collectionController = [[REMGalleryCollectionViewController alloc] initWithKey:key andBuildingInfoArray:array];
    [self addChildViewController:collectionController];
    
    REMGalleryGroupView *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GalleryGroupCell forIndexPath:indexPath];
    
    [cell setGroupTitle:key];
    [cell setCollectionView:collectionController.collectionView];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.buildingGroups objectForKey:[self.buildingGroups allKeys][indexPath.row]];
    
    return [self getGalleryGroupCellFrame:array.count].size.height;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kSegue_GalleryToBuilding] == YES)
    {
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(NO, self.currentBuildingIndex, self.initialZoomRect, self.view.frame)];
        
        REMBuildingViewController *buildingViewController = customSegue.destinationViewController;
        buildingViewController.buildingInfoArray = self.buildingInfoArray;
        buildingViewController.fromController = self;
        buildingViewController.currentBuildingIndex = self.currentBuildingIndex;
    }
}

-(void)presentBuildingViewFromCell:(REMGalleryCollectionCell *)cell
{
    [self.view setUserInteractionEnabled:NO];
    
    CGRect cellFrameInView = [self getGalleryCollectionCellFrameInGalleryView:cell];
    
    self.initialZoomRect = cellFrameInView;
    self.currentBuildingIndex = [self buildingIndexFromBuilding:cell.building];
    self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
    
    [self performSegueWithIdentifier:kSegue_GalleryToBuilding sender:self];
}



-(IBAction)unwindSegueToGallery:(UIStoryboardSegue *)sender
{
    
}

#pragma mark - Private methods

-(int)buildingIndexFromBuilding:(REMBuildingModel *)building
{
    for(int i=0;i<self.buildingInfoArray.count;i++){
        REMBuildingOverallModel *buildingInfo = self.buildingInfoArray[i];
        if([buildingInfo.building.buildingId isEqualToNumber:building.buildingId])
            return i;
    }
    
    return 0;
}

-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex
{
    // Find the collection controller
    REMGalleryCollectionViewController *currentCollectionController = nil;
    
    for(UIViewController *controller in self.childViewControllers){
        if([controller class] == [REMGalleryCollectionViewController class]){
            currentCollectionController = (REMGalleryCollectionViewController *)controller;
            NSString *controllerKey = currentCollectionController.collectionKey;
            
            REMBuildingModel *building = [self.buildingInfoArray[currentBuildingIndex] building];
            
            if(!REMIsNilOrNull(controllerKey) && [controllerKey isEqualToString:building.province]){
                currentCollectionController = (REMGalleryCollectionViewController *)controller;
                break;
            }
        }
    }
    
    // Find the cell, get its frame and return
    UICollectionViewCell *cell = [currentCollectionController cellForBuilding:[self.buildingInfoArray[currentBuildingIndex] building].buildingId];
    self.currentBuildingIndex = currentBuildingIndex;
    
    return [self getGalleryCollectionCellFrameInGalleryView:cell];
}


-(CGRect)getGalleryCollectionCellFrameInGalleryView:(UICollectionViewCell *)cell
{
    UIView *collectionView = cell.superview;
    CGRect cellFrameInCollectionVIew = cell.frame;
    
    UIView *cycleView = collectionView;
    CGRect cellFrameInGalleryView = cellFrameInCollectionVIew;
    
    while(![cycleView isEqual:self.view]){
        cellFrameInGalleryView = [cycleView convertRect:cellFrameInGalleryView toView: cycleView.superview];
        cycleView = cycleView.superview;
    }
    
    return cellFrameInGalleryView;
}


@end