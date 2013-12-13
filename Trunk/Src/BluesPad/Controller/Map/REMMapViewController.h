/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMapViewController.h
 * Created      : 张 锋 on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "REMControllerBase.h"
@class REMMarkerBubbleView;

@interface REMMapViewController : REMControllerBase<GMSMapViewDelegate>

#pragma mark - Properties
@property (nonatomic,weak) NSArray *buildingInfoArray;
@property (nonatomic) int currentBuildingIndex;

@property (nonatomic) BOOL isInitialPresenting;

@property (nonatomic) CGRect initialZoomRect;
@property (nonatomic,strong) UIImageView *snapshot;

#pragma mark - Methods
-(CGRect)getDestinationZoomRect: (int)currentBuildingIndex;

@end
