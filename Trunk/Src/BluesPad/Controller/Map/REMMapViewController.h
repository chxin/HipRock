//
//  REMMapViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMControllerBase.h"
#import "REMBuildingModel.h"
#import "REMBuildingOverallModel.h"
@class REMGalleryViewController;
@class REMBuildingViewController;
@class REMMarkerBubbleView;

@interface REMMapViewController : REMControllerBase<GMSMapViewDelegate>

@property (nonatomic,weak) NSArray *buildingInfoArray;
@property (nonatomic,weak) REMBuildingViewController *buildingViewController;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic) CGRect initialZoomRect;

@property (nonatomic) int currentBuildingIndex;


-(void)setIsInitialPresenting:(BOOL)isInitial;

-(void)presentBuildingView;

-(void)bubbleTapped:(REMMarkerBubbleView *)bubble;

-(CGRect)getDestinationZoomRect: (int)currentBuildingIndex;

@end
