/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMarkerBubbleView.h
 * Created      : 张 锋 on 10/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "REMMapViewController.h"

@interface REMMarkerBubbleView : UIView

//@property (nonatomic,weak) REMMapViewController *controller;
@property (nonatomic,weak) GMSMarker *marker;

- (id)initWithMarker:(GMSMarker *)marker;

@end
