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
//    if (sharedProcessor == nil) {
//        sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
//        sharedProcessor.baseDate = self.baseDateOfX;
//    }
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
    REMTrendChartColumnSeries* s =[[REMTrendChartColumnSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:sharedProcessor plotStyle:nil startDate:self.baseDateOfX];
    s.target = targetEnergyData.target;
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}
@end
