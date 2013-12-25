/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryViewController.m
 * Created      : 张 锋 on 9/30/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
#import "REMBuildingOverallModel.h"
#import "REMGalleryTableView.h"


@interface REMGalleryViewController ()

@property (nonatomic,strong) NSMutableDictionary *buildingGroups;
@property (nonatomic,strong) NSArray *orderedProvinceKeys;
@property (nonatomic,weak) REMGalleryTableView *galleryTableView;
@property (nonatomic) BOOL isSegueNotAnimated;

@end


@implementation REMGalleryViewController

#define REMGalleryTableCellHeight(c) (kDMGallery_GalleryGroupTitleFontSize + kDMGallery_GalleryCollectionViewTopMargin + kDMGallery_GalleryCollectionViewBottomMargin + ((((c) / 6) + 1) * kDMGallery_GalleryCellHeight) + (((c) / 6) * kDMGallery_GalleryCellVerticleSpace))


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

-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"gallery frame in viewWillAppear:%@", NSStringFromCGRect(self.view.frame));
    
    //self.focusedCell.alpha = 1.0;
}

-(void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"gallery frame in viewDidAppear:%@", NSStringFromCGRect(self.view.frame));
    
}

#pragma mark - Data

-(void)groupBuildings
{
    self.buildingGroups = [[NSMutableDictionary alloc] init];
    int capacity = REMProvinceOrder.count+1;
    NSMutableArray *tempKeys = [[NSMutableArray alloc] initWithCapacity:capacity];
    for(int i=0; i<capacity; i++)
        tempKeys[i] = @(0);
    
    
    for(int i = 0; i<self.buildingInfoArray.count; i++){
        REMBuildingOverallModel *buildingInfo = self.buildingInfoArray[i];
        NSString *province = buildingInfo.building.province;
        
        int index = [self getProvinceIndex:province];
        
        if(index == -1){
            province = @"海外";
            index = REMProvinceOrder.count;
        }
        
        NSMutableArray *elements = REMIsNilOrNull(self.buildingGroups[province]) ? [[NSMutableArray alloc] init] : self.buildingGroups[province];
        
        [elements addObject:buildingInfo];
        [tempKeys setObject:province atIndexedSubscript:index];
        
        [self.buildingGroups setObject:elements forKey:province];
    }
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for(int i=0;i<tempKeys.count;i++){
        if([tempKeys[i] isKindOfClass:[NSNumber class]] == NO)
            [keys addObject:tempKeys[i]];
    }
    
    self.orderedProvinceKeys = keys;
}

-(int)getProvinceIndex:(NSString *)province
{
    if([province isEqual:[NSNull null]] || province == nil || [province isEqualToString:@""])
        return -1;
    
    for(int i=0;i<REMProvinceOrder.count;i++){
        if([province rangeOfString:REMProvinceOrder[i]].length>0)
            return i;
    }
    
    return -1;
}

#pragma mark - Render

-(void)addButtons
{
    //add switch button
    UIButton *switchButton = [[UIButton alloc]initWithFrame:CGRectMake(kDMCommon_TopLeftButtonLeft, REMDMCOMPATIOS7( kDMCommon_TopLeftButtonTop),kDMCommon_TopLeftButtonWidth,kDMCommon_TopLeftButtonHeight)];
    [switchButton setBackgroundImage:REMIMG_Map forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchButton];
    
    //add customer logo button
    UIButton *logoButton = self.customerLogoButton;
    logoButton.frame = CGRectMake(kDMCommon_CustomerLogoLeft,REMDMCOMPATIOS7(kDMCommon_CustomerLogoTop),kDMCommon_CustomerLogoWidth,kDMCommon_CustomerLogoHeight);
    [self.view addSubview:logoButton];
}

-(void)stylize
{
    self.view.frame = kDMDefaultViewFrame;
    self.view.backgroundColor = kDMGallery_BackgroundColor;
}

-(void)addGalleryGroupView
{
    REMGalleryTableView *tableView = [[REMGalleryTableView alloc] initWithFrame:kDMGallery_GalleryTableViewFrame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
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


#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderedProvinceKeys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = self.orderedProvinceKeys[indexPath.row];
    NSArray *array = [self.buildingGroups objectForKey:key];
    
    REMGalleryCollectionViewController *collectionController = nil;
    for(int i=0;i<self.childViewControllers.count;i++){
        UIViewController *controller  = self.childViewControllers[i];
        if([controller isKindOfClass:[REMGalleryCollectionViewController class]] && [((REMGalleryCollectionViewController *)controller).collectionKey isEqualToString:key]){
            collectionController = (REMGalleryCollectionViewController *)controller;
            break;
        }
    }
    
    if(collectionController == nil){
        collectionController = [[REMGalleryCollectionViewController alloc] initWithKey:key andBuildingInfoArray:array];
        [self addChildViewController:collectionController];
    }
    
    REMGalleryGroupView *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GalleryGroupCell forIndexPath:indexPath];
    
    [cell setGroupTitle:key];
    [cell setCollectionView:collectionController.view];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.buildingGroups objectForKey:self.orderedProvinceKeys[indexPath.row]];
    
    return REMGalleryTableCellHeight(array.count);
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
        
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(self.isSegueNotAnimated, self.currentBuildingIndex, self.initialZoomRect, self.view.frame)];
        
        REMBuildingViewController *buildingViewController = customSegue.destinationViewController;
        buildingViewController.buildingInfoArray = self.buildingInfoArray;
        buildingViewController.fromController = self;
        buildingViewController.currentBuildingIndex = self.currentBuildingIndex;
    }
}

//will be called when tap or pinch end
//if tap, isNoAmination parameter will be NO since segue will show the zooming animation
//if pinch end, isNoAmination parameter will be YES since pinch will play zooming animation
-(void)presentBuildingViewFromCell:(REMGalleryCollectionCell *)cell animated:(BOOL)isNoAnimation
{
    if(!isNoAnimation){
        [self.view setUserInteractionEnabled:NO];
    }
    
    CGRect cellFrameInView = [self getGalleryCollectionCellFrameInGalleryView:cell];
    
    self.isSegueNotAnimated = isNoAnimation;
    self.initialZoomRect = cellFrameInView;
    self.currentBuildingIndex = [REMBuildingOverallModel indexOfBuilding:cell.building inBuildingOverallArray:self.buildingInfoArray];//  [self buildingIndexFromBuilding:cell.building];
    if(!isNoAnimation){
        [self takeSnapshot];
    }
    self.focusedCell = cell;
    
    [self performSegueWithIdentifier:kSegue_GalleryToBuilding sender:self];
}

-(IBAction)unwindSegueToGallery:(UIStoryboardSegue *)sender
{
    
}

#pragma mark - Private methods

-(REMGalleryCollectionCell *)galleryCellForBuildingIndex:(int)buildingIndex
{
    REMBuildingModel *currentBuilding = [self.buildingInfoArray[buildingIndex] building];
    
    REMGalleryCollectionViewController *currentCollectionController = nil;
    
    for(UIViewController *controller in self.childViewControllers){
        if([controller isKindOfClass:[REMGalleryCollectionViewController class]]){
            currentCollectionController = (REMGalleryCollectionViewController *)controller;
            NSString *controllerKey = currentCollectionController.collectionKey;
            
            if(!REMIsNilOrNull(controllerKey) && [controllerKey isEqualToString:currentBuilding.province]){
                currentCollectionController = (REMGalleryCollectionViewController *)controller;
                break;
            }
        }
    }
    
    REMGalleryCollectionCell *cell = [currentCollectionController cellForBuilding:currentBuilding.buildingId];
    
    return cell;
}

-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex
{
    REMGalleryCollectionCell *cell = [self galleryCellForBuildingIndex:currentBuildingIndex];
    
    self.currentBuildingIndex = currentBuildingIndex;
    
    self.focusedCell = cell;
    
    return [self getGalleryCollectionCellFrameInGalleryView:cell];
}

-(CGRect)getGalleryCollectionCellFrameInGalleryView:(REMGalleryCollectionCell *)cell
{
    UIView *collectionView = cell.superview;
    CGRect cellFrameInCollectionView = cell.frame;
    
    
    
    //UIView *cycleView = collectionView;
    //CGRect cellFrameInGalleryView = cellFrameInCollectionView;
    
    CGRect cellFrameInGalleryView = [collectionView convertRect:cellFrameInCollectionView toView:self.view];
    
    if([[collectionView superview] superview]==nil){
        //int index  = [self.orderedProvinceKeys indexOfObject:cell.controller.collectionKey];
        return CGRectMake(kDMCommon_ContentLeftMargin, 800, kDMGallery_GalleryCellWidth, kDMGallery_GalleryCellHeight);
    }
    
//    while(![cycleView isEqual:self.view] && cycleView!=nil){
//        cellFrameInGalleryView = [cycleView convertRect:cellFrameInGalleryView toView: cycleView.superview];
//        cycleView = cycleView.superview;
//    }
    
    return cellFrameInGalleryView;
}

-(void)takeSnapshot
{
    self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
}


#pragma mark - IOS7 style
-(UIStatusBarStyle)preferredStatusBarStyle{
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return UIStatusBarStyleLightContent;
#else
    return UIStatusBarStyleDefault;
#endif
}

@end
