//
//  DTrendChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DCTrendWrapper.h"
#import "_DCXLabelFormatter.h"

typedef enum _DChartStatus {
    DChartStatusNormal,
    DChartStatusFocus
}DChartStatus;

@interface DCTrendWrapper()
@property (nonatomic, strong) NSMutableArray* processors;
//@property (nonatomic, strong) DCRange* beginRange;
//@property (nonatomic, strong) DCRange* globalRange;
@property (nonatomic, strong) _DCXLabelFormatter* xLabelFormatter;
@property (nonatomic, strong) REMTrendChartDataProcessor* sharedProcessor;
@property (nonatomic, assign) DChartStatus chartStatus;
@property (nonatomic, weak) DCContext* graphContext;
@property (nonatomic, strong) DCRange* myStableRange;
@property (nonatomic, assign) BOOL isStacked;
@property (nonatomic) NSString* xtypeOfWidget;
@property (nonatomic) REMChartStyle* style;
@end

@implementation DCTrendWrapper
-(UIView*)getView {
    return self.view;
}
-(DCTrendWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*)widgetSyntax style:(REMChartStyle*)style {
    self = [self init];
    if (self && energyViewData.targetEnergyData.count != 0) {
        _calenderType = REMCalendarTypeNone;
        self.xtypeOfWidget = widgetSyntax.xtype;
        [self extraSyntax:widgetSyntax];
        _style = style;
        
        _chartStatus = DChartStatusNormal;
        _energyViewData = energyViewData;
        NSDictionary* dic = [self updateProcessorRangesFormatter:widgetSyntax.step.integerValue];
        
        [self createChartView:frame beginRange:dic[@"beginRange"] globalRange:dic[@"globalRange"]];
        [self updateCalender];
    }
    return self;
}

-(void)createChartView:(CGRect)frame beginRange:(DCRange*)beginRange globalRange:(DCRange*)globalRange {
    DCXYChartView* view = [[DCXYChartView alloc]initWithFrame:frame beginHRange:beginRange stacked:self.isStacked];
    [view setXLabelFormatter:self.xLabelFormatter];
    _view = view;
    view.xAxis = [[DCAxis alloc]init];
    view.yAxis0 = [[DCAxis alloc]init];
    view.yAxis1 = [[DCAxis alloc]init];
    view.yAxis2 = [[DCAxis alloc]init];
    NSMutableArray* seriesList = [[NSMutableArray alloc]initWithCapacity:self.energyViewData.targetEnergyData.count];
    NSUInteger seriesIndex = 0;
    NSUInteger seriesAmount = [self getSeriesAmount];
    for (; seriesIndex < seriesAmount; seriesIndex++) {
        [seriesList addObject:[self createSeriesAt:seriesIndex style:self.style]];
    }
    view.graphContext.globalHRange = globalRange;
    view.seriesList = seriesList;
    
    view.userInteractionEnabled = self.style.userInteraction;
    
    if (self.style.xLineStyle) {
        view.xAxis.lineColor = self.style.xLineStyle.lineColor.uiColor;
        view.xAxis.lineWidth = self.style.xLineStyle.lineWidth;
    }
    if (self.style.xTextStyle) {
        view.xAxis.labelColor = self.style.xTextStyle.color.uiColor;
        view.xAxis.labelFont = [UIFont fontWithName:self.style.xTextStyle.fontName size:self.style.xTextStyle.fontSize];
    }
    if (self.style.yGridlineStyle) {
        view.hGridlineColor = self.style.yGridlineStyle.lineColor.uiColor;
        view.hGridlineWidth = self.style.yGridlineStyle.lineWidth;
    }
    
    if (self.style.yLineStyle) {
        view.yAxis0.lineColor = self.style.yLineStyle.lineColor.uiColor;
        view.yAxis1.lineColor = self.style.yLineStyle.lineColor.uiColor;
        view.yAxis2.lineColor = self.style.yLineStyle.lineColor.uiColor;
        view.yAxis0.lineWidth = self.style.yLineStyle.lineWidth;
        view.yAxis1.lineWidth = self.style.yLineStyle.lineWidth;
        view.yAxis2.lineWidth = self.style.yLineStyle.lineWidth;
    }
    if (self.style.yTextStyle) {
        view.yAxis0.labelColor = self.style.yTextStyle.color.uiColor;
        view.yAxis1.labelColor = self.style.yTextStyle.color.uiColor;
        view.yAxis2.labelColor = self.style.yTextStyle.color.uiColor;
        view.yAxis0.labelFont = [UIFont fontWithName:self.style.yTextStyle.fontName size:self.style.yTextStyle.fontSize];
        view.yAxis1.labelFont = [UIFont fontWithName:self.style.yTextStyle.fontName size:self.style.yTextStyle.fontSize];
        view.yAxis2.labelFont = [UIFont fontWithName:self.style.yTextStyle.fontName size:self.style.yTextStyle.fontSize];
    }
    view.graphContext.hGridlineAmount = self.style.horizentalGridLineAmount;
    view.delegate = self;
    self.graphContext = view.graphContext;
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
        while ((int)datas.count < processedX) {
            DCDataPoint* p = [[DCDataPoint alloc]init];
            p.target = targetEnergy.target;
            p.pointType = DCDataPointTypeEmpty;
            [datas addObject:p];
        }
        DCDataPoint* p = [[DCDataPoint alloc]init];
        p.energyData = point;
        p.target = targetEnergy.target;
        p.value = point.dataValue;
        if (REMIsNilOrNull(p.value)) {
            p.pointType = DCDataPointTypeBreak;
        } else {
            p.pointType = DCDataPointTypeNormal;
        }
        [datas addObject:p];
    }
    DCXYSeries* s = [[NSClassFromString(self.defaultSeriesClass) alloc]initWithEnergyData:datas];
    s.xAxis = view.xAxis;
    if (REMIsNilOrNull(view.yAxis0.axisTitle)) {
        s.yAxis = view.yAxis0;
        s.yAxis.axisTitle = targetEnergy.target.uomName;
    } else if ([view.yAxis0.axisTitle isEqualToString:targetEnergy.target.uomName]){
        s.yAxis = view.yAxis0;
    } else if (REMIsNilOrNull(view.yAxis1.axisTitle)) {
        s.yAxis = view.yAxis1;
        s.yAxis.axisTitle = targetEnergy.target.uomName;
    } else if ([view.yAxis1.axisTitle isEqualToString:targetEnergy.target.uomName]){
        s.yAxis = view.yAxis1;
    } else if (REMIsNilOrNull(view.yAxis2.axisTitle)) {
        s.yAxis = view.yAxis2;
        s.yAxis.axisTitle = targetEnergy.target.uomName;
    } else if ([view.yAxis2.axisTitle isEqualToString:targetEnergy.target.uomName]){
        s.yAxis = view.yAxis2;
    } else {
        
    }
    s.target = targetEnergy.target;
    [self customizeSeries:s seriesIndex:index chartStyle:style];
    return s;
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
    self.isStacked = ([self.xtypeOfWidget rangeOfString:@"stack"].location != NSNotFound);
    
    NSUInteger seriesAmount = [self getSeriesAmount];
    self.processors = [[NSMutableArray alloc]init];
    BOOL allSeriesUserGlobalTime = ([self.xtypeOfWidget rangeOfString : @"multitimespan"].location == NSNotFound);
    
    NSDate* baseDateOfX = nil;
    NSDate* globalEndDate = nil;
    NSDate* beginningStart = self.energyViewData.visibleTimeRange.startTime;
    NSDate* beginningEnd = self.energyViewData.visibleTimeRange.endTime;
    
    if (REMIsNilOrNull(self.energyViewData.globalTimeRange)) {
        baseDateOfX = beginningStart;
        globalEndDate = beginningEnd;
    } else {
        baseDateOfX = self.energyViewData.globalTimeRange.startTime;
        if ([baseDateOfX compare:beginningStart]==NSOrderedDescending) {
            baseDateOfX = beginningStart;
        }
        globalEndDate = self.energyViewData.globalTimeRange.endTime;
        if ([globalEndDate compare:beginningEnd]==NSOrderedAscending) {
            globalEndDate = beginningEnd;
        }
    }
    
    self.sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    self.sharedProcessor.step = step;
    
    if (allSeriesUserGlobalTime) {
        for (int i = 0; i < seriesAmount; i++) {
            [self.processors addObject:self.sharedProcessor];
        }
    } else {
        for (REMTargetEnergyData* targetEnergy in self.energyViewData.targetEnergyData) {
            REMTrendChartDataProcessor* processor = [[REMTrendChartDataProcessor alloc]init];
            processor.step = step;
            if (targetEnergy.energyData.count == 0) {
                processor.baseDate = [NSDate dateWithTimeIntervalSince1970:0];
            } else {
                NSDate* seriesBeginDate = [targetEnergy.energyData[0] localTime];
                NSDate* seriesEndDate = [targetEnergy.energyData[targetEnergy.energyData.count-1] localTime];
                if (baseDateOfX == nil) {
                    baseDateOfX = seriesBeginDate;
                    globalEndDate = seriesEndDate;
                } else {
                    if ([baseDateOfX compare:seriesBeginDate] == NSOrderedDescending) {
                        baseDateOfX = seriesBeginDate;
                        globalEndDate = seriesEndDate;
                    }
                }
                processor.baseDate = seriesBeginDate;
            }
            [self.processors addObject:processor];
        }
    }
    
    self.sharedProcessor.baseDate = baseDateOfX;
    NSNumber* globalLength = @([self roundDate:globalEndDate startDate:baseDateOfX processor:self.sharedProcessor roundToFloor:NO].intValue);
    int startPoint = [self roundDate:beginningStart startDate:baseDateOfX processor:self.sharedProcessor roundToFloor:YES].intValue;
    int endPoint = [self roundDate:beginningEnd startDate:baseDateOfX processor:self.sharedProcessor roundToFloor:NO].intValue;
    DCRange* beginRange = [[DCRange alloc]initWithLocation:startPoint-0.5 length:endPoint-startPoint];
    DCRange* globalRange = [[DCRange alloc]initWithLocation:-0.5 length:globalLength.doubleValue];
    self.myStableRange = beginRange;
    
    self.xLabelFormatter = [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1];
    return @{ @"globalRange": globalRange, @"beginRange": beginRange };
}

-(NSUInteger)getSeriesAmount {
    return self.energyViewData.targetEnergyData.count;
}

-(void)touchedInPlotAt:(CGPoint)point xCoordinate:(double)xLocation {
    if (self.chartStatus == DCDataPointTypeNormal) {
        self.chartStatus = DChartStatusFocus;
    }
    [self.view focusAroundX:xLocation];
}

-(BOOL)panInPlotAt:(CGPoint)point translation:(CGPoint)translation {
    if (self.chartStatus == DCDataPointTypeNormal) {
        return YES;
    } else {
        [self.view focusAroundX:[self.view getXLocationForPoint:point]];
        return NO;
    }
}

-(void)panStopped {
    DCRange* newRange = self.graphContext.hRange;
    double rangeStart = newRange.location;
    double rangeEnd = newRange.location + newRange.length;
    if (rangeStart < self.graphContext.globalHRange.location) {
        rangeStart = self.graphContext.globalHRange.location;
        rangeEnd = self.graphContext.globalHRange.location + newRange.length;
    }
    if (rangeEnd > self.graphContext.globalHRange.end) {
        rangeEnd = self.graphContext.globalHRange.end;
        rangeStart = rangeEnd - newRange.length;
    }
    DCRange* myNewRange = [[DCRange alloc] initWithLocation:rangeStart length:rangeEnd-rangeStart];
    self.myStableRange = myNewRange;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchEndedInNormalStatus:end:)]) {
        if (self.sharedProcessor == nil) {
            [self.delegate performSelector:@selector(touchEndedInNormalStatus:end:) withObject:@(rangeStart) withObject:@(rangeEnd)];
        } else {
            [self.delegate performSelector:@selector(touchEndedInNormalStatus:end:) withObject:[self.sharedProcessor deprocessX:rangeStart] withObject:[self.sharedProcessor deprocessX:rangeEnd]];
        }
    }
}

-(void)focusPointChanged:(NSArray *)dcpoints {
    if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoints:)]) {
        [self.delegate performSelector:@selector(highlightPoints:) withObject:dcpoints];
    }
}

-(void)cancelToolTipStatus {
    self.chartStatus = DCDataPointTypeNormal;
    [self.view defocus];
}
-(void)setSeriesHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    if (seriesIndex >= self.view.seriesList.count) return;
    DCXYSeries* series = self.view.seriesList[seriesIndex];
    series.hidden = hidden;
}
-(void)extraSyntax:(REMWidgetContentSyntax*)syntax {
    _calenderType = syntax.calendarType;
}
-(void)redraw:(REMEnergyViewData *)energyViewData step:(REMEnergyStep)step {
    _energyViewData = energyViewData;
    NSDictionary* dic = [self updateProcessorRangesFormatter:step];
    CGRect frame = self.view.frame;
    UIView* superView = self.view.superview;
    [self.view removeFromSuperview];
    _chartStatus = DChartStatusNormal;
    
    [self createChartView:frame beginRange:dic[@"beginRange"] globalRange:dic[@"globalRange"]];
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
            if (self.calenderType == REMCalendarTypeHCSeason) {
                if (calender.calendarType == REMCalenderTypeHeatSeason) {
                    fillColor = [REMColor colorByHexString:@"#fcf0e4" alpha:0.5];
                } else if (calender.calendarType == REMCalenderTypeCoolSeason) {
                    fillColor = [REMColor colorByHexString:@"#e3f0ff" alpha:0.5];
                }
            } else if (self.calenderType == REMCalenderTypeHoliday) {
                if (calender.calendarType == REMCalenderTypeHoliday || calender.calendarType == REMCalenderTypeRestTime) {
                    fillColor = [REMColor colorByHexString:@"#eaeaea" alpha:0.5];
                }
            }
            if (fillColor == nil) continue;
            for (REMTimeRange* range in calender.timeRanges) {
                NSNumber* start = @([self.sharedProcessor processX:range.startTime].doubleValue-0.5);
                DCRange* bandRange = [[DCRange alloc]initWithLocation:start.doubleValue length:[self.sharedProcessor processX:range.endTime].doubleValue -0.5 - start.doubleValue];
                DCXYChartBackgroundBand* b = [[DCXYChartBackgroundBand alloc]init];
                b.range = bandRange;
                b.color = fillColor;
                [bands addObject:b];
            }
        }
    }
    [self.view setBackgoundBands:bands];
}

-(BOOL)testHRangeChange:(DCRange *)newRange oldRange:(DCRange *)oldRange sendBy:(DCHRangeChangeSender)senderType {
    if (senderType == DCHRangeChangeSenderByAnimation || senderType == DCHRangeChangeSenderByInitialize) return YES;
    if ([DCRange isRange:oldRange equalTo:newRange]) return NO;
    
    if (senderType == DCHRangeChangeSenderByUserPan) {
        double rangeStart = newRange.location;
        double rangeEnd = newRange.end;
        if (rangeStart < self.graphContext.globalHRange.location) {
            rangeStart = self.graphContext.globalHRange.location;
            rangeEnd = self.graphContext.globalHRange.location + newRange.length;
        }
        if (rangeEnd > self.graphContext.globalHRange.end) {
            rangeEnd = self.graphContext.globalHRange.end;
            rangeStart = rangeEnd - newRange.length;
        }
        
        DCRange* myNewRange = [[DCRange alloc] initWithLocation:rangeStart length:rangeEnd-rangeStart];
        BOOL shouldChange = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(willRangeChange:end:)]) {
            if (![DCRange isRange:self.myStableRange equalTo:myNewRange]) {
                id param0, param1;
                if (self.sharedProcessor == nil) {
                    param0 = @(rangeStart);
                    param1 = @(rangeEnd);
                } else {
                    param0 = [self.sharedProcessor deprocessX:rangeStart];
                    param1 = [self.sharedProcessor deprocessX:rangeEnd];
                }
                shouldChange = (BOOL)[self.delegate performSelector:@selector(willRangeChange:end:) withObject:param0 withObject:param1];
            }
        }
        if (shouldChange) self.myStableRange = myNewRange;
        return shouldChange;
    } else {
        BOOL shouldChange = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(willRangeChange:end:)]) {
            id param0, param1;
            if (self.sharedProcessor == nil) {
                param0 = @(newRange.location);
                param1 = @(newRange.end);
            } else {
                param0 = [self.sharedProcessor deprocessX:newRange.location];
                param1 = [self.sharedProcessor deprocessX:newRange.end];
            }
            shouldChange = (BOOL)[self.delegate performSelector:@selector(willRangeChange:end:) withObject:param0 withObject:param1];
        }
        if (shouldChange) {
            self.myStableRange = newRange;
            [self updateCalender];
        }
        return shouldChange;
    }
}

@end
