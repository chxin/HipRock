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

@interface REMMapViewController ()

@property (nonatomic,strong) GMSMarker *pressedMarker;

@end

@implementation REMMapViewController{
    GMSMapView *mapView;
}

- (void)loadView
{
    [super loadView];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self loadMapView];
}

-(void)loadMapView
{
    CGRect viewBounds = self.view.bounds;
    CGRect mapViewFrame = CGRectMake(viewBounds.origin.x, viewBounds.origin.y, viewBounds.size.height, viewBounds.size.width);
    
    double defaultLatitude =38.0, defaultLongitude=104.0;
    CGFloat defaultZoomLevel = 4.0;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:defaultLatitude longitude:defaultLongitude zoom:defaultZoomLevel];
    
    mapView = [GMSMapView mapWithFrame:mapViewFrame camera:camera];
    [mapView setCamera:camera];
    mapView.myLocationEnabled = NO;
    mapView.delegate = self;
    
    [self.view addSubview: mapView];
    [self.view sendSubviewToBack: mapView];
    
    [self mapViewLoaded];
    
    //TODO: remove when test finishes
    //[self oscarChartTest];
}

-(void)mapViewLoaded
{
    double maxLongtitude = INT64_MIN, minLongtitude=INT64_MAX, maxLatitude=INT64_MIN, minLatitude=INT64_MAX;
    
    if(self.buildingInfoArray.count < 1){ // no building
    }
    
    if(self.buildingInfoArray.count == 1){ // one building
        REMBuildingModel *building = [self.buildingInfoArray[0] building];
        CLLocationCoordinate2D target = CLLocationCoordinate2DMake(building.latitude, building.longitude);
        GMSCameraUpdate *update = [GMSCameraUpdate setTarget:target zoom:12];
        [mapView animateWithCameraUpdate:update];
    }
    
    if(self.buildingInfoArray.count > 1){ // two and more buildings
        
    }
    
    for(REMBuildingOverallModel *buildingInfo in self.buildingInfoArray){
        if(buildingInfo == nil || buildingInfo.building== nil)
            continue;
        
        REMBuildingModel *building = buildingInfo.building;
        
        maxLongtitude = MAX(maxLongtitude, building.longitude);
        minLongtitude = MIN(minLongtitude, building.longitude);
        maxLatitude = MAX(maxLatitude, building.latitude);
        minLatitude = MIN(minLatitude,  building.latitude);
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(building.latitude, building.longitude);
        marker.userData = building;
        marker.title = building.name;
        marker.snippet = building.code;
        marker.map = mapView;
    }
    
    if(maxLongtitude != INT64_MIN && minLongtitude!=INT64_MAX && maxLatitude!=INT64_MIN && minLatitude!=INT64_MAX){
        //northEast and southWest
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(maxLatitude,maxLongtitude);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(minLatitude, minLongtitude);
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
        
        NSLog(@"%d",bounds.isValid);
        
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:50.0f];
        
        [mapView animateWithCameraUpdate:update];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"test");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    mapView = nil;
}

- (IBAction)gallarySwitchButtonPressed:(id)sender
{
    if(self.gallaryViewController == nil){
        self.gallaryViewController = [[REMGallaryViewController alloc] init];
    }
    
    self.gallaryViewController.originalFrame = self.gallarySwitchButton.frame;
    self.gallaryViewController.viewFrame = self.view.bounds;
    
    [self addChildViewController:self.gallaryViewController];
    [self.view addSubview:self.gallaryViewController.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kMapToBuildingSegue] == YES)
    {
        REMMapBuildingSegue *customeSegue = (REMMapBuildingSegue *)segue;
        
        CGPoint markerPoint = [mapView.projection pointForCoordinate:self.pressedMarker.position];
        self.originalPoint = markerPoint;
        self.snapshot = [[UIImageView alloc] initWithImage: [REMImageHelper imageWithView:self.view]];
        
        REMBuildingViewController *buildingViewController = customeSegue.destinationViewController;
        buildingViewController.buildingOverallArray = self.buildingInfoArray;
        buildingViewController.splashScreenController = self.splashScreenController;
        buildingViewController.mapViewController = self;
    }
}

-(void)oscarChartTest
{
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.type = @"line";
    syntax.step = [NSNumber numberWithInt: REMEnergyStepHour];

    REMEnergyViewData* energyViewData = [[REMEnergyViewData alloc]init];
    NSMutableArray* sereis = [[NSMutableArray alloc]init];
    for (int sIndex = 0; sIndex < 3; sIndex++) {
        NSMutableArray* energyDataArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < 100; i++) {
            REMEnergyData* data = [[REMEnergyData alloc]init];
            data.quality = REMEnergyDataQualityGood;
            data.dataValue = [NSNumber numberWithInt:(i+1)*10*(sIndex+1)];
            data.localTime = [NSDate dateWithTimeIntervalSince1970:i*3600];
            [energyDataArray addObject:data];
        }
        REMTargetEnergyData* sData = [[REMTargetEnergyData alloc]init];
        sData.energyData = energyDataArray;
        [sereis addObject:sData];
    }
    energyViewData.targetEnergyData = sereis;

    REMColumnWidgetWrapper* columnWidget = [[REMColumnWidgetWrapper alloc]initWithFrame:CGRectMake(0, 0, 500, 300) data:energyViewData widgetContext:syntax];
    [self.view addSubview:columnWidget.view];
    [columnWidget destroyView];
    REMLineWidgetWrapper* lineWidget = [[REMLineWidgetWrapper alloc]initWithFrame:CGRectMake(600, 0, 500, 300) data:energyViewData widgetContext:syntax];
    [self.view addSubview:lineWidget.view];
    [lineWidget destroyView];
}

#pragma mark GSMapView delegate
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    return NO;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    self.pressedMarker = marker;
    [self performSegueWithIdentifier:kMapToBuildingSegue sender:self];
}


@end
