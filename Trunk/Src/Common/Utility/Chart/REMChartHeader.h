/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartHeader.h
 * Created      : Zilong-Oscar.Xu on 9/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMWidgetObject.h"
#import "REMEnergyData.h"
#import "CorePlot-CocoaTouch.h"
#import "REMBuildingConstants.h"
#import "REMEnergyTargetModel.h"
#import "REMColor.h"

@protocol REMTrendChartDelegate <NSObject>
/*
 * points: List<REMEnergyData>
 * colors: List<UIColor>
 * names: List<NSString>
 */
-(void)highlightPoints:(NSArray*)points colors:(NSArray*)colors names:(NSArray*)names;

@end


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
-(NSNumber*)processX:(NSDate*)xLocalTime;
-(NSNumber*)processY:(NSNumber*)yVal;
-(NSDate*)deprocessX:(float)x;
@end
@interface REMTrendChartDataProcessor : REMChartDataProcessor
@property (nonatomic, weak) NSDate* baseDate;
@property (nonatomic, assign) REMEnergyStep step;
@end

@interface REMChartSeries : NSObject<CPTPlotDataSource> {
@protected CPTPlot* plot;
}

@property (nonatomic, readonly) NSDictionary* plotStyle;
@property (nonatomic, readonly) NSArray* energyData;
@property (nonatomic, readonly) REMChartDataProcessor* dataProcessor;
@property (nonatomic, assign) long long uomId;
@property (nonatomic) NSString* uomName;


-(CPTPlot*)getPlot;

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle;
-(void)beforePlotAddToGraph:(CPTGraph*)graph seriesList:(NSArray*)seriesList selfIndex:(uint)selfIndex;

@end




@interface REMPieChartSeries : REMChartSeries<CPTPieChartDataSource,CPTAnimationDelegate>
@property (nonatomic) float animationDuration;
@end

@interface REMTrendChartSeries : REMChartSeries {
@protected NSMutableArray* source;
@protected CPTColor* color;
@protected CPTColor* diabledColor;
@protected NSNumber* highlightIndex;
@protected BOOL occupy;   // 所有为YES的序列，在同一个X轴位置的数据点的位置互斥。线图设为false，Bar、Column和StackColumn设为true
}
//@property (nonatomic, readonly) NSArray* points;

@property (nonatomic) NSNumber* yScale; //因为将所有的序列都绘制在同一个plotspace上，多Y轴的时候需要将非主轴的Y值进行缩放。
/*
 * 对应的Y轴的index，从0开始
 */
@property (nonatomic) NSUInteger yAxisIndex;
@property (nonatomic,weak) REMEnergyTargetModel* target;
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

@property (nonatomic, assign) NSRange visableRange;

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle startDate:(NSDate*)startDate;

-(BOOL)isOccupy;
-(UIColor*)getSeriesColor;
-(NSNumber*)maxYInCache;
-(NSArray*)getCurrentRangeSource;
-(void)highlightAt:(NSUInteger)index;
-(void)dehighlight;
@end

@interface REMTrendChartColumnSeries : REMTrendChartSeries<CPTBarPlotDataSource>

@end

@interface REMTrendChartLineSeries : REMTrendChartSeries<CPTScatterPlotDataSource>

@end

@interface REMTrendChartStackColumnSeries : REMTrendChartColumnSeries
@property (nonatomic, weak) REMTrendChartStackColumnSeries* previousStackSeries;
@end

@interface REMTrendChartRankingSeries : REMTrendChartColumnSeries
@property (nonatomic) NSComparisonResult sortOrder;
@end

@interface REMXFormatter : NSFormatter
-(REMXFormatter*)initWithStartDate:(NSDate*)startDate dataStep:(REMEnergyStep)step interval:(int)interval;
@property (nonatomic, readonly) NSDate* startDate;
@property (nonatomic, readonly) REMEnergyStep step;
@property (nonatomic) int interval;
@end

@interface REMYFormatter : NSFormatter
@property (nonatomic) NSNumber* yScale;
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
@property (nonatomic) NSFormatter* labelFormatter;
-(REMTrendChartAxisConfig*)initWithLineStyle:(CPTLineStyle*)lineStyle gridlineStyle:(CPTLineStyle*)gridlineStyle textStyle:(CPTTextStyle*)textStyle;

@end

@interface REMChartConfig : NSObject
@property (nonatomic, assign) BOOL userInteraction;
/*
 * IList<REMChartSeries>
 */
@property (nonatomic) NSArray* series;
/*
 * IList<REMChartSeries>
 */
@property (nonatomic, assign) float animationDuration;

-(REMChartConfig*)initWithDictionary:(NSDictionary*)dictionary;
//+(REMChartConfig*)getMinimunWidgetDefaultSetting;
//+(REMChartConfig*)getMaximunWidgetDefaultSetting;
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
 * X轴的最大区间长度，也就是Navigation的长度。如果没有指定，则采用配置的Series的最大的X。
 */
@property (nonatomic) NSNumber* xGlobalLength;
@end

@protocol REMChartView <NSObject>
-(id)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config;
@end


@interface REMTrendChartView : CPTGraphHostingView<CPTPlotSpaceDelegate,REMChartView,CPTAnimationDelegate>
@property (nonatomic,weak) id<REMTrendChartDelegate> delegate;
@property (nonatomic, readonly) NSArray* series;
@property (nonatomic, readonly) BOOL verticalGridLine;
@property (nonatomic, readonly) REMTrendChartAxisConfig* xAxisConfig;
@property (nonatomic, readonly) NSArray* yAxisConfig;
@property (nonatomic, readonly) NSInteger horizentalGridLineAmount;
@property (nonatomic, readonly) REMEnergyStep step;
/*
 * X轴的最大区间长度，也就是Navigation的长度。如果没有指定，则采用配置的Series的最大的X。
 */
@property (nonatomic, readonly) NSNumber* xGlobalLength;

-(void)renderRange:(float)location length:(float)length;
-(void)setSeriesHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden;
-(void)cancelToolTipStatus;
@end

@interface REMPieChartView : CPTGraphHostingView<CPTPlotSpaceDelegate,REMChartView>

@property (nonatomic, readonly) NSArray* series;

@end
