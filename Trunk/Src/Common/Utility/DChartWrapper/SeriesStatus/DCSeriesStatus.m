//
//  DCSeriesStatus.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 4/23/14.
//
//

#import "DCSeriesStatus.h"

@implementation DCSeriesStatus
//-(id)initWithTarget:(REMEnergyTargetModel *)target index:(NSNumber *)seriesIndex {
//    self = [super init];
//    if (self) {
//        if (target == nil) {
//            _seriesIndex = seriesIndex;
//        } else {
//            if (target.type != REMEnergyTargetBenchmarkValue) {
//                _targetId = [target.targetId copy];
//            }
//            _type = target.type;
//            _commodityId = target.commodityId;
//        }
//    }
//    return self;
//}
-(void)applyToXYSeries:(DCXYSeries*)series {
    series.hidden = self.hidden;
    switch (self.seriesType) {
        case DCSeriesTypeStatusLine:
            series.type = DCSeriesTypeLine;
            break;
        case DCSeriesTypeStatusColumn:
            series.type = DCSeriesTypeColumn;
            [series degroup];
            break;
        case DCSeriesTypeStatusStackedColumn:
            series.type = DCSeriesTypeColumn;
            [series groupSeries:series.target.uomName];
            break;
        default:
            break;
    }
    if (!REMIsNilOrNull(self.forcedColor)) {
        series.color = self.forcedColor;
    }
}
-(void)applyToPieSlice:(DCPieDataPoint*)pieSlice {
    pieSlice.hidden = self.hidden;
    if (!REMIsNilOrNull(self.forcedColor)) {
        pieSlice.color = self.forcedColor;
    }
}
@end
