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

@interface REMMapViewController ()

@end

@implementation REMMapViewController{
    GMSMapView *mapView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    double defaultLatitude =38, defaultLongitude=104.0;
    CGFloat defaultZoomLevel = 4;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:defaultLatitude longitude:defaultLongitude zoom:defaultZoomLevel];
    
    mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    mapView.myLocationEnabled = NO;
    [self.view addSubview: mapView];
    
    NSLog(@"%d",self.buildingInfoArray.count);
    [self initializeMapView];
    
    //[self initializeButtons];
}

-(void)initializeMapView
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
        marker.title = building.name;
        marker.snippet = building.code;
        marker.map = mapView;
    }
    
    NSLog(@"%f,%f,%f,%f", maxLatitude, minLongtitude, minLatitude, maxLongtitude);
    
    if(maxLongtitude != INT64_MIN && minLongtitude!=INT64_MAX && maxLatitude!=INT64_MIN && minLatitude!=INT64_MAX){
        //northEast and southWest
        CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(maxLatitude,maxLongtitude);
        CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(minLatitude, minLongtitude);
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast coordinate:southWest];
        
        NSLog(@"%d",bounds.isValid);
        
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:10.0f];
        
        [mapView animateWithCameraUpdate:update];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    mapView = nil;
}

- (IBAction)jumpToBuildingViewButtonPressed:(id)sender {
    [self performSegueWithIdentifier:kMapToBuildingSegue sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kMapToBuildingSegue] == YES)
    {
        REMBuildingViewController *buildingViewController = segue.destinationViewController;
        buildingViewController.buildingOverallArray = self.buildingInfoArray;
        buildingViewController.splashScreenController = self.splashScreenController;
    }
}


@end
