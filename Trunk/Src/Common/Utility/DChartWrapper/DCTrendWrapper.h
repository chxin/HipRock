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
//@property (nonatomic, assign) DCSeriesTypeStatus defaultSeriesType;
@property (nonatomic, strong, readonly) NSMutableArray* processors;
@property (nonatomic, strong, readonly) DCTrendChartDataProcessor* sharedProcessor;

-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step;
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step;
-(void)switchSeriesTypeAtIndex:(NSUInteger)index;
-(BOOL)canBeChangeSeriesAtIndex:(NSUInteger)index;
-(void)updateCalendarType:(REMCalendarType)calenderType;


-(void)customizeView:(DCXYChartView*)view;
-(NSUInteger)getSeriesAmount;
-(DCLineSymbolType)getSymbolTypeByIndex:(NSUInteger)index;
@end
