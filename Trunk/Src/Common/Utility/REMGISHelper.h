//
//  GISHelper.h
//  Blues
//
//  Created by 张 锋 on 7/25/14.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (China)
- (CLLocation*)_applyChinaLocationShift:(CLLocation*)arg;
- (BOOL)chinaShiftEnabled;
+ (id)sharedLocationManager;
@end

@interface REMGISHelper : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
+(CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)gcjLoc;
//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
