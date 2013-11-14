/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartHandler.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMAverageUsageDataModel.h"
#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"
#import "REMError.h"


@interface REMBuildingChartBaseViewController: UIViewController

@property (nonatomic) REMDataStoreType requestUrl;

@property (nonatomic,strong) NSArray *snapshotArray;

- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame;

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

-(void)purgeMemory;

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData;
- (void)loadDataSuccessWithData:(id)data;
- (void)loadDataFailureWithError:(REMError *)error withResponse:(id)response;


-(void)drawLabelWithText:(NSString *)text;
- (CABasicAnimation *) plotAnimation;

@end
