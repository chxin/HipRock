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


@interface REMGalleryViewController ()

@property (nonatomic,strong) NSMutableDictionary *buildingGroups;
@property (nonatomic,weak) UITableView *galleryTableView;
@property (nonatomic) BOOL isSegueAnimated;
@property (nonatomic,weak) REMGalleryCollectionCell *focusedCell;

@end


/*Group order
 北京
 上海
 天津
 重庆
 /按首字母排列其他省/
 /按首字母排列其他自治区/
 香港特别行政区
 澳门特别行政区
 台湾地区
 */

@implementation REMGalleryViewController


-(void)loadView
{
    [super loadView];
    
    //NSLog(@"gallery frame in loadView:%@", NSStringFromCGRect(self.view.frame));
}


-(void)viewDidLoad
{
    //NSLog(@"gallery frame in viewDidLoad:%@", NSStringFromCGRect(self.view.frame));
    
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
}

-(void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"gallery frame in viewDidAppear:%@", NSStringFromCGRect(self.view.frame));
}

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
    UITableView *tableView = [[UITableView alloc] initWithFrame:kDMGallery_GalleryTableViewFrame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [tableView registerClass:[REMGalleryGroupView class] forCellReuseIdentifier:kCellIdentifier_GalleryGroupCell];
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
        
        for(int i=0;i<REMProvinceOrder.count;i++){
            NSString *province = REMProvinceOrder[i];
            NSMutableArray *buildings = [[NSMutableArray alloc] init];
            
            for (REMBuildingOverallModel *buildingInfo in self.buildingInfoArray) {
                if(!REMIsNilOrNull(buildingInfo.building.province) && [buildingInfo.building.province rangeOfString:province].length>0){
                    [buildings addObject:buildingInfo];
                }
            }
            
            if(buildings.count > 0){
                [self.buildingGroups setObject:buildings forKey:province];
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

-(void)uncoverCell
{
    if(self.focusedCell != nil){
        [self.focusedCell uncoverMe];
    }
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
    
    //REMGalleryGroupView *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GalleryGroupCell forIndexPath:indexPath];
    CGFloat y = tableView.frame.origin.y;
    for(int i=0; i<indexPath.row-1; i++){
        y += [self getGalleryGroupCellFrame:[self.buildingGroups[[self.buildingGroups allKeys][indexPath.row]] count]].size.height;
    }
    
    CGRect cellFrame = CGRectMake(tableView.frame.origin.x, y, tableView.frame.size.width, [self getGalleryGroupCellFrame:array.count].size.height);
    REMGalleryGroupView *cell = [[REMGalleryGroupView alloc] initWithFrame:cellFrame];
    
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
        
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(self.isSegueAnimated, self.currentBuildingIndex, self.initialZoomRect, self.view.frame)];
        
        REMBuildingViewController *buildingViewController = customSegue.destinationViewController;
        buildingViewController.buildingInfoArray = self.buildingInfoArray;
        buildingViewController.fromController = self;
        buildingViewController.currentBuildingIndex = self.currentBuildingIndex;
    }
}

-(void)presentBuildingViewFromCell:(REMGalleryCollectionCell *)cell animated:(BOOL)isAnimated
{
    //[self.view setUserInteractionEnabled:NO];
    self.focusedCell = cell;
    
    CGRect cellFrameInView = [self getGalleryCollectionCellFrameInGalleryView:cell];
    
    self.isSegueAnimated = isAnimated;
    self.initialZoomRect = cellFrameInView;
    self.currentBuildingIndex = [self buildingIndexFromBuilding:cell.building];
    if(!isAnimated){
        self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
    }
    
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

#pragma mark - IOS7 style

-(UIStatusBarStyle)preferredStatusBarStyle{
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return UIStatusBarStyleLightContent;
#else
    return UIStatusBarStyleDefault;
#endif
}

@end
