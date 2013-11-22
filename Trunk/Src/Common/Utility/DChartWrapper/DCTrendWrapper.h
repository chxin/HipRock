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

@interface DCTrendWrapper : DAbstractChartWrapper<DCContextHRangeObserverProtocal, DCXYChartViewDelegate>

@property (nonatomic, readonly) DCXYChartView* view;
@property (nonatomic, readonly) NSString* defaultSeriesClass;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;
@property (nonatomic, assign) REMCalendarType calenderType;

-(DCTrendWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style;
-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(REMChartStyle*)style;
-(void)updateProcessorRangesFormatter:(REMEnergyStep)step;
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step;
@end
