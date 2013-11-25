///*------------------------------Summary-------------------------------------
// * Product Name : EMOP iOS Application Software
// * File Name	: REMStackColumnWidgetWrapper.m
// * Created      : Zilong-Oscar.Xu on 10/23/13.
// * Description  : IOS Application software based on Energy Management Open Platform
// * Copyright    : Schneider Electric (China) Co., Ltd.
// --------------------------------------------------------------------------*///
//
//#import "REMStackColumnWidgetWrapper.h"
//
//@implementation REMStackColumnWidgetWrapper
//
//-(REMTrendChartStackColumnSeries*)createSeriesConfigOfIndex:(uint)seriesIndex {
//    // 翻转Stack图的序列顺序
//    seriesIndex = self.energyViewData.targetEnergyData.count - seriesIndex - 1;
//    
//    REMTargetEnergyData* targetEnergyData = (REMTargetEnergyData*)self.energyViewData.targetEnergyData[seriesIndex];
//    REMTrendChartStackColumnSeries* s =[[REMTrendChartStackColumnSeries alloc]initWithData:targetEnergyData.energyData dataProcessor:sharedProcessor plotStyle:nil];
//    s.target = targetEnergyData.target;
//    s.uomId = targetEnergyData.target.uomId;
//    s.uomName = targetEnergyData.target.uomName;
//    return s;
//}
//
//@end
