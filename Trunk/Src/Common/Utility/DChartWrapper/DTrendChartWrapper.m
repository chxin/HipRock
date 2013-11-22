//
//  DTrendChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DTrendChartWrapper.h"
#import "_DCXLabelFormatter.h"

@interface DTrendChartWrapper()
@property (nonatomic, strong) NSMutableArray* processors;
@property (nonatomic, strong) DCRange* beginRange;
@property (nonatomic, strong) DCRange* globalRange;
@property (nonatomic, strong) _DCXLabelFormatter* xLabelFormatter;
@end

@implementation DTrendChartWrapper
-(DTrendChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
    self = [self init];
    if (self && energyViewData.targetEnergyData.count != 0) {
        _energyViewData = energyViewData;
        [self updateProcessorRangesFormatter:widgetSyntax.xtype step:widgetSyntax.step.integerValue];
        
        
        DCXYChartView* view = [[DCXYChartView alloc]initWithFrame:frame beginHRange:self.beginRange stacked:NO];
        [view setXLabelFormatter:self.xLabelFormatter];
        view.xAxis = [[DCAxis alloc]init];
        view.yAxis0 = [[DCAxis alloc]init];
        view.yAxis1 = [[DCAxis alloc]init];
        view.yAxis2 = [[DCAxis alloc]init];
        NSMutableArray* seriesList = [[NSMutableArray alloc]initWithCapacity:energyViewData.targetEnergyData.count];
        NSUInteger seriesIndex = 0;
        for (REMTargetEnergyData* targetEnergy in energyViewData.targetEnergyData) {
            NSMutableArray* datas = [[NSMutableArray alloc]init];
            REMTrendChartDataProcessor* processor = [self.processors objectAtIndex:seriesIndex];
            for (REMEnergyData* point in targetEnergy.energyData) {
                int processedX = [processor processX:point.localTime].integerValue;
                while (datas.count < processedX) {
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
                continue; // We just support 3 axes for now.
            }
            [self customizeSeries:s seriesIndex:seriesIndex chartStyle:style];
            [seriesList addObject:s];
            seriesIndex++;
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
        _view = view;
    }
    return self;
}

-(void)customizeSeries:(DCXYSeries*)series seriesIndex:(int)index chartStyle:(REMChartStyle*)style {
    // Nothing to do.
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
    NSUInteger seriesAmount = [self getSeriesAmount];
    self.processors = [[NSMutableArray alloc]init];
    NSRange range = [xtype rangeOfString : @"multitimespan"];
    BOOL allSeriesUserGlobalTime = (range.location == NSNotFound);
    
    NSDate* baseDateOfX = nil;
    NSDate* globalEndDate = nil;
    NSDate* beginningStart = self.energyViewData.visibleTimeRange.startTime;
    NSDate* beginningEnd = self.energyViewData.visibleTimeRange.endTime;
    
    if (REMIsNilOrNull(self.energyViewData.globalTimeRange)) {
        baseDateOfX = beginningStart;
        globalEndDate = beginningEnd;
    } else {
        baseDateOfX = self.energyViewData.globalTimeRange.startTime;
        globalEndDate = self.energyViewData.globalTimeRange.endTime;
    }
    
    REMTrendChartDataProcessor* sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    sharedProcessor.step = step;
    
    if (allSeriesUserGlobalTime) {
        for (int i = 0; i < seriesAmount; i++) {
            [self.processors addObject:sharedProcessor];
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
    
    sharedProcessor.baseDate = baseDateOfX;
    NSNumber* globalLength = @([self roundDate:globalEndDate startDate:baseDateOfX processor:sharedProcessor roundToFloor:NO].intValue+1);
    int startPoint = [self roundDate:beginningStart startDate:baseDateOfX processor:sharedProcessor roundToFloor:YES].intValue;
    int endPoint = [self roundDate:beginningEnd startDate:baseDateOfX processor:sharedProcessor roundToFloor:NO].intValue;
    self.beginRange = [[DCRange alloc]initWithLocation:startPoint-0.5 length:endPoint-startPoint];
    self.globalRange = [[DCRange alloc]initWithLocation:-0.5 length:globalLength.doubleValue];
    
    self.xLabelFormatter = [[_DCXLabelFormatter alloc]initWithStartDate:baseDateOfX dataStep:step interval:1];
}

-(NSUInteger)getSeriesAmount {
    return self.energyViewData.targetEnergyData.count;
}
@end
