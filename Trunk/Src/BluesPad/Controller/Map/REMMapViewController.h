//
//  REMMapViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "REMControllerBase.h"
@class REMMarkerBubbleView;

@interface REMMapViewController : REMControllerBase<GMSMapViewDelegate>

#pragma mark - Properties
@property (nonatomic,weak) NSArray *buildingInfoArray;
@property (nonatomic) int currentBuildingIndex;

@property (nonatomic) CGRect initialZoomRect;
@property (nonatomic,strong) UIImageView *snapshot;

#pragma mark - Methods
-(void)presentBuildingView;

-(void)bubbleTapped:(REMMarkerBubbleView *)bubble;

-(CGRect)getDestinationZoomRect: (int)currentBuildingIndex;

@end
