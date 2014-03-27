/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMapViewController.m
 * Created      : 张 锋 on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMBuildingViewController.h"
#import "REMGalleryViewController.h"
#import "REMBuildingEntranceSegue.h"
#import "REMBuildingViewController.h"

#import "DCChartEnum.h"
#import "REMCommonHeaders.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"
#import "REMMarkerBubbleView.h"
#import "REMImages.h"
#import "REMBlurredMapView.h"
#import "REMUpdateAllManager.h"
#import "REMManagedBuildingModel.h"

@interface REMMapViewController ()

@property (nonatomic,weak) GMSMapView *mapView;
@property (nonatomic,strong) NSMutableArray *markers;
@property (nonatomic,weak) REMBlurredMapView *mask;
@property (nonatomic,weak) UIButton *switchButton;
@property (nonatomic,weak) UIImageView *customerLogoView;

@end

@implementation REMMapViewController

#define REMDefaultMapCamera [GMSCameraPosition cameraWithLatitude:38.0 longitude:104.0 zoom:4.0]


- (void)loadView
{
    [super loadView];
    
    if(self.view){
        [self.view setFrame:kDMDefaultViewFrame];
        
        [self loadMapView];
        [self.view.layer insertSublayer:self.titleGradientLayer above:self.mapView.layer];
        [self loadButtons];
    }
}


- (void)viewDidLoad
{
    //[self showMarkers];
    
    if(self.buildingInfoArray.count>0 && self.isInitialPresenting == YES){
        self.view.userInteractionEnabled = NO;
    }
    
    if(REMAppContext.buildingInfoArray == nil){
        [self loadData];
    }
    else{
        [self updateView];
    }
}

-(void)loadData
{
    REMBlurredMapView *mask = [[REMBlurredMapView alloc] initWithFrame:REMISIOS7 ? CGRectMake(0, 0, kDMScreenWidth, kDMScreenHeight) : CGRectMake(0, -20, kDMScreenWidth, kDMScreenHeight)];
    
    [self.view addSubview:mask];
    
    //begin load data
    REMUpdateAllManager *manager = REMAppContext.sharedUpdateManager;
    
    manager.mainNavigationController = (REMMainNavigationController *)self.navigationController;
    [manager updateAllBuildingInfoWithAction:^(REMCustomerUserConcurrencyStatus status, NSArray *buildingInfoArray, REMDataAccessStatus errorStatus) {
        void (^callback)(void) = nil;
        if(buildingInfoArray != nil){
            callback =^{ [self updateView]; };
        }
        
        [mask hide:callback];
    }];
}

-(void)loadButtons
{
    //add switch button
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (REMISIOS7) {
        switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [switchButton setTintColor:[UIColor whiteColor]];
    }
    [switchButton setFrame:CGRectMake(kDMCommon_TopLeftButtonLeft, REMDMCOMPATIOS7(kDMCommon_TopLeftButtonTop),kDMCommon_TopLeftButtonWidth,kDMCommon_TopLeftButtonHeight)];
    switchButton.adjustsImageWhenHighlighted=NO;
    if (!REMISIOS7) {
        switchButton.showsTouchWhenHighlighted=YES;
    }
    [switchButton setImage:REMIMG_Gallery forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchButton];
    self.switchButton = switchButton;
    
    UIButton *settingButton=self.settingButton;
    [self.view addSubview:settingButton];
}

-(void)updateView
{
    self.currentBuildingIndex = 0;
    self.buildingInfoArray = REMAppContext.buildingInfoArray;
    
    if(self.buildingInfoArray.count <= 0){
        [self.switchButton setEnabled:NO];
        [REMAlertHelper alert:REMIPadLocalizedString(@"Map_NoVisiableBuilding")];
    }
    else{
        [self.switchButton setEnabled:YES];
    }
    
    [self renderCustomerLogo];
    [self updateCamera];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showMarkers) userInfo:nil repeats:NO];
}

-(void)renderCustomerLogo
{
    if(self.customerLogoView != nil){
        [self.customerLogoView removeFromSuperview];
        self.customerLogoView = nil;
    }
    
    //add customer logo button
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:REMAppContext.currentManagedCustomer.logoImage]];
    logoView.frame = CGRectMake(kDMCommon_CustomerLogoLeft,REMDMCOMPATIOS7(kDMCommon_CustomerLogoTop),kDMCommon_CustomerLogoWidth,kDMCommon_CustomerLogoHeight);
    logoView.contentMode = UIViewContentModeLeft | UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoView];
    self.customerLogoView = logoView;
}

-(void)showMarkers
{
    [self.mapView clear];
    
    NSArray *buildings = [self.buildingInfoArray sortedArrayUsingComparator:^NSComparisonResult(REMManagedBuildingModel *b1, REMManagedBuildingModel *b2) {
        return [b1.latitude doubleValue] > [b2.latitude doubleValue] ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    self.markers = [[NSMutableArray alloc] init];
    
    for(int i=0; i<buildings.count; i++){
//        REMBuildingOverallModel *buildingInfo = buildings[i];
//        if(buildingInfo == nil || buildingInfo.building== nil)
//            continue;
        REMManagedBuildingModel *building = buildings[i];
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([building.latitude doubleValue], [building.longitude doubleValue]);
        marker.userData = building;
        marker.title = building.name;
        marker.map = self.mapView;
        marker.flat = NO;
        marker.zIndex = i;
        marker.icon = [self getMarkerIcon:building forMarkerState:UIControlStateNormal];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        REMManagedBuildingModel *firstBuilding =self.buildingInfoArray[0];
        if([building.id isEqualToNumber:firstBuilding.id])
           [self selectMarker:marker];
        
        [self.markers addObject:marker];
    }
    
    if(self.buildingInfoArray.count>0 && self.isInitialPresenting == YES){
        self.view.userInteractionEnabled = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(presentBuildingView) userInfo:nil repeats:NO];
    }
}



-(void)loadMapView
{
    //CGRect viewBounds = self.view.bounds;
    CGRect mapViewFrame = CGRectMake(0, 0, kDMScreenWidth, kDMScreenHeight);
    //CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height);
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:mapViewFrame camera:REMDefaultMapCamera];
    //[mapView setCamera:REMDefaultMapCamera];
    mapView.myLocationEnabled = NO;
    mapView.delegate = self;
    mapView.settings.consumesGesturesInView = NO;
    mapView.settings.rotateGestures = NO;
    
    
    //[self updateCamera:mapView];
    
    [self.view addSubview: mapView];
    [self.view sendSubviewToBack: mapView];
    
    self.mapView = mapView;
}

-(void)updateCamera
{
    // one building, set the building's location
    if(self.buildingInfoArray.count <= 0){
        [self.mapView animateToCameraPosition:REMDefaultMapCamera];
        return;
    }
    
    if(self.buildingInfoArray.count == 1){
        REMManagedBuildingModel *building = self.buildingInfoArray[0];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[building.latitude doubleValue]  longitude:[building.longitude doubleValue] zoom:12];
        
        [self.mapView animateToCameraPosition:camera];
    }
    else{// multiple buildings, set the rect
        //northEast and southWest
        UIEdgeInsets visiableBounds = [self getVisiableBounds];
        GMSCoordinateBounds *bounds = [self coordinateBoundsFromEdgeInsets:visiableBounds];
        
        GMSCameraPosition *camera = [self.mapView cameraForBounds:bounds insets:kDMMap_MapEdgeInsets];
        
        //[mapView setCamera:camera];
        [self.mapView animateToCameraPosition:camera];
    }
}

-(UIEdgeInsets)getVisiableBounds
{
    //get the max long,lant and min long,lant
    double maxLongtitude = INT64_MIN, minLongtitude=INT64_MAX, maxLatitude=INT64_MIN, minLatitude=INT64_MAX;
    for(REMManagedBuildingModel *building in self.buildingInfoArray){
//        if(buildingInfo == nil || buildingInfo.building== nil)
//            continue;
        
        
        maxLongtitude = MAX(maxLongtitude, [building.longitude doubleValue]);
        minLongtitude = MIN(minLongtitude, [building.longitude doubleValue]);
        maxLatitude = MAX(maxLatitude, [building.latitude doubleValue]);
        minLatitude = MIN(minLatitude,  [building.latitude doubleValue]);
    }
    
    BOOL good = maxLongtitude != INT64_MIN && minLongtitude!=INT64_MAX && maxLatitude!=INT64_MIN && minLatitude!=INT64_MAX;
    
    return good ? UIEdgeInsetsMake(maxLatitude, minLongtitude, minLatitude, maxLongtitude) : UIEdgeInsetsZero;
}

-(GMSCoordinateBounds *)coordinateBoundsFromEdgeInsets:(UIEdgeInsets)insets
{
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(insets.top,insets.right);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(insets.bottom, insets.left);
    
    return [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
//    if([[self.navigationController.childViewControllers lastObject] isEqual:self] == NO){
//        //[self.mapView stopRendering];
//        [self.mapView clear];
//        [self.mapView removeFromSuperview];
//        self.mapView = nil;
//        self.view=nil;
//    }
}

- (void)switchButtonPressed
{
    [self presentGalleryView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kSegue_MapToBuilding] == YES)
    {
        //take a snapshot of self
        UIImage *fake = [REMImageHelper imageWithView:self.view];
        self.snapshot = [[UIImageView alloc] initWithImage: fake];
        
        
        
        //prepare custom segue parameters
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(NO, self.currentBuildingIndex, [self getDestinationZoomRect:self.currentBuildingIndex], self.view.frame)];
        
        //prepare destination view controller
        REMBuildingViewController *buildingViewController = customSegue.destinationViewController;
        buildingViewController.fromController = self;
        buildingViewController.buildingInfoArray = self.buildingInfoArray;
        buildingViewController.currentBuildingIndex = self.currentBuildingIndex;
    }
    
    if([segue.identifier isEqualToString:kSegue_MapToGallery]){
        //prepare destination view controller
        REMGalleryViewController *galleryController = segue.destinationViewController;
        galleryController.buildingInfoArray = self.buildingInfoArray;
    }
}

-(void)presentBuildingView
{
    [self performSegueWithIdentifier:kSegue_MapToBuilding sender:self];
    
    //if is initial, shut off
    if(self.isInitialPresenting == YES)
        self.isInitialPresenting = NO;
}

-(void)presentGalleryView
{
    [self performSegueWithIdentifier:kSegue_MapToGallery sender:self];
}

-(CGRect)getZoomFrameFromMarker:(GMSMarker *)marker
{
    CGPoint markerPoint = [self.mapView.projection pointForCoordinate:marker.position];
    return CGRectMake(markerPoint.x, markerPoint.y-40, 5.12, 3.84);
}

-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex
{
//    if(currentBuilding == nil){
//        currentBuilding = self.buildingInfoArray[0];
//    }
    
    for (GMSMarker *marker in self.markers) {
        REMManagedBuildingModel *markBuilding =marker.userData;
        REMManagedBuildingModel *currentBuilding =self.buildingInfoArray[currentBuildingIndex];
        if([markBuilding.id isEqualToNumber:currentBuilding.id]){
            self.currentBuildingIndex = currentBuildingIndex;
            [self selectMarker:marker];
            return [self getZoomFrameFromMarker: marker];
        }
    }
    
    return CGRectZero;
}


-(int)buildingIndexFromBuilding:(REMManagedBuildingModel *)building
{
    for(int i=0;i<self.buildingInfoArray.count;i++){
        REMManagedBuildingModel *buildingInfo = self.buildingInfoArray[i];
        if([buildingInfo.id isEqualToNumber:building.id])
            return i;
    }
    
    return 0;
}

-(UIImage *)getMarkerIcon:(REMManagedBuildingModel *)buildingInfo forMarkerState:(UIControlState)state
{
    NSString *iconName = @"CommonPin_";
    if(buildingInfo.isQualified != nil && [buildingInfo.isQualified isEqual:[NSNull null]] == NO){
        if([buildingInfo.isQualified intValue] == 1)
            iconName = @"QualifiedPin_";
        else
            iconName = @"UnqualifiedPin_";
    }
    
    NSString *iconStateName = @"Normal";
    if(state != UIControlStateNormal){
        iconStateName = @"Focus";
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@", iconName, iconStateName];
    
    return REMLoadImageNamed(imageName);
}

-(void)highlightMarker:(int)buildingIndex
{
    GMSMarker *currentMarker = nil;
    for(GMSMarker *marker in self.markers){
        if([marker.userData isEqual:self.buildingInfoArray[buildingIndex]]){
            currentMarker = marker;
        }
    }
    
    if([self isMarkerVisible:currentMarker] == YES){
        GMSCameraUpdate *update = [GMSCameraUpdate setTarget:currentMarker.position];
        [self.mapView moveCamera:update];
        [self selectMarker:currentMarker];
    }
}

-(BOOL)isMarkerVisible:(GMSMarker *)marker
{
    GMSVisibleRegion visibleRegion = [self.mapView.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:visibleRegion];
    return ![bounds containsCoordinate:marker.position];
}

-(void)takeSnapshot
{
    self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
}

-(void)selectMarker:(GMSMarker *)marker
{
    [self deselectCurrentMarker];
    
    //select
    marker.icon = [self getMarkerIcon:marker.userData forMarkerState:UIControlStateHighlighted];
    self.mapView.selectedMarker = marker;
}

-(void)deselectCurrentMarker
{
    //deselect selected marker
    self.mapView.selectedMarker.icon = [self getMarkerIcon:self.mapView.selectedMarker.userData forMarkerState:UIControlStateNormal];
    self.mapView.selectedMarker = nil;
}



#pragma mark GSMapView delegate

- (BOOL)mapView:(GMSMapView *)view didTapMarker:(GMSMarker *)marker
{
//    GMSMarker *oldMarker = self.mapView.selectedMarker;
//    oldMarker.icon = [self getMarkerIcon:oldMarker.userData forMarkerState:UIControlStateNormal];
//    
//    marker.icon = [self getMarkerIcon:marker.userData forMarkerState:UIControlStateHighlighted];
//    self.mapView.selectedMarker = marker;
    [self selectMarker:marker];

    return YES;
}

- (void)mapView:(GMSMapView *)view didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self.view setUserInteractionEnabled:NO];
    self.initialZoomRect = [self getZoomFrameFromMarker:marker];
    self.currentBuildingIndex = [self buildingIndexFromBuilding:marker.userData ];
    
    [self presentBuildingView];
}


-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    REMMarkerBubbleView *bubble = [[REMMarkerBubbleView alloc] initWithMarker:marker];
    
    return bubble;
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self deselectCurrentMarker];
}

#pragma mark - Segue
-(IBAction)unwindSegueToMap:(UIStoryboardSegue *)sender
{
    
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
