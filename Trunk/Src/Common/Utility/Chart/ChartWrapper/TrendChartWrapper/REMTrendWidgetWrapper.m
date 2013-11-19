/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendWidget.m
 * Created      : Zilong-Oscar.Xu on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMTrendWidgetWrapper.h"
//@interface REMTrendWidgetWrapper()
//@property (nonatomic, weak) NSDate* baseDateOfX;
//@property (nonatomic) REMTrendChartDataProcessor* dataProcessor;
//@end

@implementation REMTrendWidgetWrapper

-(REMAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax  style:(REMChartStyle*)style{
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
    if (self) {
        _calenderType = REMCalendarTypeNone;
    }
    return self;
}
-(NSArray*)extraSeriesConfig {
    NSMutableArray* seriesArray = [[NSMutableArray alloc]init];
    uint seriesCount = [self getSeriesCount];
    NSMutableArray* uomIdArray = [[NSMutableArray alloc]init];
    for (uint seriesIndex = 0; seriesIndex < seriesCount; seriesIndex++) {
        REMTrendChartSeries* s = [self createSeriesConfigOfIndex:seriesIndex];
        long uomId = s.uomId;
        uint uomIndex = 0;
        for (; uomIndex < uomIdArray.count; uomIndex++) {
            NSNumber* otherUomId = [uomIdArray objectAtIndex:uomIndex];
            if (otherUomId.unsignedIntValue == uomId) {
                break;
            }
        }
        if (uomIndex == uomIdArray.count) {
            [uomIdArray addObject:[NSNumber numberWithLong:uomId]];
        }
        s.yAxisIndex = uomIndex;
        [seriesArray addObject: s];
    }
    return seriesArray;
}

-(uint)getSeriesCount {
    if (self.energyViewData.targetEnergyData != nil && self.energyViewData.targetEnergyData != NULL) {
        return self.energyViewData.targetEnergyData.count;
    } else {
        return 0;
    }
}
-(void)extraSyntax:(REMWidgetContentSyntax*)widgetSyntax {
    NSRange range = [widgetSyntax.xtype rangeOfString : @"multitimespan"];
    BOOL found = ( range.location != NSNotFound );
    useSharedProcessor = !found;
    
    _step = widgetSyntax.step.intValue;
    [super extraSyntax:widgetSyntax];
}

-(NSRange)createGlobalRange {
    NSDate* globalEndDate = nil;
    if (self.energyViewData.globalTimeRange == Nil) {
        self.baseDateOfX = self.energyViewData.visibleTimeRange.startTime;
        globalEndDate = self.energyViewData.visibleTimeRange.endTime;
    } else {
        self.baseDateOfX = self.energyViewData.globalTimeRange.startTime;
        globalEndDate = self.energyViewData.globalTimeRange.endTime;
    }
    
    sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    sharedProcessor.step = self.step;
    sharedProcessor.baseDate = self.baseDateOfX;
    
    NSNumber* globalLength = @([self roundDate:globalEndDate startDate:self.baseDateOfX step:self.step roundToFloor:NO].intValue+1);
    return NSMakeRange(0, globalLength.intValue);
}

-(NSRange)createInitialRange {
    _timeRange = self.energyViewData.visibleTimeRange;
    REMTimeRange* theFirstTimeRange = self.timeRange;
    NSDate* endDate = theFirstTimeRange.endTime;
    NSDate* startDate = theFirstTimeRange.startTime;
    int startPoint = [self roundDate:startDate startDate:self.baseDateOfX step:self.step roundToFloor:YES].intValue;
    int endPoint = [self roundDate:endDate startDate:self.baseDateOfX step:self.step roundToFloor:NO].intValue;
    return NSMakeRange(startPoint, endPoint - startPoint);
}

-(REMTrendChartSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
    return nil;
}

-(NSNumber*)roundDate:(NSDate*)lengthDate startDate:(NSDate*)startDate step:(REMEnergyStep)step roundToFloor:(BOOL)roundToFloor {
    NSNumber* length = [sharedProcessor processX:lengthDate];
    NSDate* edgeOfGlobalEnd = [sharedProcessor deprocessX:length.intValue];
    NSComparisonResult end = [edgeOfGlobalEnd compare:lengthDate];
    if (end == NSOrderedSame || end == NSOrderedDescending) {
        return length;
    } else if (roundToFloor) {
        length = @(length.intValue);
    } else {
        length = @(length.intValue+1);
    }
    return length;
}


-(REMTrendChartView*)renderContentView:(CGRect)frame chartConfig:(REMTrendChartConfig*)chartConfig {
    REMTrendChartView* myView = [[REMTrendChartView alloc]initWithFrame:frame chartConfig:chartConfig];
    NSRange initialRange = [self createInitialRange];
    [myView renderRange:initialRange.location length:initialRange.length];
    
    return  myView;
}

-(REMChartConfig*)getChartConfig:(REMChartStyle*)style {
    REMTrendChartConfig* chartConfig = [[REMTrendChartConfig alloc]initWithStyle:style];
    chartConfig.step = self.step;
    chartConfig.xGlobalLength = @([self createGlobalRange].length);
    
    chartConfig.series = [self extraSeriesConfig];
    NSMutableArray* yAxisList = [[NSMutableArray alloc]init];
    for (REMTrendChartSeries* s in chartConfig.series) {
        if (s.yAxisIndex >= yAxisList.count) {
            REMTrendChartAxisConfig* y = [[REMTrendChartAxisConfig alloc]initWithLineStyle:style.yLineStyle gridlineStyle:style.yGridlineStyle textStyle:style.yTextStyle];
            y.title = s.uomName;
            [yAxisList addObject:y];
            y.labelFormatter = [[REMYFormatter alloc]init];
        }
    }
    chartConfig.yAxisConfig = yAxisList;
    chartConfig.xAxisConfig.labelFormatter = [[REMXFormatter alloc]initWithStartDate:self.baseDateOfX dataStep:chartConfig.step interval:0];
    
    return chartConfig;
}

-(void)setCalenderType:(REMCalendarType)calenderType {
    if (calenderType == self.calenderType) return;
    _calenderType = calenderType;
    CPTXYAxis* xAxis = ((CPTXYAxisSet*)((REMTrendChartView*)self.view).hostedGraph.axisSet).xAxis;
    
    if(self.calenderType == REMCalendarTypeNone) {
        if (xAxis.backgroundLimitBands != nil) {
            while (xAxis.backgroundLimitBands.count != 0) {
                [xAxis removeBackgroundLimitBand:xAxis.backgroundLimitBands[0]];
            }
        }
    } else {
        for (REMEnergyCalendarData* calender in self.energyViewData.calendarData) {
            CPTColor* fillColor = nil;
            if (self.calenderType == REMCalendarTypeHCSeason) {
                if (calender.calendarType == REMCalenderTypeHeatSeason) {
                    fillColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#fcf0e4" alpha:0.5].CGColor];
                } else if (calender.calendarType == REMCalenderTypeCoolSeason) {
                    fillColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#e3f0ff" alpha:0.5].CGColor];
                }
            } else if (self.calenderType == REMCalenderTypeHoliday) {
                if (calender.calendarType == REMCalenderTypeWorkDay) {
                    fillColor = [CPTColor colorWithCGColor:[REMColor colorByHexString:@"#eaeaea" alpha:0.5].CGColor];
                }
            }
            if (fillColor == nil) continue;
            for (REMTimeRange* range in calender.timeRanges) {
                NSNumber* start = [sharedProcessor processX:range.startTime];
                CPTLimitBand* b = [[CPTLimitBand alloc]initWithRange:[[CPTPlotRange alloc] initWithLocation:start.decimalValue length:CPTDecimalFromDouble([sharedProcessor processX:range.endTime].doubleValue - start.doubleValue)] fill:[CPTFill fillWithColor:fillColor]];
                [xAxis addBackgroundLimitBand:b];
            }
        }
    }
}
@end
