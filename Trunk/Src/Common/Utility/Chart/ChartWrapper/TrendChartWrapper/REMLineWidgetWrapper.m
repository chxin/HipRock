/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLineWidget.m
 * Created      : Zilong-Oscar.Xu on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMLineWidgetWrapper.h"

@implementation REMLineWidgetWrapper
-(REMTrendChartSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
    REMTrendChartLineSeries* s =[[REMTrendChartLineSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:sharedProcessor plotStyle:nil startDate:self.baseDateOfX];
    s.target = targetEnergyData.target;
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}
@end
