//
//  REMWidgetCell.h
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetCellView.h"
#import "REMWidgetObject.h"
#import "REMDashboardViewController.h"

@class REMDashboardViewController;


@interface REMWidgetCell : UICollectionViewCell

@property (nonatomic) BOOL isInitialized;

- (void) initCellByWidget:(REMWidgetObject *)widget;
- (void) initCellByWidgetTest:(NSString *)widget;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
- (IBAction)detailButtonClick:(UIButton *)sender;

@property  (strong,nonatomic) REMDashboardViewController *dashboardController;

@end
