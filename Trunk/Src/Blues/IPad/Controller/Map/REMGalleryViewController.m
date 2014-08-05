/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryViewController.m
 * Created      : 张 锋 on 9/30/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMGalleryViewController.h"
#import "REMMapKitViewController.h"
#import "REMGalleryCollectionCell.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"
#import "REMStoryboardDefinitions.h"
#import <QuartzCore/QuartzCore.h>
#import "REMBuildingEntranceSegue.h"
#import "REMBuildingViewController.h"
#import "REMGalleryGroupView.h"
#import "REMGalleryCollectionViewController.h"
#import "REMImages.h"
#import "REMGalleryTableView.h"
#import "REMCustomerLogoButton.h"


@interface REMGalleryViewController ()

@property (nonatomic,strong) NSMutableDictionary *buildingGroups;
@property (nonatomic,strong) NSArray *orderedProvinceKeys;
@property (nonatomic,weak) REMGalleryTableView *galleryTableView;
@property (nonatomic) BOOL isSegueNotAnimated;
@property (nonatomic,weak) UIView *customerLogoView;

@end


@implementation REMGalleryViewController

#define REMGalleryTableCellHeight(c) (kDMGallery_GalleryGroupTitleFontSize + kDMGallery_GalleryCollectionViewTopMargin + kDMGallery_GalleryCollectionViewBottomMargin + (ceil((c)/6.0f) * kDMGallery_GalleryCellHeight) + ((ceil((c)/6.0f) - 1) * kDMGallery_GalleryCellVerticleSpace))


-(void)viewDidLoad
{
    //set self styles
    [self stylize];
    
    //add buttons
    [self addButtons];
    
    //process data
    [self groupBuildings];
    
    for (NSString *key in self.orderedProvinceKeys) {
        REMGalleryCollectionViewController *collectionController = [[REMGalleryCollectionViewController alloc] initWithKey:key andBuildingInfoArray:self.buildingGroups[key]];
        [self addChildViewController:collectionController];
    }
    
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
        REMManagedBuildingModel *buildingInfo = self.buildingInfoArray[i];
        
        int index = [self getProvinceIndex:buildingInfo.province];
        
        if(index == -1){
            index = REMProvinceOrder.count-1;
        }
        
        NSString *provinceKey = REMProvinceKeys[index];
        //NSString *province = REMIPadLocalizedString(provinceKey);
        
        NSMutableArray *elements = REMIsNilOrNull(self.buildingGroups[provinceKey]) ? [[NSMutableArray alloc] init] : self.buildingGroups[provinceKey];
        
        [elements addObject:buildingInfo];
        [tempKeys setObject:provinceKey atIndexedSubscript:index];
        
        [self.buildingGroups setObject:elements forKey:provinceKey];
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
    REMCustomerLogoButton *switchButton = [[REMCustomerLogoButton alloc] initWithIcon:REMIMG_Map];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchButton];
    
    UIButton *settingButton=self.settingButton;
    [self.view addSubview:settingButton];
}

-(void)logoPressed
{
    [self switchButtonPressed];
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
    //[tableView registerClass:[REMGalleryGroupView class] forCellReuseIdentifier:kCellIdentifier_GalleryGroupCell];
    
    
//    tableView.layer.borderColor = [UIColor blueColor].CGColor;
//    tableView.layer.borderWidth = 1.0;
    
    self.galleryTableView = tableView;
    [self.view addSubview:self.galleryTableView];
}

-(void)switchButtonPressed
{
    [self performSegueWithIdentifier:kSegue_GalleryToMap sender:self];
}

-(void)scrollToBuildingIndex:(int)currentBuildingIndex
{
    REMGalleryCollectionCell *cell = [self galleryCellForBuildingIndex:currentBuildingIndex];
    
    if(cell.superview.superview.superview!=nil)
        return;
    
    REMManagedBuildingModel *buildingInfo = self.buildingInfoArray[currentBuildingIndex];
    
    int index = 0;
    for(int i=0;i<self.orderedProvinceKeys.count;i++){
        NSString *key = self.orderedProvinceKeys[i];
        if([self.buildingGroups[key] containsObject:buildingInfo]){
            index = i;
            break;
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.galleryTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
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
    
    //REMGalleryGroupView *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GalleryGroupCell forIndexPath:indexPath];
    REMGalleryGroupView *cell = [[REMGalleryGroupView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Nil];
    
    [cell setGroupTitle:REMIPadLocalizedString(key)];
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

+(int)indexOfBuilding:(REMManagedBuildingModel *)building inBuildingOverallArray:(NSArray *)array
{
    return [array indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        REMManagedBuildingModel *buildingOverall = obj;
        
        if([buildingOverall.id isEqualToNumber:building.id]){
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
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
    self.currentBuildingIndex = [REMGalleryViewController indexOfBuilding:cell.building inBuildingOverallArray:self.buildingInfoArray];//  [self buildingIndexFromBuilding:cell.building];
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
    REMManagedBuildingModel *currentBuilding = self.buildingInfoArray[buildingIndex];
    
    REMGalleryCollectionViewController *currentCollectionController = nil;
    
    for(UIViewController *controller in self.childViewControllers){
        if([controller isKindOfClass:[REMGalleryCollectionViewController class]] && [((REMGalleryCollectionViewController *)controller).buildingInfoArray containsObject:currentBuilding]){
            currentCollectionController = (REMGalleryCollectionViewController *)controller;
        }
    }
    
    REMGalleryCollectionCell *cell = [currentCollectionController cellForBuilding:currentBuilding.id];
    
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
    
    if(collectionView.superview.superview == nil){
        return CGRectMake(kDMCommon_ContentLeftMargin, 800, kDMGallery_GalleryCellWidth, kDMGallery_GalleryCellHeight);
        //return [self.galleryTableView convertRect:[self calculateRectForCell:cell] toView:self.view]  ;
    }
    
    return [collectionView convertRect:cellFrameInCollectionView toView:self.view];
    
//    
//    UIView *cycleView = collectionView;
//    CGRect cellFrameInGalleryView = cellFrameInCollectionView;
//    
//    
//    
//    while(![cycleView isEqual:self.view]){
//        cellFrameInGalleryView = [cycleView convertRect:cellFrameInGalleryView toView: cycleView.superview];
//        cycleView = cycleView.superview;
//    }
//    
//    return cellFrameInGalleryView;
}

//-(CGRect)calculateRectForCell:(REMGalleryCollectionCell *)cell
//{
//    NSString *province = cell.building.province;
//    
//    int keyIndex = [self.orderedProvinceKeys indexOfObject:province];
//    int cellIndex = [self.buildingGroups[province] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//        REMBuildingOverallModel *buildingInfo = obj;
//        if([buildingInfo.building isEqual:cell.building]){
//            *stop = YES;
//            return YES;
//        }
//        return NO;
//    }];
//    
//    CGFloat topOffset = 0;
//    if(keyIndex>=1){
//        for(int i=1;i<keyIndex;i++){
//            topOffset += REMGalleryTableCellHeight([self.buildingGroups[self.orderedProvinceKeys[i-1]] count]);
//        }
//    }
//    
//    topOffset += kDMGallery_GalleryGroupTitleFontSize + ((cellIndex/6) * (kDMGallery_GalleryCellVerticleSpace + kDMGallery_GalleryCellHeight));
//    
//    CGFloat leftOffset = (cellIndex % 6)*(self.galleryTableView.frame.size.width / 6);
//    
//    return CGRectMake(leftOffset, topOffset, kDMGallery_GalleryCellWidth, kDMGallery_GalleryCellHeight);
//}

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
