/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMapKitViewController.m
 * Date Created : 张 锋 on 6/13/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*/
#import <MapKit/MapKit.h>
#import "REMMapKitViewController.h"
#import "REMBuildingViewController.h"
#import "REMGalleryViewController.h"
#import "REMBuildingEntranceSegue.h"
#import "REMBuildingViewController.h"

#import "DCChartEnum.h"
#import "REMCommonHeaders.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"
#import "REMImages.h"
#import "REMBlurredMapView.h"
#import "REMUpdateAllManager.h"
#import "REMManagedBuildingModel.h"
#import "REMCustomerLogoButton.h"
#import "REMAnnotation.h"
#import "REMManagedBuildingCommodityUsageModel.h"

@interface REMMapKitViewController ()

@property (nonatomic,weak) MKMapView *mapView;

@property (nonatomic,weak) REMCustomerLogoButton *switchButton;
@property (nonatomic,weak) UIView *customerLogoView;
@property (nonatomic,weak) REMBlurredMapView *mask;

@end

@implementation REMMapKitViewController

#define REMMapInitialLocation CLLocationCoordinate2DMake(38.0, 104.0)
#define REMMapInitialAltitude 12000000




#pragma mark - Rendering view

- (void)loadView
{
    [super loadView];
    
    if(self.view){
        [self.view setFrame:kDMDefaultViewFrame];
        
        [self loadMapView];
        [self loadButtons];
    }
}

-(void)loadMapView
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    
    if(REMISIOS7){
        mapView.rotateEnabled = NO;
        mapView.camera = [MKMapCamera cameraLookingAtCenterCoordinate:REMMapInitialLocation fromEyeCoordinate:REMMapInitialLocation  eyeAltitude:REMMapInitialAltitude];
    }
    else{
        mapView.centerCoordinate = REMMapInitialLocation;
    }
    
    [self.view addSubview:mapView];
    
    //add mask layer
    [self.view.layer insertSublayer:self.titleGradientLayer above:self.mapView.layer];
    
    self.mapView = mapView;
}

-(void)loadButtons
{
    //add switch button
    REMCustomerLogoButton *switchButton = [[REMCustomerLogoButton alloc] initWithIcon:REMIMG_Gallery];
    [switchButton addTarget:self action:@selector(switchButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchButton];
    self.switchButton = switchButton;
    
    UIButton *settingButton=self.settingButton;
    [self.view addSubview:settingButton];
}

#pragma mark - Business

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    REMUpdateAllManager *manager = [REMUpdateAllManager defaultManager];
    
    manager.mainNavigationController = (REMMainNavigationController *)self.navigationController;
    [manager updateAllBuildingInfoWithAction:^(REMCustomerUserConcurrencyStatus status, NSArray *buildingInfoArray, REMDataAccessStatus errorStatus) {
        void (^callback)(void) = nil;
        
        if(errorStatus == REMDataAccessSucceed){
            callback =^{ [self updateView]; };
        }
        else{
            callback = ^{ [self.switchButton setEnabled:NO]; };
        }
        
        [mask hide:callback];
    }];
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
    
    [self.switchButton refresh];
    [self initMarkers];
    [self updateCamera];
}



-(void)initMarkers
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSArray *buildings = [self.buildingInfoArray sortedArrayUsingComparator:^NSComparisonResult(REMManagedBuildingModel *b1, REMManagedBuildingModel *b2) {
        return [b1.latitude doubleValue] > [b2.latitude doubleValue] ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    for(int i=0; i<buildings.count; i++){
        REMAnnotation *annotation = [REMAnnotation annotationForBuilding:buildings[i] onMap:self.mapView];
        
        REMManagedBuildingModel *firstBuilding =self.buildingInfoArray[0];
        if([annotation.building.id isEqualToNumber:firstBuilding.id]){
            annotation.focused = YES;
        }
    }
    
    if(self.buildingInfoArray.count>0 && self.isInitialPresenting == YES){
        self.view.userInteractionEnabled = NO;
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(presentBuildingView) userInfo:nil repeats:NO];
    }
}


-(void)updateCamera
{
    // one building, set the building's location
    if(self.buildingInfoArray.count <= 0){
        return;
    }
    
    if(self.buildingInfoArray.count == 1){
        REMManagedBuildingModel *building = self.buildingInfoArray[0];
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([building.latitude doubleValue], [building.longitude doubleValue]);
        
        [self.mapView setCenterCoordinate:coordinate animated:YES];
    }
    else{// multiple buildings, set the rect
        
        //get the max long,lant and min long,lant
        //(maxlat,minlng)-----------------(maxlat,maxlng)
        //      |                               |
        //      |                               |
        //      |                               |
        //(minlat,minlng)-----------------(minlat,maxlng)
        
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in self.mapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
        [self.mapView setVisibleMapRect:zoomRect edgePadding:kDMMap_MapEdgeInsets animated:YES];
    }
}

-(void)presentBuildingView
{
    [self performSegueWithIdentifier:kSegue_MapToBuilding sender:self];
    
    //if is initial, shut off
    if(self.isInitialPresenting == YES)
        self.isInitialPresenting = NO;
}


-(void)highlightMarker:(int)buildingIndex
{
    //if current building was not changed, just return
    if(buildingIndex == self.currentBuildingIndex){
        return;
    }
    
    //else, find the destination annotation
    REMAnnotation *destinationAnnotation = nil;
    for(REMAnnotation *annotation in self.mapView.annotations){
        if([annotation.building isEqual:self.buildingInfoArray[buildingIndex]]){
            destinationAnnotation = annotation;
            break;
        }
    }
    
    //highlight the destination annotation
    [destinationAnnotation select];
}

-(void)takeSnapshot
{
    self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
}


-(CGRect)getDestinationZoomRect:(int)currentBuildingIndex
{
    for (REMAnnotation *annotation in self.mapView.annotations) {
        REMManagedBuildingModel *markBuilding =annotation.building;
        REMManagedBuildingModel *currentBuilding =self.buildingInfoArray[currentBuildingIndex];
        if([markBuilding.id isEqualToNumber:currentBuilding.id]){
            self.currentBuildingIndex = currentBuildingIndex;
            [annotation select];
            return [self zoomFrameForAnnotation:annotation];
        }
    }
    
    return CGRectZero;
}

-(CGRect)zoomFrameForAnnotation:(REMAnnotation *)annotation
{
    return CGRectMake(annotation.point.x, annotation.point.y-35, 1, 1);
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchButtonPressed
{
    [self performSegueWithIdentifier:kSegue_MapToGallery sender:self];
}

#pragma mark - Segue

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


-(IBAction)unwindSegueToMap:(UIStoryboardSegue *)sender
{
    
}


#pragma mark - MKMapView delegates

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *marker = [[MKAnnotationView alloc] init];
    
    marker.annotation = annotation;
    marker.image = ((REMAnnotation *)annotation).icon;
    marker.canShowCallout = YES;
    marker.calloutOffset = CGPointMake(0, -1);
    marker.centerOffset = CGPointMake(0.0f, -marker.frame.size.height/2);
    marker.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeInfoLight];
    
    return marker;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self.view setUserInteractionEnabled:NO];
    self.initialZoomRect = [self zoomFrameForAnnotation:view.annotation];
    self.currentBuildingIndex = [self buildingIndexFromBuilding:((REMAnnotation *)view.annotation).building];
    
    [self presentBuildingView];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    REMAnnotation *annotation = (REMAnnotation *)view.annotation;
    annotation.focused = YES;
    view.image = annotation.icon;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    REMAnnotation *annotation = (REMAnnotation *)view.annotation;
    annotation.focused = NO;
    view.image = annotation.icon;
}

#pragma mark - Private

#pragma mark - IOS7 style

-(UIStatusBarStyle)preferredStatusBarStyle{
    
#if  __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return UIStatusBarStyleLightContent;
#else
    return UIStatusBarStyleDefault;
#endif
}

@end
