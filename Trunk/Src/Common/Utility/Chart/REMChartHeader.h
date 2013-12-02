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
#import "REMChartStyle.h"

@protocol REMChartDelegate <NSObject>
@end

@protocol REMTrendChartDelegate <REMChartDelegate>
/*
 * points: List<DCDataPoint>
 */
-(void)highlightPoints:(NSArray*)points;

/*
 * Parameter data type: NSDate for line/column. NSNumber for ranking.
 */
-(BOOL)willRangeChange:(id)start end:(id)end;
-(void)touchEndedInNormalStatus:(id)start end:(id)end;
@end

typedef enum _REMDirection{
    REMDirectionLeft = -1,  // 顺时针
    REMDirectionNone = 0,
    REMDirectionRight = 1   // 逆时针
}REMDirection;

@protocol REMTPieChartDelegate <REMChartDelegate>
/*
 * points: List<REMEnergyData>
 * colors: List<UIColor>
 * names: List<NSString>
 */
-(void)highlightPoint:(REMEnergyData*)point color:(UIColor*)color name:(NSString*)name direction:(REMDirection)direction;

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
@property (nonatomic,strong) NSMutableArray* hiddenPointIndexes;
@property (nonatomic) float animationDuration;
-(CPTColor*)getColorByIndex:(NSUInteger)idx;
@property (nonatomic) NSArray* targetNames;
-(void)setHiddenAtIndex:(NSUInteger)index hidden:(BOOL)hidden;
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

-(REMChartConfig*)initWithStyle:(REMChartStyle*)style;
//+(REMChartConfig*)getMinimunWidgetDefaultSetting;
//+(REMChartConfig*)getMaximunWidgetDefaultSetting;
@end



@protocol REMChartView <NSObject>
-(id)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config;
@end



@interface REMPieChartView : CPTGraphHostingView<CPTPlotSpaceDelegate,REMChartView>
@property (nonatomic, weak) id<REMTPieChartDelegate> delegate;
@property (nonatomic, readonly) NSArray* series;
-(void)cancelToolTipStatus;

-(void)setSeriesHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden;
@end
