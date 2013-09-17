//
//  REMTrendChart.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/12/13.
//
//

#import <Foundation/Foundation.h>
#import "REMWidgetObject.h"
#import "REMEnergyData.h"
#import "CorePlot-CocoaTouch.h"
#import "REMBuildingConstants.h"


typedef enum  {
    REMTrendChartSeriesTypeColumn,
    REMTrendChartSeriesTypeLine
} REMTrendChartSeriesType;



@interface REMTrendChartPoint : NSObject

@property (nonatomic,readonly) float x;
@property (nonatomic,readonly) NSNumber* y;
@property (nonatomic,readonly) REMEnergyData* energyData;

-(REMTrendChartPoint*)initWithX:(float)x y:(NSNumber*)y point:(REMEnergyData*)p;

@end











@interface REMTrendChartDataProcessor : NSObject

-(REMTrendChartPoint*)processEnergyData:(REMEnergyData*)point startDate:(NSDate*)startDate step:(REMEnergyStep)step;

@end


@interface REMTrendChartSeries : NSObject<CPTPlotDataSource> {
    @protected REMTrendChartSeriesType seriesType;
//    @protected CPTGraph* graph;
}
//@property (nonatomic, readonly) CPTPlot* plot;
@property (nonatomic, readonly) NSArray* points;
@property (nonatomic) NSUInteger* yAxisIndex;
//@property (nonatomic, readonly) CPTAxis* yAxis;

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMTrendChartDataProcessor*)processor dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate;
//-(void)hide;
//-(void)show;
//-(CPTPlot*)makePlot;
@end



@interface REMTrendChartColumnSeries : REMTrendChartSeries<CPTBarPlotDataSource>

@end

@interface REMTrendChartLineSeries : REMTrendChartSeries

@end



typedef enum  {
    REMTrendChartXAxisLabelAlignToPoint,
    REMTrendChartXAxisLabelAlignToGridLine
} REMTrendChartXAxisLabelAlignment;




@interface REMTrendChartAxisConfig : NSObject
@property (nonatomic, readonly) CPTLineStyle *lineStyle;
@property (nonatomic) NSString* title;
@property (nonatomic, readonly) CPTCoordinate coordinate;
@property (nonatomic, readonly) CPTTextStyle* textStyle;
@property (nonatomic, readonly) CGSize reservedSpace;
@property (nonatomic, readonly) REMTrendChartXAxisLabelAlignment labelAlignment;

+(REMTrendChartAxisConfig*)getWidgetXConfig;
+(REMTrendChartAxisConfig*)getWidgetYConfig;
+(REMTrendChartAxisConfig*)getMaxWidgetXConfig;
+(REMTrendChartAxisConfig*)getMaxWidgetYConfig;

@end



@interface REMTrendChartConfig : NSObject

@property (nonatomic) BOOL verticalGridLine;
@property (nonatomic) REMTrendChartAxisConfig* xAxisConfig;
@property (nonatomic) NSArray* yAxisConfig;

@property (nonatomic) NSInteger horizentalGridLineAmount;
@property (nonatomic) NSInteger horizentalReservedSpace;

@end


@interface REMTrendChartView : CPTGraphHostingView

@property (nonatomic, readonly) BOOL verticalGridLine;

@property (nonatomic, readonly) REMTrendChartAxisConfig* xAxisConfig;
@property (nonatomic, readonly) NSArray* yAxisConfig;

@property (nonatomic, readonly) NSInteger horizentalGridLineAmount;
@property (nonatomic, readonly) NSInteger horizentalReservedSpace;

-(REMTrendChartView*)initWithFrame:(CGRect)frame chartConfig:(REMTrendChartConfig*)config;

@end
