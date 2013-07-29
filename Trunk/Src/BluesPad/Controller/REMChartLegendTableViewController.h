//
//  REMChartLegendTableViewController.h
//  Blues
//
//  Created by 张 锋 on 7/18/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetMaxViewController.h"
#import "REMWidgetMaxDiagramViewController.h"

@interface REMChartLegendTableViewController : UITableViewController

@property (nonatomic,strong) UIPopoverController *popoverViewController;
@property (nonatomic,strong) id maxViewController;
@property (nonatomic,strong) REMWidgetMaxDiagramViewController *chartController;
@property (nonatomic,weak) NSArray *targetEnergyData;

@end
