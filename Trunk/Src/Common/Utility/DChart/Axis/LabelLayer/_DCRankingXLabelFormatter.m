//
//  _DCRankingXLabelFormatter.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/25/13.
//
//

#import "_DCRankingXLabelFormatter.h"

@implementation _DCRankingXLabelFormatter
-(id)initWithSeries:(DCXYSeries*)series {
    self = [super init];
    if (self) {
        _series = series;
    }
    return self;
}

- (NSString *)stringForObjectValue:(id)obj {
    if (REMIsNilOrNull(self.series) || REMIsNilOrNull(self.series.datas)) return nil;
    int index = [obj intValue];
    if (index < 0 || index >= self.series.datas.count) return nil;
    DCDataPoint* point = self.series.datas[index];
    if (REMIsNilOrNull(point.target)) return nil;
    return point.target.name;
}
@end
