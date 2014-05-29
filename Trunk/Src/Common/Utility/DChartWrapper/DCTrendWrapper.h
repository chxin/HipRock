//
//  DTrendChartWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DAbstractChartWrapper.h"
#import "DCXYChartView.h"
#import "DCChartStyle.h"
#import "REMEnergyViewData.h"
#import "DCColumnSeries.h"
#import "DCLineSeries.h"
#import "DCContext.h"
#import "DCChartEnum.h"  // FOR IMPORT REMChartDataProcessor only
#import "DCXYChartViewDelegate.h"
#import "REMCommonHeaders.h"
#import "DCTrendAnimationDelegate.h"
#import "DWrapperConfig.h"
#import "DCTrendChartDataProcessor.h"
#import "DCChartTrendWrapperDelegate.h"

@interface DCTrendWrapper : DAbstractChartWrapper<DCXYChartViewDelegate, DCTrendAnimationDelegate>

@property (nonatomic, readonly) DCXYChartView* view;
@property (nonatomic, readonly) NSString* defaultSeriesClass;
@property (nonatomic, strong, readonly) NSMutableArray* processors;
@property (nonatomic, strong, readonly) DCTrendChartDataProcessor* sharedProcessor;
@property (nonatomic,strong) DWrapperConfig* wrapperConfig;

-(BOOL)isSpecialType:(REMEnergyTargetType)type; // 一定被绘制成线图的Target类型，默认是REMEnergyTargetBenchmarkValue。Override

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(DCChartStyle*)style;
-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step;
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step;
-(void)customizeView:(DCXYChartView*)view;
-(NSUInteger)getSeriesAmount;
-(void)switchSeriesTypeAtIndex:(NSUInteger)index;
-(BOOL)canBeChangeSeriesAtIndex:(NSUInteger)index;
-(void)updateCalendarType:(REMCalendarType)calenderType;
@end
