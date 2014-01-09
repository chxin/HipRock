//
//  DTrendChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DCTrendWrapper.h"
#import "_DCXLabelFormatter.h"
#import "DCDataPoint.h"
#import "DCXYChartBackgroundBand.h"
#import "DCTrendAnimationManager.h"
#import "REMWidgetStepCalculationModel.h"

@interface DCTrendWrapper()
@property (nonatomic, weak) DCContext* graphContext;
@property (nonatomic, strong) DCRange* myStableRange;
@property (nonatomic) NSString* xtypeOfWidget;
@property (nonatomic,strong) NSMutableArray* hiddenSeriesTargetsId;
@property (nonatomic, strong) DCTrendAnimationManager* animationManager;
@property (nonatomic, assign) double panSpeed;
@end

@implementation DCTrendWrapper

-(UIView*)getView {
    return self.view;
}
-(DCTrendWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*)widgetSyntax style:(REMChartStyle*)style {
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
    if (self && energyViewData.targetEnergyData.count != 0) {
        _calenderType = REMCalendarTypeNone;
        self.xtypeOfWidget = widgetSyntax.xtype;
        [self extraSyntax:widgetSyntax];
        self.hiddenSeriesTargetsId = [[NSMutableArray alloc]init];
        
        self.animationManager = [[DCTrendAnimationManager alloc]init];
        self.animationManager.delegate = self;
        NSDictionary* dic = [self updateProcessorRangesFormatter:widgetSyntax.step.integerValue];
        self.myStableRange = dic[@"beginRange"];
        [self createChartView:frame beginRange:dic[@"beginRange"] globalRange:dic[@"globalRange"] xFormatter:dic[@"xformatter"] step:widgetSyntax.step.integerValue];
        [self updateCalender];
    }
    return self;
}

-(void)createChartView:(CGRect)frame beginRange:(DCRange*)beginRange globalRange:(DCRange*)globalRange xFormatter:(NSFormatter*)xLabelFormatter step:(REMEnergyStep)step{
    DCXYChartView* view = [[DCXYChartView alloc]initWithFrame:frame beginHRange:beginRange stacked:self.isStacked];
    [view setXLabelFormatter:xLabelFormatter];
    _view = view;
    view.xAxis = [[DCAxis alloc]init];
    view.xAxis.coordinate = DCAxisCoordinateX;
    
    NSMutableArray* seriesList = [[NSMutableArray alloc]initWithCapacity:self.energyViewData.targetEnergyData.count];
    NSUInteger seriesIndex = 0;
    NSUInteger seriesAmount = [self getSeriesAmount];
    for (; seriesIndex < seriesAmount; seriesIndex++) {
        [seriesList addObject:[self createSeriesAt:seriesIndex style:self.style]];
    }
    view.yAxisList = [self createYAxes:seriesList];
    
    
    view.graphContext.globalHRange = globalRange;
    view.seriesList = seriesList;
    
    view.acceptTap = self.style.acceptTap;
    view.acceptPinch = self.style.acceptPinch;
    view.acceptPan = self.style.acceptPan;
    
    view.xAxis.lineColor = self.style.xLineColor;
    view.xAxis.lineWidth = self.style.xLineWidth;
    view.xAxis.labelColor = self.style.xTextColor;
    view.xAxis.labelFont = self.style.xTextFont;
    
    if (self.style.yGridlineWidth > 0) {
        view.hGridlineColor = self.style.yGridlineColor;
        view.hGridlineWidth = self.style.yGridlineWidth;
        view.hGridlineStyle = self.style.yGridlineStyle;
    }
    view.hasVGridlines = self.style.xGridlineWidth > 0;
    if (self.style.xGridlineWidth > 0) {
        view.vGridlineColor = self.style.xGridlineColor;
        view.vGridlineWidth = self.style.xGridlineWidth;
        view.vGridlineStyle = self.style.xGridlineStyle;
    }
    
    view.focusSymbolLineColor = self.style.indicatorColor;
    view.focusSymbolLineStyle = self.style.focusSymbolLineStyle;
    view.focusSymbolLineWidth = self.style.focusSymbolLineWidth;
    view.focusSymbolIndicatorSize = self.style.focusSymbolIndicatorSize;
    view.xAxis.labelToLine = self.style.xLabelToLine;
    
    view.backgroundBandFontColor = self.style.backgroundBandFontColor;
    view.backgroundBandFont = self.style.backgroundBandFont;
    
    view.plotPaddingRight = self.style.plotPaddingRight;
    view.plotPaddingLeft = self.style.plotPaddingLeft;
    view.plotPaddingTop = self.style.plotPaddingTop;
    view.plotPaddingBottom = self.style.plotPaddingBottom;
    view.graphContext.hGridlineAmount = self.style.horizentalGridLineAmount;
    view.xAxisLabelClipToBounds = self.style.xLabelClipToBounds;
    view.delegate = self;
    self.graphContext = view.graphContext;
    if (step == REMEnergyStepHour || step == REMEnergyStepWeek) {
        view.graphContext.pointAlignToTick = NO;
        view.graphContext.xLabelAlignToTick = YES;
    } else {
        view.graphContext.pointAlignToTick = YES;
        view.graphContext.xLabelAlignToTick = YES;
    }
    
//    view.blockReboundAnimation = (step == REMEnergyStepHour);   // 步长为小时时禁止回弹动画
    
    [self customizeView:view];
    self.animationManager.view = view;
}

-(NSArray*)createYAxes:(NSArray*)series {
    NSMutableArray* yAxes = [[NSMutableArray alloc]init];
    for (DCXYSeries* s in series) {
        for (DCAxis* y in yAxes) {
            if ((REMIsNilOrNull(y.axisTitle) && REMIsNilOrNull(s.target.uomName)) || [y.axisTitle isEqualToString:s.target.uomName]) {
                s.yAxis = y;
                break;
            }
        }
        if (REMIsNilOrNull(s.yAxis)) {
            DCAxis* y = [[DCAxis alloc]init];
            s.yAxis = y;
            y.coordinate = DCAxisCoordinateY;
            y.axisTitle = s.target.uomName;
            y.labelToLine = self.style.yLabelToLine;
            if (self.style.yLineWidth > 0) {
                y.lineColor = self.style.yLineColor;
                y.lineWidth = self.style.yLineWidth;
            }
            if (self.style.yTextFont && self.style.yTextColor) {
                y.labelColor = self.style.yTextColor;
                y.labelFont = self.style.yTextFont;
            }
            y.axisTitleColor = self.style.yAxisTitleColor;
            y.axisTitleToTopLabel = self.style.yAxisTitleToTopLabel;
            y.axisTitleFontSize = self.style.yAxisTitleFontSize;
            [yAxes addObject:y];
        }
    }
    return yAxes;
}

-(void)customizeView:(DCXYChartView*)view {
    
}

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(REMChartStyle*)style {
    // Nothing to do.
}

-(DCXYSeries*)createSeriesAt:(NSUInteger)index style:(REMChartStyle*)style {
    DCXYChartView* view = self.view;
    REMTargetEnergyData* targetEnergy = self.energyViewData.targetEnergyData[index];
    NSMutableArray* datas = [[NSMutableArray alloc]init];
    REMTrendChartDataProcessor* processor = [self.processors objectAtIndex:index];
    for (REMEnergyData* point in targetEnergy.energyData) {
        int processedX = [processor processX:point.localTime].integerValue;
        if (processedX < 0) continue;
        while ((int)datas.count < processedX) {
            DCDataPoint* p = [[DCDataPoint alloc]init];
            p.target = targetEnergy.target;
            [datas addObject:p];
        }
        DCDataPoint* p = [[DCDataPoint alloc]init];
        p.energyData = point;
        p.target = targetEnergy.target;
        p.value = point.dataValue;
        [datas addObject:p];
    }
    DCXYSeries* s;
    if (!REMIsNilOrNull(targetEnergy.target) &&  [self isSpecialType:targetEnergy.target.type]) {
        s = [[DCLineSeries alloc]initWithEnergyData:datas];
        s.color = style.benchmarkColor;
        ((DCLineSeries*)s).symbolType = index % 5;
        ((DCLineSeries*)s).symbolSize = style.symbolSize;
    } else {
        s = [[NSClassFromString(self.defaultSeriesClass) alloc]initWithEnergyData:datas];
        s.color = [REMColor colorByIndex:index];
    }
    s.xAxis = view.xAxis;
    s.target = targetEnergy.target;
    [self customizeSeries:s seriesIndex:index chartStyle:style];
    return s;
}


-(BOOL)isSpecialType:(REMEnergyTargetType)type {
    return type == REMEnergyTargetBenchmarkValue;
}

-(NSNumber*)roundDate:(NSDate*)lengthDate startDate:(NSDate*)startDate processor:(REMTrendChartDataProcessor*)processor roundToFloor:(BOOL)roundToFloor {
    NSNumber* length = [processor processX:lengthDate];
    NSDate* edgeOfGlobalEnd = [processor deprocessX:length.intValue];
    NSComparisonResult end = [edgeOfGlobalEnd compare:lengthDate];
    if (end == NSOrderedDescending) {
        return length;
    } else if (roundToFloor) {
        length = @(length.intValue);
    } else {
        length = @(length.intValue+1);
    }
    return length;
}

-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step {
    _isStacked = ([self.xtypeOfWidget rangeOfString:@"stack"].location != NSNotFound);
    
    NSUInteger seriesAmount = [self getSeriesAmount];
    _processors = [[NSMutableArray alloc]init];
//    BOOL allSeriesUserGlobalTime = ([self.xtypeOfWidget rangeOfString : @"multitimespan"].location == NSNotFound);
    
    NSDate* baseDateOfX = nil;
    NSDate* globalStartdDate = nil;
    NSDate* globalEndDate = nil;
    NSDate* beginningStart = nil;
    NSDate* beginningEnd = nil;
    _sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    self.sharedProcessor.step = step;
    
//    if (allSeriesUserGlobalTime) {
    beginningStart = self.energyViewData.visibleTimeRange.startTime;
    beginningEnd = self.energyViewData.visibleTimeRange.endTime;
    
    if (REMIsNilOrNull(self.energyViewData.globalTimeRange)) {
        globalStartdDate = beginningStart;
        globalEndDate = beginningEnd;
    } else {
        globalStartdDate = self.energyViewData.globalTimeRange.startTime;
        if ([globalStartdDate compare:beginningStart]==NSOrderedDescending) {
            globalStartdDate = beginningStart;
        }
        globalEndDate = self.energyViewData.globalTimeRange.endTime;
        if ([globalEndDate compare:beginningEnd]==NSOrderedAscending) {
            globalEndDate = beginningEnd;
        }
    }
    for (int i = 0; i < seriesAmount; i++) {
        [self.processors addObject:self.sharedProcessor];
    }
    
    baseDateOfX = globalStartdDate;
    if (!REMIsNilOrNull(self.energyViewData.targetEnergyData) && self.energyViewData.targetEnergyData.count != 0) {
        NSDate* baseDateFromEnergyData = nil;
        for (REMTargetEnergyData* d in self.energyViewData.targetEnergyData) {
            if (d.energyData.count > 0) {
                baseDateFromEnergyData = [d.energyData[0] localTime];
                self.sharedProcessor.baseDate = baseDateFromEnergyData;
                baseDateOfX = [self.sharedProcessor deprocessX:floorf([self.sharedProcessor processX:baseDateOfX].doubleValue)];
                break;
            }
        }
    }
    
    self.sharedProcessor.baseDate = baseDateOfX;
    double globalStart = [self.sharedProcessor processX:globalStartdDate].doubleValue;
    double globalLength = [self.sharedProcessor processX:globalEndDate].doubleValue - globalStart;
    double startPoint = [self.sharedProcessor processX:beginningStart].doubleValue;
    double endPoint = [self.sharedProcessor processX:beginningEnd].doubleValue;
    
    if (endPoint < startPoint) endPoint = startPoint;
    DCRange* beginRange = [[DCRange alloc]initWithLocation:startPoint length:endPoint-startPoint];
    DCRange* globalRange = [[DCRange alloc]initWithLocation:globalStart length:globalLength];
    return @{ @"globalRange": globalRange, @"beginRange": beginRange, @"xformatter": [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1]};
}

-(NSUInteger)getSeriesAmount {
    return self.energyViewData.targetEnergyData.count;
}

-(NSUInteger)getVisableSeriesCount {
    NSUInteger count = 0;
    for (DCXYSeries* s in self.view.seriesList) {
        if (!s.hidden) count++;
    }
    return count;
}

-(void)cancelToolTipStatus {
    [super cancelToolTipStatus];
    self.view.acceptPinch = self.style.acceptPinch;
//    self.view.acceptPan = self.style.acceptPan;
    [self.view defocus];
}
-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    if (seriesIndex >= self.view.seriesList.count) return;
    DCXYSeries* series = self.view.seriesList[seriesIndex];
    [self.view setSeries:series hidden:hidden];
    if (REMIsNilOrNull(series.target)) return;
    
    if (hidden) {
        [self addHiddenTarget:series.target];
    } else {
        [self removeHiddenTarget:series.target];
    }
}

-(void)extraSyntax:(REMWidgetContentSyntax*)syntax {
    _calenderType = syntax.calendarType;
}
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step {
    [self.animationManager invalidate];
    self.animationManager.view = nil;
    [super redraw:energyViewData];
    NSDictionary* dic = [self updateProcessorRangesFormatter:step];
    CGRect frame = self.view.frame;
    UIView* superView = self.view.superview;
    
    [self.view removeFromSuperview];
    
    self.myStableRange = dic[@"beginRange"];
    [self createChartView:frame beginRange:dic[@"beginRange"] globalRange:dic[@"globalRange"] xFormatter:dic[@"xformatter"] step:step];
    for(DCXYSeries* s in self.view.seriesList) {
        if (REMIsNilOrNull(s.target)) continue;
        s.hidden = [self isTargetHidden:s.target];
    }
    [superView addSubview:self.view];
    [self updateCalender];
}

-(void)setCalenderType:(REMCalendarType)calenderType {
    if (calenderType == self.calenderType) return;
    _calenderType = calenderType;
    [self updateCalender];
}

-(void) updateCalender {
    if (self.sharedProcessor == nil) return;
    NSMutableArray* bands = [[NSMutableArray alloc]init];
    if(self.calenderType != REMCalendarTypeNone) {
        for (REMEnergyCalendarData* calender in self.energyViewData.calendarData) {
            UIColor* fillColor = nil;
            NSString* bandString = nil;

            if (self.calenderType == REMCalendarTypeHCSeason) {
                if (calender.calendarType == REMCalenderTypeHeatSeason) {
                    fillColor = [REMColor colorByHexString:@"#fcf0e4" alpha:0.5];
                    bandString = REMLocalizedString(@"Chart_Background_Text_HSeason");
                } else if (calender.calendarType == REMCalenderTypeCoolSeason) {
                    fillColor = [REMColor colorByHexString:@"#e3f0ff" alpha:0.5];
                    bandString = REMLocalizedString(@"Chart_Background_Text_CSeason");
                }
            } else if (self.calenderType == REMCalenderTypeHoliday) {
                if (calender.calendarType == REMCalenderTypeHoliday || calender.calendarType == REMCalenderTypeRestTime) {
                    fillColor = [REMColor colorByHexString:@"#eaeaea" alpha:0.5];
                    bandString = REMLocalizedString(@"Chart_Background_Text_NonWorkday");
                }
            }
            if (fillColor == nil) continue;
            for (REMTimeRange* range in calender.timeRanges) {
                NSNumber* start = @([self.sharedProcessor processX:range.startTime].doubleValue-0.5);
                DCRange* bandRange = [[DCRange alloc]initWithLocation:start.doubleValue length:[self.sharedProcessor processX:range.endTime].doubleValue -0.5 - start.doubleValue];
                DCXYChartBackgroundBand* b = [[DCXYChartBackgroundBand alloc]init];
                b.range = bandRange;
                b.color = fillColor;
                b.axis = self.view.xAxis;
                b.title = bandString;
                [bands addObject:b];
            }
        }
    }
    [self.view setBackgoundBands:bands];
}


#pragma mark - DCXYChartViewDelegate implementation
-(void)touchedInPlotAt:(CGPoint)point xCoordinate:(double)xLocation {
    if (self.chartStatus == DChartStatusNormal) {
        self.chartStatus = DChartStatusFocus;
        //        self.view.acceptPan = NO;
        self.view.acceptPinch = NO;
    }
    [self.view focusAroundX:xLocation];
}
-(void)didYIntervalChange:(double)yInterval forAxis:(DCAxis *)yAxis range:(DCRange*)range {
    // Nothing to do.
}
-(void)panWithSpeed:(CGFloat)speed panStopped:(BOOL)stopped {
    if (!stopped) self.panSpeed = speed;
    if (self.chartStatus != DChartStatusNormal) return;
    
    DCRange* globalRange = self.graphContext.globalHRange;
    DCRange* range = self.graphContext.hRange;
    double rangeLength = range.length;
    double rangeLocation = range.location;
    if (rangeLocation < globalRange.location) rangeLocation = globalRange.location;
    if (range.end > globalRange.end) rangeLocation = globalRange.end - rangeLength;
    self.myStableRange = [[DCRange alloc]initWithLocation:rangeLocation length:rangeLength];
    
    if (stopped) {
        if (self.sharedProcessor.step == REMEnergyStepHour) {
            self.myStableRange = self.view.graphContext.hRange;
        } else {
            [self.animationManager animateHRangeWithSpeed: self.panSpeed];
        }
        self.panSpeed = 0;
        [self fireGestureStoppedEvent];
    }
}
-(void)pinchStopped {
    [self fireGestureStoppedEvent];
}
-(void)fireGestureStoppedEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pinchStoppedBetween:end:)]) {
        DCRange* newRange = self.myStableRange;
        double rangeStart = newRange.location;
        double rangeEnd = newRange.location + newRange.length;
        id start, end;
        if (!REMIsNilOrNull(self.sharedProcessor)) {
            if (self.sharedProcessor.step != REMEnergyStepHour && self.sharedProcessor.step != REMEnergyStepNone) {
                start = [self.sharedProcessor deprocessX:rangeStart];
                end = [self.sharedProcessor deprocessX:rangeEnd];
            } else {
                start = @(rangeStart);
                end = @(rangeEnd);
            }
        }
        [self.delegate performSelector:@selector(pinchStoppedBetween:end:) withObject:start withObject:end];
    }
}
-(void)focusPointChanged:(NSArray *)dcpoints at:(int)x {
    if (self.delegate && [[self.delegate class] conformsToProtocol:@protocol(REMTrendChartDelegate)]) {
        id xVal = (REMIsNilOrNull(self.sharedProcessor)) ? @(x) : [self.sharedProcessor deprocessX:x];
        [(id<REMTrendChartDelegate>)self.delegate highlightPoints:dcpoints x:xVal];
    }
}
-(DCRange*)updatePinchRange:(DCRange *)newRange {
    REMEnergyStep myStep = self.sharedProcessor.step;
    if (myStep == REMEnergyStepNone) return newRange;
    
    NSUInteger newRangeTimeInterval = [[self.sharedProcessor deprocessX:newRange.end] timeIntervalSinceDate:[self.sharedProcessor deprocessX:newRange.location]];
    DCRange* globalRange = self.graphContext.globalHRange;
    
    NSRange lengthRange = [[REMWidgetStepCalculationModel getStepIntervalRanges][myStep] rangeValue];
    NSUInteger lengthRangeEnd = (lengthRange.length == NSUIntegerMax) ? NSUIntegerMax : (lengthRange.location + lengthRange.length);
    if (newRange.location >= globalRange.location && newRange.end <= globalRange.end && newRangeTimeInterval > lengthRange.location && newRangeTimeInterval <= lengthRangeEnd) {
        self.myStableRange = newRange;
        return newRange;
    } else {
        self.myStableRange = self.graphContext.hRange;
        return self.graphContext.hRange;
    }
}

#pragma mark - DCTrendAnimationDelegate implementation
-(void)didHRangeApplyToView:(DCRange*)range finalRange:(DCRange*)finalRange {
    DCRange* globalRange = self.view.graphContext.globalHRange;
    BOOL isAStableRange = (range.location >= globalRange.location) && (range.end <= globalRange.end);
    if (isAStableRange) {
        self.myStableRange = range;
    } else {
        self.myStableRange = finalRange;
    }
}



#pragma mark - Fire to REMTrendChartDelegate
-(void)setMyStableRange:(DCRange *)myStableRange {
    if (![DCRange isRange:self.myStableRange equalTo:myStableRange]) {
        _myStableRange = myStableRange;
        // FIRE to delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(willRangeChange:end:)]) {
            id param0, param1;
            if (self.sharedProcessor == nil) {
                param0 = @(myStableRange.location);
                param1 = @(myStableRange.end);
            } else {
                param0 = [self.sharedProcessor deprocessX:myStableRange.location];
                param1 = [self.sharedProcessor deprocessX:myStableRange.end];
            }
            [self.delegate performSelector:@selector(willRangeChange:end:) withObject:param0 withObject:param1];
        }
    }
}
@end
