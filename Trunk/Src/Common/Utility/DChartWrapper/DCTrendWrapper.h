//
//  DTrendChartWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DAbstractChartWrapper.h"
#import "DCXYChartView.h"
#import "REMChartStyle.h"
#import "REMEnergyViewData.h"
#import "DCColumnSeries.h"
#import "DCLineSeries.h"
#import "DCContext.h"
#import "REMChartHeader.h"  // FOR IMPORT REMChartDataProcessor only
#import "DCXYChartViewDelegate.h"
#import "REMCommonHeaders.h"
#import "DCTrendAnimationDelegate.h"
#import "DWrapperConfig.h"

@interface DCTrendWrapper : DAbstractChartWrapper<DCXYChartViewDelegate, DCTrendAnimationDelegate>

@property (nonatomic, readonly) DCXYChartView* view;
@property (nonatomic, readonly) NSString* defaultSeriesClass;
@property (nonatomic, assign) REMCalendarType calenderType;
@property (nonatomic, assign, readonly) BOOL isStacked;
@property (nonatomic, strong, readonly) NSMutableArray* processors;
@property (nonatomic, strong, readonly) REMTrendChartDataProcessor* sharedProcessor;
@property (nonatomic, assign, readonly) BOOL isUnitOrRatioChart;
@property (nonatomic, assign) BOOL drawHCBackground;

-(BOOL)isSpecialType:(REMEnergyTargetType)type; // 一定被绘制成线图的Target类型，默认是REMEnergyTargetBenchmarkValue。Override

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(REMChartStyle*)style;
-(NSDictionary*)updateProcessorRangesFormatter:(DWrapperConfig*)wrapperConfig;
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step;
-(void)customizeView:(DCXYChartView*)view;
-(NSUInteger)getSeriesAmount;
@end
