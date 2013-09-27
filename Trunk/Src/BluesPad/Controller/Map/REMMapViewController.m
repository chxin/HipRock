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

@interface REMMapViewController ()

@end

@implementation REMMapViewController{
    GMSMapView *mapView;
}

- (void)loadView {
    double defaultLatitude =38, defaultLongitude=104.0;
    CGFloat defaultZoomLevel = 4.5;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:defaultLatitude longitude:defaultLongitude zoom:defaultZoomLevel];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = NO;
    self.view = mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"%d",self.buildingInfoArray.count);
    [self initializeMapView];
}

-(void)initializeMapView
{
    double maxLongtitude = INT64_MIN, minLongtitude=INT64_MAX, maxLatitude=INT64_MIN, minLatitude=INT64_MAX;
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
    
    NSLog(@"%f,%f,%f,%f",maxLongtitude,minLongtitude,maxLatitude,minLatitude);
    
    if(maxLongtitude != INT64_MIN && minLongtitude!=INT64_MAX && maxLatitude!=INT64_MIN && minLatitude!=INT64_MAX){
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(maxLatitude,maxLongtitude) coordinate:CLLocationCoordinate2DMake(minLatitude, minLongtitude)];
        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
        
        [mapView animateWithCameraUpdate:update];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    mapView = nil;
}

@end
