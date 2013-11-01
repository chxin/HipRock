//
//  REMMapViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/25/13.
//
//

#import "REMMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMBuildingModel.h"
#import "REMBuildingOverallModel.h"
#import "REMBuildingViewController.h"
#import "REMGalleryViewController.h"
#import "REMBuildingEntranceSegue.h"
#import "REMBuildingViewController.h"

#import "REMColumnWidgetWrapper.h"
#import "REMLineWidgetWrapper.h"
#import "REMChartHeader.h"
#import "REMCommonHeaders.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"
#import "REMMarkerBubbleView.h"

@interface REMMapViewController ()

@end

@implementation REMMapViewController{
    GMSMapView *mapView;
}

static BOOL isInitialPresenting = YES;
-(void)setIsInitialPresenting:(BOOL)isInitial
{
    isInitialPresenting = isInitial;
}

- (void)loadView
{
    [super loadView];

    [self.view setFrame:kDMDefaultViewFrame];
    [self loadMapView];
    
    if(mapView != nil){
        [self.view addSubview: mapView];
        [self.view sendSubviewToBack: mapView];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self addButtons];
    
    [self.view.layer insertSublayer:self.titleGradientLayer above:mapView.layer];
    
    [self showMarkers];
}

-(void)addButtons
{
    //add switch button
    UIButton *switchButton = [[UIButton alloc]initWithFrame:kDMCommon_TopLeftButtonFrame];
    [switchButton setBackgroundImage:[UIImage imageNamed:@"Gallery.png"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchButton];
    
    if(self.buildingInfoArray.count <= 0){
        [switchButton setEnabled:NO];
    }
    
    //add customer logo button
    [self.view addSubview:self.customerLogoButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.buildingInfoArray.count>0 && isInitialPresenting == YES){
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(presentBuildingView) userInfo:nil repeats:NO];
    }
}

-(void)showMarkers
{
    for(REMBuildingOverallModel *buildingInfo in self.buildingInfoArray){
        if(buildingInfo == nil || buildingInfo.building== nil)
            continue;
        
        REMBuildingModel *building = buildingInfo.building;
        
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(building.latitude, building.longitude);
        marker.userData = buildingInfo;
        marker.title = building.name;
        marker.snippet = building.code;
        marker.map = mapView;
        marker.flat = NO;
        marker.zIndex = [building.buildingId integerValue];
        
        UIImage *markerIcon = [UIImage imageNamed:@"CommonPin_Normal.png"];
        if(buildingInfo.isQualified != nil && [buildingInfo.isQualified isEqual:[NSNull null]] == NO){
            if([buildingInfo.isQualified intValue] == 1)
                markerIcon = [UIImage imageNamed:@"QualifiedPin_Normal.png"];
            else
                markerIcon = [UIImage imageNamed:@"UnqualifiedPin_Normal.png"];
        }
        marker.icon = markerIcon;
    }
}



-(void)loadMapView
{
    CGRect viewBounds = self.view.bounds;
    CGRect mapViewFrame = CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height);
    
    double defaultLatitude =38.0, defaultLongitude=104.0;
    CGFloat defaultZoomLevel = 4.0;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:defaultLatitude longitude:defaultLongitude zoom:defaultZoomLevel];
    
    mapView = [GMSMapView mapWithFrame:mapViewFrame camera:camera];
    [mapView setCamera:camera];
    mapView.myLocationEnabled = NO;
    mapView.delegate = self;
    mapView.settings.consumesGesturesInView = NO;
    mapView.settings.rotateGestures = NO;
    
    [self updateCamera];
}

-(void)updateCamera
{
    // one building, set the building's location
    if(self.buildingInfoArray.count == 1){
        REMBuildingModel *building = [self.buildingInfoArray[0] building];
        
        [mapView setCamera:[GMSCameraPosition cameraWithLatitude:building.latitude longitude:building.longitude zoom:12]];
    }
    else{// multiple buildings, set the rect
        //northEast and southWest
        UIEdgeInsets visiableBounds = [self getVisiableBounds];
        GMSCoordinateBounds *bounds = [self coordinateBoundsFromEdgeInsets:visiableBounds];
        
        GMSCameraPosition *camera = [mapView cameraForBounds:bounds insets:kDMMap_MapEdgeInsets];
        
        [mapView setCamera:camera];
    }
}

-(UIEdgeInsets)getVisiableBounds
{
    //get the max long,lant and min long,lant
    double maxLongtitude = INT64_MIN, minLongtitude=INT64_MAX, maxLatitude=INT64_MIN, minLatitude=INT64_MAX;
    for(REMBuildingOverallModel *buildingInfo in self.buildingInfoArray){
        if(buildingInfo == nil || buildingInfo.building== nil)
            continue;
        
        REMBuildingModel *building = buildingInfo.building;
        
        maxLongtitude = MAX(maxLongtitude, building.longitude);
        minLongtitude = MIN(minLongtitude, building.longitude);
        maxLatitude = MAX(maxLatitude, building.latitude);
        minLatitude = MIN(minLatitude,  building.latitude);
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

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [mapView stopRendering];
    [mapView clear];
    mapView = nil;
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
        self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
        
        //prepare custom segue parameters
        REMBuildingEntranceSegue *customSegue = (REMBuildingEntranceSegue *)segue;
        [customSegue prepareSegueWithParameter:REMBuildingSegueZoomParamterMake(isInitialPresenting, self.currentBuildingIndex, [self getDestinationZoomRect:self.currentBuildingIndex], self.view.frame)];
        
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
    if(isInitialPresenting == YES)
        isInitialPresenting = NO;
}

-(void)presentGalleryView
{
    [self performSegueWithIdentifier:kSegue_MapToGallery sender:self];
}

-(CGRect)getZoomFrameFromMarker:(GMSMarker *)marker
{
    CGPoint markerPoint = [mapView.projection pointForCoordinate:marker.position];
    return CGRectMake(markerPoint.x, markerPoint.y-40, 5.12, 3.84);
}

-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex
{
//    if(currentBuilding == nil){
//        currentBuilding = self.buildingInfoArray[0];
//    }
    
    for (GMSMarker *marker in mapView.markers) {
        if([[marker.userData building].buildingId isEqualToNumber:[self.buildingInfoArray[currentBuildingIndex] building].buildingId]){
            self.currentBuildingIndex = currentBuildingIndex;
            mapView.selectedMarker = marker;
            return [self getZoomFrameFromMarker: marker];
        }
    }
    
    return CGRectZero;
}


-(int)buildingIndexFromBuilding:(REMBuildingModel *)building
{
    for(int i=0;i<self.buildingInfoArray.count;i++){
        REMBuildingOverallModel *buildingInfo = self.buildingInfoArray[i];
        if([buildingInfo.building.buildingId isEqualToNumber:building.buildingId])
            return i;
    }
    
    return 0;
}

#pragma mark GSMapView delegate

- (BOOL)mapView:(GMSMapView *)view didTapMarker:(GMSMarker *)marker
{
    mapView.selectedMarker = marker;
    return YES;
}

- (void)mapView:(GMSMapView *)view didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self.view setUserInteractionEnabled:NO];
    
    self.initialZoomRect = [self getZoomFrameFromMarker:marker];
    self.currentBuildingIndex = [self buildingIndexFromBuilding:[marker.userData building]];
    
    [self presentBuildingView];
}


-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    REMMarkerBubbleView *bubble = [[REMMarkerBubbleView alloc] initWithMarker:marker];
    
    return bubble;
}

-(void)bubbleTapped:(REMMarkerBubbleView *)bubble
{
    self.initialZoomRect = [self getZoomFrameFromMarker:bubble.marker];

    self.currentBuildingIndex = [self buildingIndexFromBuilding:[bubble.marker.userData building]];
    [self presentBuildingView];
}

#pragma mark - Segue
-(IBAction)unwindSegueToMap:(UIStoryboardSegue *)sender
{
    
}

@end
