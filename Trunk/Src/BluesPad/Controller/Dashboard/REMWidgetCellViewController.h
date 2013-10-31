//
//  REMWidgetCellViewController.h
//  Blues
//
//  Created by tantan on 10/29/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"

@interface REMWidgetCellViewController : UIViewController

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic) NSUInteger currentIndex;


@property (nonatomic,strong) REMEnergyViewData *chartData;
@property (nonatomic) CGRect viewFrame;
@end
