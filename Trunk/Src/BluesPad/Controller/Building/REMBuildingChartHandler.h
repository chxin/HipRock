//
//  REMBuildingChartHandler.h
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "REMAverageUsageDataModel.h"
#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"

@interface REMBuildingChartHandler : UIViewController

- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame;

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(void))loadCompleted;
- (CPTGraphHostingView*) getHostView;
-(void)longPressedAt:(NSDate*)x;


-(CPTLineStyle *)axisLineStyle;
-(CPTLineStyle *)gridLineStyle;
-(CPTLineStyle *)hiddenLineStyle;
-(CPTTextStyle *)xAxisLabelStyle;
-(CPTTextStyle *)yAxisLabelStyle;

-(NSString *)formatDataValue:(NSNumber *)number;
-(void)startLoadingActivity;
-(void)stopLoadingActivity;


@end
