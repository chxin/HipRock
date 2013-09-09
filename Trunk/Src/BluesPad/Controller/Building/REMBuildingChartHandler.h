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
#import "REMError.h"


@interface REMBuildingChartHandler : UIViewController

@property (nonatomic) REMDataStoreType requestUrl;

- (REMBuildingChartHandler *)initWithViewFrame:(CGRect)frame;

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(REMError *error))loadCompleted;
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
-(void)prepareShare;

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData;
- (void)loadDataSuccessWithData:(id)data;
- (void)loadDataFailureWithError:(REMError *)error withResponse:(id)response;


-(void)drawNoDataLabel;

@end
