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
    series.hidden = !self.visible;
    switch (self.seriesType) {
        case DCSeriesTypeStatusLine:
            series.type = DCSeriesTypeLine;
            series.stacked = NO;
            break;
        case DCSeriesTypeStatusColumn:
            series.type = DCSeriesTypeColumn;
            series.stacked = NO;
            break;
        case DCSeriesTypeStatusStackedColumn:
            series.type = DCSeriesTypeColumn;
            series.stacked = YES;
            break;
        default:
            break;
    }
    if (!REMIsNilOrNull(self.forcedColor)) {
        series.color = self.forcedColor;
    }
}
-(void)applyToPieSlice:(DCPieDataPoint*)pieSlice {
    pieSlice.hidden = !self.visible;
    if (!REMIsNilOrNull(self.forcedColor)) {
        pieSlice.color = self.forcedColor;
    }
}

-(DCSeriesTypeStatus)getNextSeriesType {
    if (self.seriesType == DCSeriesTypeStatusPie) return DCSeriesTypeStatusPie;
    DCSeriesTypeStatus typeCursor = [self getNextTrendSeriesType:self.seriesType];
    
    while (typeCursor != self.seriesType && ![self isTypeAvalible:typeCursor]) {
        typeCursor = [self getNextTrendSeriesType:typeCursor];
    }
    return typeCursor;
}

-(BOOL)isTypeAvalible:(DCSeriesTypeStatus)type {
    return (self.avilableTypes | type) == self.avilableTypes;
}

/*** ***/
-(DCSeriesTypeStatus)getNextTrendSeriesType:(DCSeriesTypeStatus)trendType {
    DCSeriesTypeStatus typeCursor;
    switch (trendType) {
        case DCSeriesTypeStatusLine:
            typeCursor = DCSeriesTypeStatusColumn;
            break;
        case DCSeriesTypeStatusColumn:
            typeCursor = DCSeriesTypeStatusStackedColumn;
            break;
        case DCSeriesTypeStatusStackedColumn:
            typeCursor = DCSeriesTypeStatusLine;
            break;
        default:
            typeCursor = trendType;
            break;
    }
    return typeCursor;
}
@end
