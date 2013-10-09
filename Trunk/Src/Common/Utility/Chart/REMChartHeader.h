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
@protected BOOL occupy;   // 所有为YES的序列，在同一个X轴位置的数据点的位置互斥。线图设为false，Bar、Column和StackColumn设为true
@protected CPTPlot* plot;
}
@property (nonatomic, readonly) NSDictionary* plotStyle;
@property (nonatomic, readonly) NSArray* points;

/*
 * 对应的Y轴的index，从0开始
 */
@property (nonatomic, readonly) NSUInteger yAxisIndex;

/*
 * x数据处理的起点时间
 */
@property (nonatomic, readonly) NSDate* startDate;

-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle;
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex;
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor;
-(REMTrendChartSeries*)initWithData:(NSArray*)energyData dataStep:(REMEnergyStep)step plotStyle:(NSDictionary*)plotStyle yAxisIndex:(int)yAxisIndex dataProcessor:(REMTrendChartDataProcessor*)processor startDate:(NSDate*)startDate;
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex;
-(CPTPlot*)getPlot;
-(BOOL)isOccupy;
//-(void)hide;
//-(void)show;
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
@property (nonatomic, readonly) CPTLineStyle *gridlineStyle;
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

@property (nonatomic) REMEnergyStep step;
/*
 * 是否绘制纵向Gridline。默认不绘制。
 */
@property (nonatomic) BOOL verticalGridLine;

@property (nonatomic) REMTrendChartAxisConfig* xAxisConfig;

@property (nonatomic) NSArray* yAxisConfig;

/*
 * 水平等高线的数量（包括x轴）。
 */
@property (nonatomic) NSInteger horizentalGridLineAmount;

@property (nonatomic) NSArray* series;

/*
 * X轴文本的起点时间。如果没有指定，则会使用Series配置中最小的StartDate作为默认起点时间。
 */
@property (nonatomic) NSDate* xStartDate;

+(REMTrendChartConfig*)getMinimunWidgetDefaultSetting;
@end






@interface REMTrendChartView : CPTGraphHostingView<CPTPlotSpaceDelegate>

@property (nonatomic, readonly) BOOL verticalGridLine;
@property (nonatomic, readonly) REMTrendChartAxisConfig* xAxisConfig;
@property (nonatomic, readonly) NSArray* yAxisConfig;
@property (nonatomic, readonly) NSInteger horizentalGridLineAmount;
@property (nonatomic, readonly) NSArray* series;
@property (nonatomic, readonly) REMEnergyStep step;
/*
 * X轴文本的起点时间。
 */
@property (nonatomic, readonly) NSDate* xStartDate;

-(REMTrendChartView*)initWithFrame:(CGRect)frame chartConfig:(REMTrendChartConfig*)config;

@end
