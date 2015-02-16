/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingChartHandler.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMAverageUsageDataModel.h"
#import "REMError.h"
#import "DCTrendWrapper.h"
#import "REMManagedWidgetModel.h"

@interface REMBuildingChartBaseViewController: UIViewController

@property (nonatomic) REMDataStoreType requestUrl;
@property (nonatomic, strong, readonly) DCTrendWrapper* chartWrapper;
@property (nonatomic, strong) REMEnergyViewData* energyViewData;
@property (nonatomic, weak, readonly) UILabel* textLabel;
@property (nonatomic, strong) NSString* wrapperClassName;
@property (nonatomic,weak) REMManagedWidgetModel *widgetInfo;
@property (nonatomic) CGRect viewFrame;
//- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame;

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(id data,REMBusinessErrorInfo *error))loadCompleted;


//-(CPTLineStyle *)axisLineStyle;
//-(CPTLineStyle *)gridLineStyle;
//-(CPTLineStyle *)hiddenLineStyle;
//-(CPTTextStyle *)xAxisLabelStyle;
//-(CPTTextStyle *)yAxisLabelStyle;

-(void)startLoadingActivity;
-(void)stopLoadingActivity;
-(void)prepareShare;
-(void)updateLegendView;
-(void)purgeMemory;

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData;
- (void)loadDataSuccessWithData:(id)data;
- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error withStatus:(REMDataAccessStatus)status;


-(void)drawLabelWithText:(NSString *)text;

-(REMEnergyViewData*)convertData:(id)data;
-(REMEnergyStep)getEnergyStep;
@end
