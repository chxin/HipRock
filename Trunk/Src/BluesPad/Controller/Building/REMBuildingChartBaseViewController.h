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
#import "REMWidgetObject.h"

@interface REMBuildingChartBaseViewController: UIViewController

@property (nonatomic) REMDataStoreType requestUrl;
@property (nonatomic) CGRect viewFrame;

@property (nonatomic,weak) REMWidgetObject *widgetInfo;

- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame;

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(id data,REMBusinessErrorInfo *error))loadCompleted;
- (CPTGraphHostingView*) getHostView;


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
- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error ;


-(void)drawLabelWithText:(NSString *)text;
- (CABasicAnimation *) plotAnimation;

@end
