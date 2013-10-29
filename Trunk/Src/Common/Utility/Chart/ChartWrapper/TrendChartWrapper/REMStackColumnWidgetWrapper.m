//
//  REMStackColumnWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/23/13.
//
//

#import "REMStackColumnWidgetWrapper.h"

@implementation REMStackColumnWidgetWrapper

-(REMTrendChartStackColumnSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
    // 翻转Stack图的序列顺序
    seriesIndex = self.energyViewData.targetEnergyData.count - seriesIndex - 1;
    
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
    REMTrendChartStackColumnSeries* s =[[REMTrendChartStackColumnSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:sharedProcessor plotStyle:nil startDate:self.baseDateOfX];
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}

@end
