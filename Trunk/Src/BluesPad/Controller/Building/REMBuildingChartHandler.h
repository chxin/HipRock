//
//  REMBuildingChartHandler.h
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "REMAverageUsageDataModel.h"

@interface REMBuildingChartHandler : UIViewController

- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame;

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(void))loadCompleted;

@end
