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
@property (nonatomic, strong) DCRange* beginRange;
@property (nonatomic, strong) DCRange* globalRange;
@property (nonatomic, strong) _DCXLabelFormatter* xLabelFormatter;
@property (nonatomic, strong) REMTrendChartDataProcessor* sharedProcessor;
@property (nonatomic, assign) DChartStatus chartStatus;
@property (nonatomic, weak) DCContext* graphContext;
@property (nonatomic, strong) DCRange* myStableRange;
@property (nonatomic, assign) BOOL isStacked;
@end

@implementation DCTrendWrapper
-(UIView*)getView {
    return self.view;
}
-(DCTrendWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*)widgetSyntax style:(REMChartStyle*)style {
    self = [self init];
    if (self && energyViewData.targetEnergyData.count != 0) {
        [self extraSyntax:widgetSyntax];
        _chartStatus = DChartStatusNormal;
        _energyViewData = energyViewData;
        [self updateProcessorRangesFormatter:widgetSyntax.xtype step:widgetSyntax.step.integerValue];
        
        
        DCXYChartView* view = [[DCXYChartView alloc]initWithFrame:frame beginHRange:self.beginRange stacked:self.isStacked];
        [view setXLabelFormatter:self.xLabelFormatter];
        _view = view;
        view.xAxis = [[DCAxis alloc]init];
        view.yAxis0 = [[DCAxis alloc]init];
        view.yAxis1 = [[DCAxis alloc]init];
        view.yAxis2 = [[DCAxis alloc]init];
        NSMutableArray* seriesList = [[NSMutableArray alloc]initWithCapacity:energyViewData.targetEnergyData.count];
        NSUInteger seriesIndex = 0;
        NSUInteger seriesAmount = [self getSeriesAmount];
        for (; seriesIndex < seriesAmount; seriesIndex++) {
            [seriesList addObject:[self createSeriesAt:seriesIndex style:style]];
        }
        view.graphContext.globalHRange = self.globalRange;
        view.seriesList = seriesList;
        
        view.userInteractionEnabled = style.userInteraction;
        
        if (style.xLineStyle) {
            view.xAxis.lineColor = style.xLineStyle.lineColor.uiColor;
            view.xAxis.lineWidth = style.xLineStyle.lineWidth;
        }
        if (style.xTextStyle) {
            view.xAxis.labelColor = style.xTextStyle.color.uiColor;
            view.xAxis.labelFont = [UIFont fontWithName:style.xTextStyle.fontName size:style.xTextStyle.fontSize];
        }
        if (style.yGridlineStyle) {
            view.hGridlineColor = style.yGridlineStyle.lineColor.uiColor;
            view.hGridlineWidth = style.yGridlineStyle.lineWidth;
        }
        
        if (style.yLineStyle) {
            view.yAxis0.lineColor = style.yLineStyle.lineColor.uiColor;
            view.yAxis1.lineColor = style.yLineStyle.lineColor.uiColor;
            view.yAxis2.lineColor = style.yLineStyle.lineColor.uiColor;
            view.yAxis0.lineWidth = style.yLineStyle.lineWidth;
            view.yAxis1.lineWidth = style.yLineStyle.lineWidth;
            view.yAxis2.lineWidth = style.yLineStyle.lineWidth;
        }
        if (style.yTextStyle) {
            view.yAxis0.labelColor = style.yTextStyle.color.uiColor;
            view.yAxis1.labelColor = style.yTextStyle.color.uiColor;
            view.yAxis2.labelColor = style.yTextStyle.color.uiColor;
            view.yAxis0.labelFont = [UIFont fontWithName:style.yTextStyle.fontName size:style.yTextStyle.fontSize];
            view.yAxis1.labelFont = [UIFont fontWithName:style.yTextStyle.fontName size:style.yTextStyle.fontSize];
            view.yAxis2.labelFont = [UIFont fontWithName:style.yTextStyle.fontName size:style.yTextStyle.fontSize];
        }
        view.graphContext.hGridlineAmount = style.horizentalGridLineAmount;
        view.delegate = self;
        [view.graphContext addHRangeObsever:self];
    }
    return self;
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
    if (end == NSOrderedSame || end == NSOrderedDescending) {
        return length;
    } else if (roundToFloor) {
        length = @(length.intValue);
    } else {
        length = @(length.intValue+1);
    }
    return length;
}

-(void)updateProcessorRangesFormatter:(NSString*)xtype step:(REMEnergyStep)step {
    self.isStacked = ([xtype rangeOfString:@"stack"].location != NSNotFound);
    
    NSUInteger seriesAmount = [self getSeriesAmount];
    self.processors = [[NSMutableArray alloc]init];
    BOOL allSeriesUserGlobalTime = ([xtype rangeOfString : @"multitimespan"].location == NSNotFound);
    
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
    self.beginRange = [[DCRange alloc]initWithLocation:startPoint-0.5 length:endPoint-startPoint];
    self.globalRange = [[DCRange alloc]initWithLocation:-0.5 length:globalLength.doubleValue];
    self.myStableRange = self.beginRange;
    
    self.xLabelFormatter = [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1];
}

-(NSUInteger)getSeriesAmount {
    return self.energyViewData.targetEnergyData.count;
}

-(void)didHRangeChanged:(DCRange *)oldRange newRange:(DCRange *)newRange {
    if ([DCRange isRange:oldRange equalTo:newRange]) return;
    double rangeStart = newRange.location;
    double rangeEnd = newRange.location + newRange.length;
    if (rangeStart < self.globalRange.location) {
        rangeStart = self.globalRange.location;
        rangeEnd = self.globalRange.location + newRange.length;
    }
    if (rangeEnd > self.globalRange.length+self.globalRange.location) {
        rangeEnd = self.globalRange.length+self.globalRange.location;
        rangeStart = rangeEnd - newRange.length;
    }
    DCRange* myNewRange = [[DCRange alloc] initWithLocation:rangeStart length:rangeEnd-rangeStart];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(willRangeChange:end:)]) {
        if (![DCRange isRange:self.myStableRange equalTo:myNewRange]) {
            if (self.sharedProcessor == nil) {
                [self.delegate performSelector:@selector(willRangeChange:end:) withObject:@(rangeStart) withObject:@(rangeEnd)];
            } else {
                [self.delegate performSelector:@selector(willRangeChange:end:) withObject:[self.sharedProcessor deprocessX:rangeStart] withObject:[self.sharedProcessor deprocessX:rangeEnd]];
            }
        }
    }
    self.myStableRange = myNewRange;
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
    if (rangeStart < self.globalRange.location) {
        rangeStart = self.globalRange.location;
        rangeEnd = self.globalRange.location + newRange.length;
    }
    if (rangeEnd > self.globalRange.length+self.globalRange.location) {
        rangeEnd = self.globalRange.length+self.globalRange.location;
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
    
}
@end
