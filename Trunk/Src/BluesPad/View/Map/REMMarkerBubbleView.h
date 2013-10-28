//
//  REMMarkerBubbleView.h
//  Blues
//
//  Created by 张 锋 on 10/28/13.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface REMMarkerBubbleView : UIControl

- (id)initWithMarker:(GMSMarker *)marker;
- (void)highlight;

@end
