//
//  REMWidgetDetailViewController.h
//  Blues
//
//  Created by tantan on 10/29/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMEnergyViewData.h"
#import "REMEnum.h"


@interface REMWidgetDetailViewController : UIViewController

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,weak) REMEnergyViewData *energyData;

@property (nonatomic,strong) NSString *groupName;

@end
