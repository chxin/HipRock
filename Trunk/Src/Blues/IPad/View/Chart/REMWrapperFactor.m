//
//  REMWrapperFactor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/29/14.
//
//

#import "REMWrapperFactor.h"
#import "DCPieWrapper.h"
#import "DCTrendWrapper.h"
#import "DCRankingWrapper.h"
#import "DCLabelingWrapper.h"

@implementation REMWrapperFactor

+(DAbstractChartWrapper*)constructorWrapper:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig*) wrapperConfig style:(DCChartStyle*)style {
    DAbstractChartWrapper* wrapper = nil;
    if ([wrapperConfig.storeType isEqualToString:@"energy.Labeling"]) {
        wrapper = [[DCLabelingWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];
    } else if ([wrapperConfig.storeType isEqualToString:@"energy.RankUsage"]) {
        wrapper = [[DCRankingWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];
    } else {
        switch (wrapperConfig.defaultSeriesType) {
            case DCSeriesTypeStatusPie:
                wrapper = [[DCPieWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];
                break;
            case DCSeriesTypeStatusColumn:
            case DCSeriesTypeStatusLine:
            case DCSeriesTypeStatusStackedColumn:
                wrapper = [[DCTrendWrapper alloc]initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];
                break;
            default:
                break;
        }
    }
    return wrapper;
}
@end
