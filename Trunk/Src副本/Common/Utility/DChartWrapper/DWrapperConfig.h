//
//  DWrapperConfig.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/14/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMWidgetContentSyntax.h"
#import "DCSeriesStatus.h"

typedef enum _REMChartFromLevel2 {
    REMChartFromLevel2None = 0, // 非Jazz的Widget的图，例如BuildingCover上的默认图形，以及PM25图
    REMChartFromLevel2EnergyAnalysis = 1,  // 能效分析
    REMChartFromLevel2Carbon = 2,          // 碳排放
    REMChartFromLevel2Cost = 3,  // 成本
    REMChartFromLevel2Unit = 4,    // 单位指标
    REMChartFromLevel2Ratio = 5,  // 时段能耗比
    REMChartFromLevel2Labeling = 6,
    REMChartFromLevel2Ranking = 7
} REMChartFromLevel2;

@interface DWrapperConfig : NSObject
@property (nonatomic, readonly) REMDataStoreType dataStoreType; // 当此值为-1时，表示Wrapper为非widget的内容，例如buildingCover和PM25
//@property (nonatomic, readonly) NSString* storeType;

// widgetFrom,isMultiTimeEnergyAnalysisChart,isTouChart根据storeType来计算
@property (nonatomic, readonly, getter = getWidgetFrom) REMChartFromLevel2 widgetFrom;
@property (nonatomic, readonly, getter = getIsMultiTimeEnergyAnalysisChart) BOOL isMultiTimeEnergyAnalysisChart;
@property (nonatomic, readonly, getter = getIsTouChart) BOOL isTouChart;


@property (nonatomic, assign) REMEnergyStep step;   // Line, Column
@property (nonatomic, assign) REMCalendarType calendarType; // Line, Column

@property (nonatomic, assign) REMRankingRange rankingRangeCode; // Ranking
@property (nonatomic, assign) NSComparisonResult rankingSortOrder; // Ranking

@property (nonatomic, strong) NSString* benckmarkText; // Labeling

@property (nonatomic, strong) NSArray* timeRanges; // 从Syntax复制的TimeRange

@property (nonatomic, strong) NSArray *seriesStates;

@property (nonatomic, assign) DCSeriesTypeStatus defaultSeriesType;

//@property (nonatomic, strong) NSArray* multiTimeSpans;  // 多时间段比较的每个序列的总体时间区间

@property (nonatomic) REMRelativeTimeRangeType relativeDateType;

@property (nonatomic,weak) REMWidgetContentSyntax *contentSyntax;

-(id)initWith:(REMWidgetContentSyntax*)contentSyntax;
@end
