//
//  DCPieSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCPieSeries.h"

@implementation DCPieSeries
-(DCSeries*)initWithEnergyData:(NSArray*)seriesData {
    self = [super initWithEnergyData:seriesData];
    if (self) {
//        [self updateSumValueAndSlices];
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

//-(void)didPointHiddenChanged:(DCPieDataPoint *)point {
//    [self updateSumValueAndSlices];
//}

//-(NSUInteger)findIndexOfSlide:(CGFloat)angle {
//    angle = 2 - angle;
//    NSUInteger index = 0;
//    for (int i = 0; i < self.pieSlices.count; i++) {
//        if (REMIsNilOrNull(self.pieSlices) || REMIsNilOrNull(self.pieSlices[i])) continue;
//        DCPieSlice slice;
//        [self.pieSlices[i] getValue:&slice];
//        if (slice.sliceEnd > angle) {
//            index = i;
//            break;
//        }
//    }
//    return index;
//}
//
//-(CGFloat)findNearbySliceCenter:(CGFloat)angle {
//    DCPieSlice slice;
//    [self.pieSlices[[self findIndexOfSlide:angle]] getValue:&slice];
//    return slice.sliceCenter;
//}

//-(void)updateSumValueAndSlices {
////    double sum = 0;
//    double previesSum[self.datas.count];
//    NSMutableArray* slices = [[NSMutableArray alloc]init];
//    if (!REMIsNilOrNull(self.datas)) {
//        int index = 0;
//        for (DCPieDataPoint* point in self.datas) {
//            previesSum[index] = sum;
//            if (!point.hidden && point.pointType == DCDataPointTypeNormal) {
//                sum += point.value.doubleValue;
//            }
//            index++;
//        }
//    }
//    int index = 0;
//    for (DCPieDataPoint* point in self.datas) {
//        if (!point.hidden && point.pointType == DCDataPointTypeNormal && sum != 0 && point.value.doubleValue != 0) {
//            DCPieSlice slice;
//            slice.sliceBegin = previesSum[index] * 2 / sum;
//            slice.sliceEnd = slice.sliceBegin + point.value.doubleValue * 2 / sum;
//            slice.sliceCenter = (slice.sliceBegin + slice.sliceEnd) / 2;
//            [slices addObject:[NSValue value:&slice withObjCType:@encode(DCPieSlice)]];
//        } else {
//            [slices addObject:[NSNull null]];
//        }
//        index++;
//    }
//    _pieSlices = slices;
//    _sumVisableValue = sum;
//}

//-(void)setDatas:(NSArray *)datas {
//    [super setDatas:datas];
//    [self updateSumValueAndSlices];
//}
@end
