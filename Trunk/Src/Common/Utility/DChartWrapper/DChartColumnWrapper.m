//
//  DChartColumnWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/18/13.
//
//

#import "DChartColumnWrapper.h"
#import "REMChartHeader.h"  // FOR IMPORT REMChartDataProcessor only

@implementation DChartColumnWrapper

-(DChartColumnWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
    self = [super init];
    if (self) {
        _energyViewData = energyViewData;
        
        DCXYChartView* view = [[DCXYChartView alloc]initWithFrame:CGRectMake(0, 0, 1024, 748) beginHRange:[[DCRange alloc]initWithLocation:-0.5 length:10] stacked:NO];
        
        view.xAxis = [[DCAxis alloc]init];
        view.yAxis0 = [[DCAxis alloc]init];
        view.yAxis1 = [[DCAxis alloc]init];
        view.yAxis2 = [[DCAxis alloc]init];
        
        REMTrendChartDataProcessor* processor = [[REMTrendChartDataProcessor alloc]init];
        processor.step = widgetSyntax.step.integerValue;
        NSRange range = [widgetSyntax.xtype rangeOfString : @"multitimespan"];
        BOOL allSeriesUserGlobalTime = (range.location == NSNotFound);
        if (allSeriesUserGlobalTime) {
            NSDate* processorBaseTime;
            NSDate* globalEndDate;
            if (self.energyViewData.targetGlobalData != nil && self.energyViewData.targetGlobalData.energyData.count != 0) {
                processorBaseTime = ((REMEnergyData*)self.energyViewData.targetGlobalData.energyData[0]).localTime;
                globalEndDate = ((REMEnergyData*)self.energyViewData.targetGlobalData.energyData[self.energyViewData.targetGlobalData.energyData.count-1]).localTime;
            } else {
                REMTargetEnergyData* se = self.energyViewData.targetEnergyData[0];
                if (se.energyData.count == 0) {
                    processorBaseTime = [NSDate dateWithTimeIntervalSince1970:0];
                    globalEndDate = processorBaseTime;
                } else {
                    processorBaseTime = ((REMEnergyData*)se.energyData[0]).localTime;
                    globalEndDate = ((REMEnergyData*)se.energyData[se.energyData.count-1]).localTime;
                }
            }
            processor.baseDate = processorBaseTime;
        }
        
        NSMutableArray* seriesList = [[NSMutableArray alloc]initWithCapacity:energyViewData.targetEnergyData.count];
        for (REMTargetEnergyData* targetEnergy in energyViewData.targetEnergyData) {
            NSMutableArray* datas = [[NSMutableArray alloc]init];
            if (!allSeriesUserGlobalTime && targetEnergy.energyData.count > 0) {
                processor.baseDate = ((REMEnergyData*)targetEnergy.energyData[0]).localTime;
            }
            for (REMEnergyData* point in targetEnergy.energyData) {
                int processedX = [processor processX:point.localTime].integerValue;
                while (datas.count < processedX) {
                    [datas addObject:[[DCDataPoint alloc]init]];
                }
                DCDataPoint* p = [[DCDataPoint alloc]init];
                p.value = point.dataValue;
                [datas addObject:p];
            }
            DCColumnSeries* s = [[DCColumnSeries alloc]initWithData:datas];
            s.xAxis = view.xAxis;
            if (view.yAxis0.axisTitle == nil) {
                s.yAxis = view.yAxis0;
                s.yAxis.axisTitle = targetEnergy.target.uomName;
            } else if ([view.yAxis0.axisTitle isEqualToString:targetEnergy.target.uomName]){
                s.yAxis = view.yAxis0;
            } else if (view.yAxis1.axisTitle == nil) {
                s.yAxis = view.yAxis1;
                s.yAxis.axisTitle = targetEnergy.target.uomName;
            } else if ([view.yAxis1.axisTitle isEqualToString:targetEnergy.target.uomName]){
                s.yAxis = view.yAxis1;
            } else if (view.yAxis2.axisTitle == nil) {
                s.yAxis = view.yAxis2;
                s.yAxis.axisTitle = targetEnergy.target.uomName;
            } else if ([view.yAxis2.axisTitle isEqualToString:targetEnergy.target.uomName]){
                s.yAxis = view.yAxis2;
            } else {
                continue; // We just support 3 axes for now.
            }
            [seriesList addObject:s];
        }
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
@end
