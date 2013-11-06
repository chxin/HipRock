//
//  REMStackColumnWidgetWrapper.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
    s.target = targetEnergyData.target;
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}

@end
