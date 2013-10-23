//
//  REMChartHeader.h
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
#import "REMColor.h"


typedef enum  {
    REMTrendChartSeriesTypeColumn,
    REMTrendChartSeriesTypeLine,
    REMChartSeriesPie
} REMChartSeriesType;



//@interface REMTrendChartPoint : NSObject
//
//@property (nonatomic,readonly) float x;
//@property (nonatomic,readonly) NSNumber* y;
//@property (nonatomic,readonly) REMEnergyData* energyData;
//
//-(REMTrendChartPoint*)initWithX:(float)x y:(NSNumber*)y point:(REMEnergyData*)p;
//
//@end










@interface REMChartDataProcessor : NSObject
-(NSNumber*)processX:(NSDate*)xLocalTime startDate:(NSDate*)startDate step:(REMEnergyStep)step;
-(NSNumber*)processY:(NSNumber*)yVal startDate:(NSDate*)startDate step:(REMEnergyStep)step;
-(NSDate*)deprocessX:(float)x startDate:(NSDate*)startDate step:(REMEnergyStep)step;
@end

@interface REMTrendChartDataProcessor : REMChartDataProcessor

//-(REMTrendChartPoint*)processEnergyData:(REMEnergyData*)point startDate:(NSDate*)startDate step:(REMEnergyStep)step;

@end

@interface REMChartSeries : NSObject<CPTPlotDataSource> {
@protected REMChartSeriesType seriesType;
@protected CPTPlot* plot;
}

@property (nonatomic, readonly) NSDictionary* plotStyle;
@property (nonatomic, readonly) NSArray* energyData;
@property (nonatomic, readonly) REMChartDataProcessor* dataProcessor;


-(CPTPlot*)getPlot;

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle;
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex;

@end


@interface REMPieChartSeries : REMChartSeries<CPTPieChartDataSource,CPTAnimationDelegate>
@property (nonatomic) float animationDuration;
@end

@interface REMTrendChartSeries : REMChartSeries {
@protected BOOL occupy;   // 所有为YES的序列，在同一个X轴位置的数据点的位置互斥。线图设为false，Bar、Column和StackColumn设为true
}
//@property (nonatomic, readonly) NSArray* points;

@property (nonatomic, readonly) REMEnergyStep step;
/*
 * 对应的Y轴的index，从0开始
 */
@property (nonatomic, readonly) NSUInteger yAxisIndex;
/*
 * 第一个点用processor处理后的x值，作为本序列在x方向上最小值
 */
@property (nonatomic, readonly) float minX;
/*
 * 最后一个点用processor处理后的x值，作为本序列在x方向上最大值
 */
@property (nonatomic, readonly) float maxX;
/*
 * x数据处理的起点时间
 */
@property (nonatomic, readonly) NSDate* startDate;

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataStep:(REMEnergyStep)step;
-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataStep:(REMEnergyStep)step startDate:(NSDate*)startDate;

-(BOOL)isOccupy;
-(NSNumber*)maxYValBetween:(int)minX and:(int)maxX;
@end

@interface REMTrendChartColumnSeries : REMTrendChartSeries<CPTBarPlotDataSource>

@end

@interface REMTrendChartLineSeries : REMTrendChartSeries<CPTScatterPlotDataSource>

@end

@interface REMTrendChartRankingSeries : REMTrendChartColumnSeries
@property (nonatomic) NSComparisonResult sortOrder;
@end

@interface REMXFormatter : NSFormatter
-(REMXFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval length:(float)length;
@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) REMEnergyStep step;
@property (nonatomic, readonly) int interval;
@end

@interface REMYFormatter : NSFormatter
@end

typedef enum  {
    REMTrendChartXAxisLabelAlignToPoint,
    REMTrendChartXAxisLabelAlignToGridLine
} REMTrendChartXAxisLabelAlignment;




@interface REMTrendChartAxisConfig : NSObject
@property (nonatomic, readonly) CPTLineStyle *lineStyle;
@property (nonatomic, readonly) CPTLineStyle *gridlineStyle;
@property (nonatomic) NSString* title;
@property (nonatomic, readonly) CPTTextStyle* textStyle;
@property (nonatomic, readonly) CGSize reservedSpace;
@property (nonatomic, readonly) REMTrendChartXAxisLabelAlignment labelAlignment;

+(REMTrendChartAxisConfig*)getMinWidgetXConfig;
+(REMTrendChartAxisConfig*)getMinWidgetYConfig;
+(REMTrendChartAxisConfig*)getMaxWidgetXConfig;
+(REMTrendChartAxisConfig*)getMaxWidgetYConfig;

@end

@interface REMChartConfig : NSObject
@property (nonatomic) BOOL userInteraction;
/*
 * IList<REMChartSeries>
 */
@property (nonatomic) NSArray* series;

+(REMChartConfig*)getMinimunWidgetDefaultSetting;
+(REMChartConfig*)getMaximunWidgetDefaultSetting;
@end


@interface REMTrendChartConfig : REMChartConfig

@property (nonatomic) REMEnergyStep step;
/*
 * 是否绘制纵向Gridline。默认不绘制。
 */
@property (nonatomic) BOOL verticalGridLine;
/*
 * X轴配置。
 */
@property (nonatomic) REMTrendChartAxisConfig* xAxisConfig;
/*
 * Y轴配置。IList<REMTrendChartAxisConfig>
 */
@property (nonatomic) NSArray* yAxisConfig;

/*
 * 水平等高线的数量（包括x轴）。
 */
@property (nonatomic) NSInteger horizentalGridLineAmount;
/*
 * X轴的起点时间。如果没有指定，则会使用Series配置中最小的StartDate作为默认起点时间。
 */
@property (nonatomic) NSDate* xStartDate;
/*
 * X轴的最大区间长度，也就是Navigation的长度。如果没有指定，则采用配置的Series的最大的X。
 */
@property (nonatomic) NSNumber* xGlobalLength;
@end

@protocol REMChartView <NSObject>
-(id)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config;
@end


@interface REMTrendChartView : CPTGraphHostingView<CPTPlotSpaceDelegate,REMChartView,CPTAnimationDelegate>

@property (nonatomic, readonly) NSArray* series;
@property (nonatomic, readonly) BOOL verticalGridLine;
@property (nonatomic, readonly) REMTrendChartAxisConfig* xAxisConfig;
@property (nonatomic, readonly) NSArray* yAxisConfig;
@property (nonatomic, readonly) NSInteger horizentalGridLineAmount;
@property (nonatomic, readonly) REMEnergyStep step;
/*
 * X轴文本的起点时间。
 */
@property (nonatomic, readonly) NSDate* xStartDate;
/*
 * X轴的最大区间长度，也就是Navigation的长度。如果没有指定，则采用配置的Series的最大的X。
 */
@property (nonatomic, readonly) NSNumber* xGlobalLength;

-(void)renderRange:(float)location length:(float)length;

@end

@interface REMPieChartView : CPTGraphHostingView<CPTPlotSpaceDelegate,REMChartView>

@property (nonatomic, readonly) NSArray* series;

@end
