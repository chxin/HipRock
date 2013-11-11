/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMColumnWidgetWrapper.m
 * Created      : Zilong-Oscar.Xu on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMColumnWidgetWrapper.h"

@implementation REMColumnWidgetWrapper
-(REMTrendChartSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
    
    
    REMTrendChartDataProcessor* processor = nil;
    if (useSharedProcessor) {
        processor = sharedProcessor;
    } else {
        processor = [[REMTrendChartDataProcessor alloc]init];
        processor.step = sharedProcessor.step;
        processor.baseDate = targetEnergyData.energyData.count > 0 ? [targetEnergyData.energyData[0] localTime] : [NSDate dateWithTimeIntervalSince1970:0];
    }
    REMTrendChartColumnSeries* s =[[REMTrendChartColumnSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:processor plotStyle:nil];
    s.target = targetEnergyData.target;
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}
@end
