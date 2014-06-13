/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMarker.h
 * Date Created : 张 锋 on 6/13/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "REMManagedBuildingModel.h"

@interface REMAnnotation : NSObject<MKAnnotation>

@property (nonatomic,strong) NSString *name;
@property (nonatomic) double latitude, longitude;
@property (nonatomic,weak) REMManagedBuildingModel *building;
@property (nonatomic,weak) MKMapView *mapView;
@property (nonatomic) UIImage *icon;
@property (nonatomic) BOOL focused;
@property (nonatomic) BOOL visiable;
@property (nonatomic) CGPoint point; //in mapview


@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

+(instancetype)annotationForBuilding:(REMManagedBuildingModel *)building onMap:(MKMapView *)mapView;

-(void)select;

@end
