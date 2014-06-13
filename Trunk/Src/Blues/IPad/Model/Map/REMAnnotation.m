/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMarker.m
 * Date Created : 张 锋 on 6/13/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMAnnotation.h"
#import <MapKit/MapKit.h>

@implementation REMAnnotation

+(instancetype)annotationForBuilding:(REMManagedBuildingModel *)building onMap:(MKMapView *)mapView;
{
    REMAnnotation *annotation = [[REMAnnotation alloc] init];
    
    annotation.name = building.name;
    annotation.latitude = [building.latitude doubleValue];
    annotation.longitude = [building.longitude doubleValue];
    
    annotation.coordinate = CLLocationCoordinate2DMake([building.latitude doubleValue], [building.longitude doubleValue]);
    
    annotation.title = building.name;
    
    annotation.building = building;
    
    [mapView addAnnotation:annotation];
    annotation.mapView = mapView;
    
    return annotation;
}

-(UIImage *)icon
{
    NSString *iconName = @"CommonPin_";
    if(!REMIsNilOrNull(self.building.isQualified)){
        iconName = [self.building.isQualified intValue] == 1?@"QualifiedPin_":@"UnqualifiedPin_";
    }
    
    NSString *iconState = self.focused ? @"Focus" : @"Normal";
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@", iconName, iconState];
    
    return REMLoadImageNamed(imageName);
}

-(BOOL)visible
{
    MKMapRect visibleMapRect = self.mapView.visibleMapRect;
    NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:visibleMapRect];
    BOOL annotationIsVisible = [visibleAnnotations containsObject:self];
    
    return !annotationIsVisible;
}


-(CGPoint)point
{
    return [self.mapView convertCoordinate:self.coordinate toPointToView:self.mapView];
}

-(void)select
{
    for(REMAnnotation *annotation in self.mapView.selectedAnnotations){
        [self.mapView deselectAnnotation:annotation animated:YES];
    }
    
    [self.mapView selectAnnotation:self animated:YES];
}


#pragma mark - Private
-(NSString *)iconNameForStatus:(BOOL)focused
{
    NSString *iconName = @"CommonPin_";
    if(!REMIsNilOrNull(self.building.isQualified)){
        iconName = [self.building.isQualified intValue] == 1?@"QualifiedPin_":@"UnqualifiedPin_";
    }
    
    NSString *iconState = focused ? @"Focus" : @"Normal";
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@", iconName, iconState];
    
    return imageName;
}

@end
