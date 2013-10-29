//
//  REMMapViewController.h
//  Blues
//
//  Created by 张 锋 on 9/25/13.
//
//

#import <UIKit/UIKit.h>
#import "REMSplashScreenController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMControllerBase.h"
#import "REMBuildingModel.h"
@class REMGallaryViewController;
@class REMBuildingViewController;
@class REMMarkerBubbleView;

@interface REMMapViewController : REMControllerBase<GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *gallarySwitchButton;

@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,strong) REMSplashScreenController *splashScreenController;
@property (nonatomic,strong) REMBuildingViewController *buildingViewController;

@property (nonatomic,strong) UIImageView *snapshot;
@property (nonatomic) CGRect initialZoomRect;

@property (nonatomic,strong) REMBuildingModel *selectedBuilding;


- (IBAction)gallarySwitchButtonPressed:(id)sender;
-(void)setIsInitialPresenting:(BOOL)isInitial;

-(void)presentBuildingView;

-(CGRect)getCurrentZoomRect:(NSNumber *)currentBuildingId;
-(void)bubbleTapped:(REMMarkerBubbleView *)bubble;

@end
