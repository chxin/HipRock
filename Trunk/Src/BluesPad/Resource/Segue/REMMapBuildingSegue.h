//
//  REMMapToBuildingSegue.h
//  Blues
//
//  Created by 张 锋 on 10/8/13.
//
//

#import <UIKit/UIKit.h>

@interface REMMapBuildingSegue : UIStoryboardSegue

//This property demostrates whether building view is presenting for the first time after map view loaded
@property (nonatomic) BOOL isInitialPresenting;
@property (nonatomic) CGRect initialZoomRect;
@property (nonatomic) CGRect finalZoomRect;

@property (nonatomic) BOOL isUnwinding;

@end
