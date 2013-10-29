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
@class REMGalleryViewController;
@class REMBuildingViewController;
@class REMMarkerBubbleView;

@interface REMMapViewController : REMControllerBase<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *gallerySwitchButton;

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) REMSplashScreenController *splashScreenController;
@property (nonatomic,strong) REMBuildingViewController *buildingViewController;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic) CGRect initialZoomRect;

@property (nonatomic,strong) REMBuildingModel *selectedBuilding;


- (IBAction)gallerySwitchButtonPressed:(id)sender;
-(void)setIsInitialPresenting:(BOOL)isInitial;

-(void)presentBuildingView;

-(CGRect)getCurrentZoomRect:(NSNumber *)currentBuildingId;
-(void)bubbleTapped:(REMMarkerBubbleView *)bubble;

@end
