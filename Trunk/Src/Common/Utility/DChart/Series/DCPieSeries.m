//
//  DCPieSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCPieSeries.h"
@interface DCPieSeries()
@end

@implementation DCPieSeries
//@synthesize sumVisableValue = _sumVisableValue;
-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [super initWithEnergyData:seriesData];
    if (self) {
        [self updateSumValue];
        for (int i = 0; i < self.datas.count; i++) {
            DCPieDataPoint* p = self.datas[i];
            if (i == self.datas.count - 1) {
                p.nextPoint = self.datas[0];
            } else {
                p.nextPoint = self.datas[i+1];
            }
        }
    }
    return self;
}

-(void)didPointHiddenChanged:(DCPieDataPoint *)point {
    _sumVisableValue = 9;
}

-(void)updateSumValue {
    double sum = 0;
    if (!REMIsNilOrNull(self.datas)) {
        for (DCPieDataPoint* point in self.datas) {
            if (!point.hidden && point.pointType == DCDataPointTypeNormal) {
                sum += point.value.doubleValue;
            }
        }
    }
    _sumVisableValue = sum;
}

-(void)setDatas:(NSArray *)datas {
    [super setDatas:datas];
    [self updateSumValue];
}
@end
