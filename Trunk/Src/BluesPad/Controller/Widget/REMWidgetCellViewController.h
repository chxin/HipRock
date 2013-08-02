//
//  REMWidgetCellViewController.h
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"



@interface REMWidgetCellViewController : UIViewController

@property (nonatomic,weak) UILabel *widgetTitle;

@property  (nonatomic,weak) UIView *chartView;

@property (nonatomic,strong) REMEnergyViewData *data;

@property (nonatomic,strong) REMWidgetObject *widgetObject;



- (void) initDiagram;


@end
