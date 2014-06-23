/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMapKitViewController.h
 * Date Created : 张 锋 on 6/13/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "REMControllerBase.h"

@interface REMMapKitViewController : REMControllerBase<MKMapViewDelegate>

#pragma mark - Properties
@property (nonatomic,weak) NSArray *buildingInfoArray;
@property (nonatomic) int currentBuildingIndex;

@property (nonatomic) BOOL isInitialPresenting;

@property (nonatomic) CGRect initialZoomRect;
@property (nonatomic,strong) UIImageView *snapshot;

#pragma mark - Methods
-(CGRect)getDestinationZoomRect: (int)currentBuildingIndex;
-(void)updateView;
-(void)highlightMarker:(int)buildingIndex;
-(void)takeSnapshot;

@end
