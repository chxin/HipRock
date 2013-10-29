//
//  REMMarkerBubbleView.h
//  Blues
//
//  Created by 张 锋 on 10/28/13.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "REMMapViewController.h"

@interface REMMarkerBubbleView : UIView

@property (nonatomic,weak) REMMapViewController *controller;
@property (nonatomic,weak) GMSMarker *marker;

- (id)initWithMarker:(GMSMarker *)marker;
- (void)highlight;

@end
