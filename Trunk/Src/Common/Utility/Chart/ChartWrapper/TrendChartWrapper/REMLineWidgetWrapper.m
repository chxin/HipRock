//
//  REMLineWidget.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMLineWidgetWrapper.h"

@implementation REMLineWidgetWrapper
-(REMTrendChartSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
    REMTrendChartLineSeries* s =[[REMTrendChartLineSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:sharedProcessor plotStyle:nil startDate:self.baseDateOfX];
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}
@end
