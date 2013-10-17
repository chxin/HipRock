//
//  REMMapViewController.m
//  Blues
//
//  Created by 张 锋 on 9/25/13.
//
//

#import "REMMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMBuildingModel.h"
#import "REMBuildingOverallModel.h"
#import "REMBuildingViewController.h"
#import "REMGallaryViewController.h"
#import "REMMapBuildingSegue.h"
#import "REMBuildingViewController.h"

#import "REMColumnWidgetWrapper.h"
#import "REMLineWidgetWrapper.h"
#import "REMChartHeader.h"
#import "REMCommonHeaders.h"
#import "REMStoryboardDefinitions.h"
#import "REMDimensions.h"

@interface REMMapViewController ()

@property (nonatomic,strong) GMSMarker *pressedMarker;

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

    [self.view setFrame:CGRectMake(0, 0, kDMScreenWidth, kDMScreenHeight)];
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
    
    [self showMarkers];
    
    
    [self.view addSubview:self.customerLogoButton];
    [self.view.layer insertSublayer:self.titleGradientLayer above:mapView.layer];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(isInitialPresenting == YES){
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(presentBuildingView) userInfo:nil repeats:NO];
    }
}

-(void)showMarkers
{
    for(REMBuildingOverallModel *buildingInfo in self.buildingInfoArray){
        if(buildingInfo == nil || buildingInfo.building== nil)
            continue;
        
        REMBuildingModel *building = buildingInfo.building;
        
        UIColor *markerColor = [UIColor orangeColor];
        if(buildingInfo.isQualified != nil && [buildingInfo.isQualified isEqual:[NSNull null]] == NO){
            if([buildingInfo.isQualified intValue] == 1)
                markerColor = [UIColor greenColor];
            else
                markerColor = [UIColor redColor];
        }
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(building.latitude, building.longitude);
        marker.userData = building;
        marker.title = building.name;
        marker.snippet = building.code;
        marker.map = mapView;
        marker.icon = [GMSMarker markerImageWithColor:markerColor];
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
    
    GMSCameraUpdate *update = [self getCameraUpdate];
    
    [mapView moveCamera:update];
    
    sleep(1);
}

-(GMSCameraUpdate *)getCameraUpdate
{
    // one building, return the building's location
    if(self.buildingInfoArray.count == 1){
        REMBuildingModel *building = [self.buildingInfoArray[0] building];
        CLLocationCoordinate2D target = CLLocationCoordinate2DMake(building.latitude, building.longitude);
        
        return [GMSCameraUpdate setTarget:target zoom:12];
    }
    
    // multiple buildings, return the rect
    GMSCameraUpdate *update = nil;
    
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
    
    if(maxLongtitude != INT64_MIN && minLongtitude!=INT64_MAX && maxLatitude!=INT64_MIN && minLatitude!=INT64_MAX){
        //northEast and southWest
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(maxLatitude,maxLongtitude);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(minLatitude, minLongtitude);
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
        
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
        
        [mapView moveCamera:update];
    }
    
    return update;
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    mapView = nil;
}

- (IBAction)gallarySwitchButtonPressed:(id)sender
{
    [self presentGallaryView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kSegue_MapToBuilding] == YES)
    {
        REMMapBuildingSegue *customeSegue = (REMMapBuildingSegue *)segue;
        customeSegue.isInitialPresenting = isInitialPresenting;
        
        if(self.pressedMarker != nil){
            CGPoint markerPoint = [mapView.projection pointForCoordinate:self.pressedMarker.position];
            self.originalPoint = CGPointMake(markerPoint.x, markerPoint.y-40);
        }
        else{
            self.originalPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        }
        
        self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
        
        REMBuildingViewController *buildingViewController = customeSegue.destinationViewController;
        buildingViewController.buildingOverallArray = self.buildingInfoArray;
        buildingViewController.splashScreenController = self.splashScreenController;
        buildingViewController.mapViewController = self;
        buildingViewController.currentBuildingId = ((REMBuildingModel *)self.pressedMarker.userData).buildingId;
    }
}

-(void)presentBuildingView
{
    [self performSegueWithIdentifier:kSegue_MapToBuilding sender:self];
    
    //if is initial, shut off
    if(isInitialPresenting == YES)
        isInitialPresenting = NO;
}

-(void)presentGallaryView
{
    if(self.gallaryViewController == nil){
        self.gallaryViewController = [[REMGallaryViewController alloc] init];
    }
    
    self.gallaryViewController.originalFrame = self.gallarySwitchButton.frame;
    self.gallaryViewController.viewFrame = self.view.bounds;
    
    [self addChildViewController:self.gallaryViewController];
    [self.view addSubview:self.gallaryViewController.view];
}


#pragma mark GSMapView delegate

- (BOOL)mapView:(GMSMapView *)view didTapMarker:(GMSMarker *)marker
{
    mapView.selectedMarker = marker;
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    self.pressedMarker = marker;
    [self presentBuildingView];
}


@end
