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
#import "REMWidgetContentSyntax.h"
#import "DCColumnSeries.h"
#import "DCLineSeries.h"
#import "DCContext.h"
#import "REMChartHeader.h"  // FOR IMPORT REMChartDataProcessor only
#import "DCXYChartViewDelegate.h"
#import "REMCommonHeaders.h"

@interface DCTrendWrapper : DAbstractChartWrapper<DCXYChartViewDelegate>

@property (nonatomic, readonly) DCXYChartView* view;
@property (nonatomic, readonly) NSString* defaultSeriesClass;
@property (nonatomic, assign) REMCalendarType calenderType;
@property (nonatomic, assign, readonly) BOOL isStacked;
@property (nonatomic, strong, readonly) NSMutableArray* processors;
@property (nonatomic, strong, readonly) REMTrendChartDataProcessor* sharedProcessor;

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(REMChartStyle*)style;
-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step;
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step;
-(void)customizeView:(DCXYChartView*)view;
@end
