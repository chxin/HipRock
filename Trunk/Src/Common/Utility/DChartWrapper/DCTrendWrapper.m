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
#import "DCSeriesStatus.h"

@interface DCTrendWrapper()
@property (nonatomic, weak) DCContext* graphContext;
@property (nonatomic, strong) DCRange* myStableRange;
@property (nonatomic, strong) DCTrendAnimationManager* animationManager;
@property (nonatomic, assign) double panSpeed;
@end

@implementation DCTrendWrapper


-(UIView*)getView {
    return self.view;
}
-(DCTrendWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig *)wrapperConfig style:(DCChartStyle *)style {
    self = [super initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];

    
    if (self && energyViewData.targetEnergyData.count != 0) {
        self.animationManager = [[DCTrendAnimationManager alloc]init];
        self.animationManager.delegate = self;
        NSDictionary* dic = [self updateProcessorRangesFormatter:wrapperConfig.step];
        _myStableRange = dic[@"beginRange"];
        
        [self createChartView:frame beginRange:dic[@"beginRange"] globalRange:dic[@"globalRange"] xFormatter:dic[@"xformatter"] step:wrapperConfig.step];
    
        [self updateCalendar];
    }
    return self;
}

-(DCSeriesStatus*)getDefaultSeriesState:(REMEnergyTargetModel*)target seriesIndex:(NSUInteger)index {
    DCSeriesStatus* state = [[DCSeriesStatus alloc]init];
    state.seriesKey = [self getSeriesKeyByTarget:target seriesIndex:index];
    state.seriesType = self.wrapperConfig.defaultSeriesType;
    state.suppressible = YES;
    state.visible = [self.chartStrategy.defaultVisibleGen getDefaultVisible:target];
    state.avilableTypes = [self.chartStrategy.avalibleTypeGen getAvalibleTypeBySeriesKey:state.seriesKey targetTypeFromServer:target.type defaultChartType:self.wrapperConfig.defaultSeriesType];
    
    if (target.type == REMEnergyTargetBenchmarkValue) {
        state.forcedColor = self.style.benchmarkColor;
        state.seriesType = DCSeriesTypeStatusLine;
    }
    
    return state;
}

-(NSString*)getCoordinateNameBySeries:(DCXYSeries*)series inSeriesList:(NSArray*)seriesList {
    DCXYSeries* groupFirstSeries = nil;
    for (DCXYSeries* s in seriesList) {
        if (s.groupName == series.groupName) {
            groupFirstSeries = s;
            break;
        }
    }
    if (REMIsNilOrNull(groupFirstSeries)) {
        return [self getUomNameOfTarget:series.target];
    } else {
        return groupFirstSeries.coordinateSystemName;
    }
}

-(NSString*)getUomNameOfTarget:(REMEnergyTargetModel*)target {
    if (REMIsNilOrNull(target)) {
        return REMEmptyString;
    } else {
        return target.uomName;
    }
}

-(void)createChartView:(CGRect)frame beginRange:(DCRange*)beginRange globalRange:(DCRange*)globalRange xFormatter:(NSFormatter*)xLabelFormatter step:(REMEnergyStep)step{
    DCXYChartView* view = [[DCXYChartView alloc]initWithFrame:frame beginHRange:beginRange];
    view.chartStyle = self.style;   
    [view setXLabelFormatter:xLabelFormatter];
    _view = view;
    view.xAxis = [[DCAxis alloc]init];
    view.xAxis.coordinate = DCAxisCoordinateX;
    
    NSMutableArray* seriesList = [[NSMutableArray alloc]initWithCapacity:self.energyViewData.targetEnergyData.count];
    NSUInteger seriesIndex = 0;
    NSUInteger seriesAmount = [self getSeriesAmount];
    for (; seriesIndex < seriesAmount; seriesIndex++) {
        DCXYSeries* s = [self createSeriesAt:seriesIndex style:self.style];
        s.coordinateSystemName = s.stacked ? [self getCoordinateNameBySeries:s inSeriesList:seriesList] : [self getUomNameOfTarget:s.target];
        [seriesList addObject:s];
    }
    
    view.graphContext.globalHRange = globalRange;
    [view setSeriesList:seriesList];
    
    view.acceptTap = self.style.acceptTap;
    view.acceptPinch = self.style.acceptPinch;
    view.acceptPan = self.style.acceptPan;
    
    view.graphContext.hGridlineAmount = self.style.horizentalGridLineAmount;
    view.graphContext.useTextLayer = self.style.useTextLayer;
    view.delegate = self;
    self.graphContext = view.graphContext;
    if (step == REMEnergyStepHour || step == REMEnergyStepWeek) {
        view.graphContext.pointHorizentalOffset = 0.5;
        view.graphContext.xLabelHorizentalOffset = 0;
    } else {
        view.graphContext.pointHorizentalOffset = 0.5;
        view.graphContext.xLabelHorizentalOffset = 0.5;
    }
    
    [self customizeView:view];
    self.animationManager.view = view;
}

//-(NSArray*)createYAxes:(NSArray*)series {
//    NSMutableArray* yAxes = [[NSMutableArray alloc]init];
//    for (DCXYSeries* s in series) {
//        for (DCAxis* y in yAxes) {
//            if ((REMIsNilOrNull(y.axisTitle) && REMIsNilOrNull(s.target.uomName)) || [y.axisTitle isEqualToString:s.target.uomName]) {
//                s.yAxis = y;
//                break;
//            }
//        }
//        if (REMIsNilOrNull(s.yAxis)) {
//            DCAxis* y = [[DCAxis alloc]init];
//            s.yAxis = y;
//            y.coordinate = DCAxisCoordinateY;
//            y.axisTitle = s.target.uomName;
//            [yAxes addObject:y];
//        }
//    }
//    return yAxes;
//}

-(void)customizeView:(DCXYChartView*)view {
    view.graphContext.showIndicatorLineOnFocus = NO;
}

-(DCXYSeries*)createSeriesAt:(NSUInteger)index style:(DCChartStyle*)style {
    REMTargetEnergyData* targetEnergy = self.energyViewData.targetEnergyData[index];
    NSMutableArray* datas = [[NSMutableArray alloc]init];
    DCTrendChartDataProcessor* processor = [self.processors objectAtIndex:index];
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
    
    DCXYSeries* s = [[DCXYSeries alloc]initWithEnergyData:datas];
    s.symbolType = [self getSymbolTypeByIndex:index];
    s.symbolSize = style.symbolSize;
    s.color = [REMColor colorByIndex:index];
    s.target = targetEnergy.target;
    
    s.seriesKey = [self getSeriesKeyByTarget:s.target seriesIndex:index];
    s.groupName = [self.chartStrategy.groupingGen getGroupName:s.target];
    DCSeriesStatus* state = self.seriesStates[s.seriesKey];
    if (REMIsNilOrNull(state)) {
        state = [self getDefaultSeriesState:s.target seriesIndex:index];
        [self.seriesStates setObject:state forKey:s.seriesKey];
    }
    
    [state applyToXYSeries:s];
    return s;
}

-(DCLineSymbolType)getSymbolTypeByIndex:(NSUInteger)index {
    return index % 5;
}

-(NSNumber*)roundDate:(NSDate*)lengthDate startDate:(NSDate*)startDate processor:(DCTrendChartDataProcessor*)processor roundToFloor:(BOOL)roundToFloor {
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
    NSUInteger seriesAmount = [self getSeriesAmount];
    _processors = [[NSMutableArray alloc]init];
    
    NSDate* baseDateOfX = nil;
    NSDate* globalStartdDate = nil;
    NSDate* globalEndDate = nil;
    NSDate* beginningStart = nil;
    NSDate* beginningEnd = nil;
    _sharedProcessor = [[DCTrendChartDataProcessor alloc]init];
    self.sharedProcessor.step = step;
    
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
    
    baseDateOfX = globalStartdDate;
    double startPoint = 0;
    double endPoint = 0;
//    if (wrapperConfig.step == REMEnergyStepHour && wrapperConfig.isMultiTimeChart) {
//        if (!REMIsNilOrNull(self.energyViewData.targetEnergyData) && self.energyViewData.targetEnergyData.count != 0) {
//            NSDate* baseDateFromEnergyData = nil;
//            for (REMTargetEnergyData* d in self.energyViewData.targetEnergyData) {
//                if (d.energyData.count > 0) {
//                    baseDateFromEnergyData = [d.energyData[0] localTime];
//                    if ([baseDateFromEnergyData compare:baseDateOfX]==NSOrderedAscending) {
//                        baseDateOfX = baseDateFromEnergyData;
//                    }
//                }
//            }
//        }
//        self.sharedProcessor.baseDate = baseDateOfX;
//        for (REMTargetEnergyData* d in self.energyViewData.targetEnergyData) {
//            REMTrendChartDataProcessor* processor = [[REMTrendChartDataProcessor alloc]init];
//            processor.step = step;
//            if (d.energyData.count > 0) {
//                processor.baseDate = [d.energyData[0] localTime];
//            } else {
//                processor.baseDate = baseDateOfX;
//            }
//            [self.processors addObject:processor];
//        }
//        startPoint = [self.sharedProcessor processX:beginningStart].doubleValue;
//        endPoint = [self.sharedProcessor processX:beginningEnd].doubleValue - startPoint;
//        startPoint = 0;
//    } else {
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
        for (int i = 0; i < seriesAmount; i++) {
            [self.processors addObject:self.sharedProcessor];
        }
        startPoint = [self.sharedProcessor processX:beginningStart].doubleValue;
        endPoint = [self.sharedProcessor processX:beginningEnd].doubleValue;
//    }
    
    double globalStart = [self.sharedProcessor processX:globalStartdDate].doubleValue;
    double globalLength = [self.sharedProcessor processX:globalEndDate].doubleValue - globalStart;
//    if (!self.graphContext.xLabelAlignToTick) globalStart+=0.5;
    
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
    [self.view defocus];
}
-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    if (seriesIndex >= self.view.seriesList.count) return;
    DCXYSeries* series = self.view.seriesList[seriesIndex];
    [self.view setSeries:series hidden:hidden];
//    if (REMIsNilOrNull(series.target)) return;
    DCSeriesStatus* state = self.seriesStates[series.seriesKey];
    if (state!=nil) state.visible = !hidden;
}

-(void)switchSeriesTypeAtIndex:(NSUInteger)index {
    if (index >= self.view.seriesList.count) return;
    DCXYSeries* series = self.view.seriesList[index];
    DCSeriesStatus* state = self.seriesStates[series.seriesKey];
    DCSeriesTypeStatus nextType = [state getNextSeriesType];
    if (nextType == state.seriesType) return;
    
    
    NSString*toCoordinateName = series.coordinateSystemName;
    if (state.seriesType == DCSeriesTypeStatusStackedColumn) {
        toCoordinateName = [self getUomNameOfTarget:series.target];
    }
    DCSeriesType sType;
    BOOL stacked = NO;
    switch (nextType) {
        case DCSeriesTypeStatusLine:
            sType = DCSeriesTypeLine;
            break;
        case DCSeriesTypeStatusColumn:
            sType = DCSeriesTypeColumn;
            break;
        case DCSeriesTypeStatusStackedColumn:
            sType = DCSeriesTypeColumn;
            toCoordinateName = [self getCoordinateNameBySeries:series inSeriesList:self.view.seriesList];
            stacked = YES;
            break;
        default:
            sType = DCSeriesTypeColumn;
            break;
    }
    state.seriesType = nextType;
    [self.view updateSeries:series type:sType coordinateName:toCoordinateName stacked:stacked];
    
//    DCXYChartView* view = self.view;
//    if (index >= view.seriesList.count) return;
//    DCXYSeries* series = view.seriesList[index];
//    DCXYSeries* replacementSeries = nil;
//    if (series.type == DCSeriesTypeColumn) {
//        DCLineSeries* newSeries = [[DCLineSeries alloc]init];
//        newSeries.symbolType = index % 5;
//        newSeries.symbolSize = self.style.symbolSize;
//        [newSeries copyFromSeries:series];
//        replacementSeries = newSeries;
//    } else if (series.type == DCSeriesTypeLine) {
//        DCColumnSeries* newSeries = [[DCColumnSeries alloc]init];
//        [newSeries copyFromSeries:series];
//        replacementSeries = newSeries;
//    }
//    if (REMIsNilOrNull(replacementSeries)) return;
//    [view replaceSeries:series byReplacement:replacementSeries];
//    ((DTrendSeriesStatus*)[self getSeriesStatusByTarget:series.target index:@(index)]).currentType = replacementSeries.type;
}

-(BOOL)canBeChangeSeriesAtIndex:(NSUInteger)index {
    if (index >= self.view.seriesList.count) return NO;
    DCXYSeries* series = self.view.seriesList[index];
    DCSeriesStatus* state = self.seriesStates[series.seriesKey];
    if (REMIsNilOrNull(state)) return NO;
    return state.seriesType != [state getNextSeriesType];
}

-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step {
    [self.animationManager invalidate];
    self.animationManager.view = nil;
    [super redraw:energyViewData];
    NSDictionary* dic = [self updateProcessorRangesFormatter:step];
    CGRect frame = self.view.frame;
    UIView* superView = self.view.superview;
    
    [self.view removeFromSuperview];
    
    _myStableRange = dic[@"beginRange"];
    [self createChartView:frame beginRange:dic[@"beginRange"] globalRange:dic[@"globalRange"] xFormatter:dic[@"xformatter"] step:step];
    [superView addSubview:self.view];
    [self updateCalendar];
}

-(void)updateCalendarType:(REMCalendarType)calendarType {
    if (calendarType == self.wrapperConfig.calendarType) return;
    self.wrapperConfig.calendarType = calendarType;
    [self updateCalendar];
}

-(void) updateCalendar {
    if (self.sharedProcessor == nil) return;
    NSMutableArray* bands = [[NSMutableArray alloc]init];
    if(self.wrapperConfig.calendarType != REMCalendarTypeNone) {
        for (REMEnergyCalendarData* calender in self.energyViewData.calendarData) {
            UIColor* fillColor = nil;
            NSString* bandString = nil;

            if (self.wrapperConfig.calendarType == REMCalendarTypeHCSeason) {
                if (calender.calendarType == REMCalenderTypeHeatSeason) {
                    fillColor = [REMColor colorByHexString:@"#fcf0e4" alpha:0.5];
                    bandString = REMIPadLocalizedString(@"Chart_Background_Text_HSeason");
                } else if (calender.calendarType == REMCalenderTypeCoolSeason) {
                    fillColor = [REMColor colorByHexString:@"#e3f0ff" alpha:0.5];
                    bandString = REMIPadLocalizedString(@"Chart_Background_Text_CSeason");
                }
            } else if (self.wrapperConfig.calendarType == REMCalenderTypeHoliday) {
                if (calender.calendarType == REMCalenderTypeHoliday || calender.calendarType == REMCalenderTypeRestTime) {
                    fillColor = [REMColor colorByHexString:@"#eaeaea" alpha:0.5];
                    bandString = REMIPadLocalizedString(@"Chart_Background_Text_NonWorkday");
                }
            }
            if (fillColor == nil) continue;
            for (REMTimeRange* range in calender.timeRanges) {
                NSNumber* start = @([self.sharedProcessor processX:range.startTime].doubleValue);
                DCRange* bandRange = [[DCRange alloc]initWithLocation:start.doubleValue length:[self.sharedProcessor processX:range.endTime].doubleValue - start.doubleValue];
                DCXYChartBackgroundBand* b = [[DCXYChartBackgroundBand alloc]init];
                b.range = bandRange;
                b.color = fillColor;
                b.direction = DCAxisCoordinateX;
                b.title = bandString;
                [bands addObject:b];
            }
        }
    }
    [self.view setBackgoundBands:bands];
}


#pragma mark - DCXYChartViewDelegate implementation
-(void)touchesBegan {
    [self.animationManager invalidate];
}
-(void)touchesEnded {
    if (![DCRange isRange:self.myStableRange equalTo:self.graphContext.hRange] && self.chartStatus == DChartStatusNormal) {
        [self panWithSpeed:0 panStopped:YES];
    }
}
-(void)tapInPlotAt:(CGPoint)point xCoordinate:(double)xLocation {
    if ([DCRange isRange:self.myStableRange equalTo:self.graphContext.hRange]) {
        if (self.chartStatus == DChartStatusNormal) {
            self.chartStatus = DChartStatusFocus;
            self.view.acceptPinch = NO;
        }
        [self.view focusAroundX:xLocation];
    }
}

-(void)panWithSpeed:(CGFloat)speed panStopped:(BOOL)stopped {
    if (!stopped) self.panSpeed = speed;
    if (self.chartStatus != DChartStatusNormal) return;
    self.view.acceptTap = NO;

    if (stopped) {
        if (self.sharedProcessor.step == REMEnergyStepHour) {
            self.myStableRange = self.view.graphContext.hRange;
        } else {
            [self.animationManager animateHRangeWithSpeed: self.panSpeed completion:^() {
                self.view.acceptTap = self.style.acceptTap;
            }];
        }
        self.panSpeed = 0;
        [self fireGestureStoppedEvent];
    }
}

-(void)fireGestureStoppedEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureEndFrom:end:)]) {
        DCRange* newRange = self.myStableRange;
        double rangeStart = newRange.location;
        double rangeEnd = newRange.location + newRange.length;
        id start, end;
        if (!REMIsNilOrNull(self.sharedProcessor) && self.sharedProcessor.step != REMEnergyStepNone) {
            start = [self.sharedProcessor deprocessX:rangeStart];
            end = [self.sharedProcessor deprocessX:rangeEnd];
        } else {
            start = @(rangeStart);
            end = @(rangeEnd);
        }
        [self.delegate performSelector:@selector(gestureEndFrom:end:) withObject:start withObject:end];
    }
}
-(void)focusPointChanged:(NSArray *)dcpoints at:(int)x {
    if (self.delegate && [[self.delegate class] conformsToProtocol:@protocol(DCChartTrendWrapperDelegate)]) {
        id xVal = (REMIsNilOrNull(self.sharedProcessor)) ? @(x) : [self.sharedProcessor deprocessX:x];
        [(id<DCChartTrendWrapperDelegate>)self.delegate highlightPoints:dcpoints x:xVal];
    }
}
// 获取x轴上两个点之间的时间差，以秒为单位。
-(NSTimeInterval)getTimeIntervalFrom:(double)from to:(double)to {
    if (REMIsNilOrNull(self.sharedProcessor) || self.sharedProcessor.step == REMEnergyStepNone) return 0;
    return [[self.sharedProcessor deprocessX:to] timeIntervalSinceDate:[self.sharedProcessor deprocessX:from]];
}
-(DCRange*)updatePanRange:(DCRange *)newRange withSpeed:(double)speed {
    DCRange* updatedRange = nil;
    if (self.sharedProcessor.step == REMEnergyStepHour) {
        updatedRange = newRange;
    } else {
        double location = newRange.location;
        double end = newRange.end;
        if (location < self.graphContext.globalHRange.location) {
            location = self.graphContext.hRange.location + speed / 8;
        } else  if (end > self.graphContext.globalHRange.end) {
            location = self.graphContext.hRange.location + speed / 8;
        }
        updatedRange = [[DCRange alloc]initWithLocation:location length:self.graphContext.hRange.length];
    }
    self.myStableRange = updatedRange;
    return updatedRange;
}
-(DCRange*)updatePinchRange:(DCRange*)newRange pinchCentreX:(CGFloat)centreX pinchStopped:(BOOL)stopped {
    REMEnergyStep myStep = self.sharedProcessor.step;
    DCRange* globalRange = self.graphContext.globalHRange;
    DCRange* currentRange = self.graphContext.hRange;
    
    DCRange* updatedRange = nil;
    
    if (myStep == REMEnergyStepNone || newRange.length == currentRange.length) {
        updatedRange = newRange;
    } else {
        NSRange lengthRange = [[REMWidgetStepCalculationModel getStepIntervalRanges][myStep] rangeValue];
        NSUInteger minTimeInterval = lengthRange.location;  // 步长允许的最短的时间距离
        NSUInteger maxTimeInterval = lengthRange.location + lengthRange.length; // 步长允许的最长时间距离
        BOOL isZoomIn = newRange.length < currentRange.length;  // 正在放大视图，亦即可视的时间范围正在缩小
        
        if (myStep == REMEnergyStepHour) {
            if ([self getTimeIntervalFrom:newRange.location to:newRange.end] > maxTimeInterval) {
                updatedRange = currentRange;
            } else {
                updatedRange = newRange;
            }
        } else {
            /*** 对于左边界已经越界的情况(在时间选择器内查询数据)：只检查Pinch后数据的长度，和右边界。 ***/
            if (self.myStableRange.location < globalRange.location) {
                double returnRangeEnd = newRange.end;
                double returnRangeStart = newRange.location;
                if (returnRangeEnd > globalRange.end) returnRangeEnd = globalRange.end;
                NSTimeInterval returnRangeInterval = [self getTimeIntervalFrom:returnRangeStart to:returnRangeEnd];
                if ((isZoomIn && returnRangeInterval <= minTimeInterval) || (!isZoomIn && returnRangeInterval > maxTimeInterval)) {
                    updatedRange = currentRange;
                } else {
                    updatedRange = [[DCRange alloc]initWithLocation:returnRangeStart length:returnRangeEnd-returnRangeStart];
                }
            }
            /*** 对于左边界还没有越界的情况 ***/
            else {
                NSTimeInterval currentRangeTimeInterval = [self getTimeIntervalFrom:currentRange.location to:currentRange.end];
                if (currentRange.end > globalRange.end || currentRangeTimeInterval <= minTimeInterval || currentRangeTimeInterval > maxTimeInterval) return currentRange;
                double returnRangeEnd = newRange.end;
                double returnRangeStart = newRange.location;
                double returnRangeLength = 0;
                if (isZoomIn) {
                    returnRangeLength = returnRangeEnd - returnRangeStart;
                    if ([self getTimeIntervalFrom:returnRangeStart to:returnRangeEnd] <= minTimeInterval) {
                        updatedRange = currentRange;
                    } else {
                        updatedRange = [[DCRange alloc]initWithLocation:returnRangeStart length:returnRangeLength];
                    }
                } else {
                    if (returnRangeStart < globalRange.location) returnRangeStart = globalRange.location;
                    if (returnRangeEnd > globalRange.end) returnRangeEnd = globalRange.end;
                    returnRangeLength = returnRangeEnd - returnRangeStart;
                    if ([self getTimeIntervalFrom:returnRangeStart to:returnRangeEnd] > maxTimeInterval) {
                        updatedRange = currentRange;
                    } else {
                        updatedRange = [[DCRange alloc]initWithLocation:returnRangeStart length:returnRangeLength];
                    }
                }
            }
        }
    }
    self.myStableRange = updatedRange;
    if (stopped) {
        [self fireGestureStoppedEvent];
    }
    return updatedRange;
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



#pragma mark - Fire to DCChartTrendWrapperDelegate
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
