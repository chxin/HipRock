//
//  REMMainViewController.h
//  Blues
//
//  Created by TanTan on 7/8/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardMainViewController.h"
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"
#import "REMWidgetMaxViewController.h"

@interface REMMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *dashboardContainer;

- (void)maxDashboardContent:(void(^)(BOOL finished))complete;

-(void)minDashboardContent;

-(void)moveDashboardContent:(CGFloat)x;

@property (nonatomic,weak) NSArray *favoriateDashboard;
@property  (nonatomic,weak) REMEnergyViewData *currentMaxData;
@property (nonatomic,weak) REMWidgetObject *currentWidgetObj;
@end
