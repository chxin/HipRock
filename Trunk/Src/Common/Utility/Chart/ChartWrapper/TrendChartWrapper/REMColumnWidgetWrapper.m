//
//  REMColumnWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMColumnWidgetWrapper.h"

@implementation REMColumnWidgetWrapper
-(REMTrendChartSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
//    if (sharedProcessor == nil) {
//        sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
//        sharedProcessor.baseDate = self.baseDateOfX;
//    }
    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
    REMTrendChartColumnSeries* s =[[REMTrendChartColumnSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:sharedProcessor plotStyle:nil startDate:self.baseDateOfX];
    s.uomId = targetEnergyData.target.uomId;
    s.uomName = targetEnergyData.target.uomName;
    return s;
}
@end
