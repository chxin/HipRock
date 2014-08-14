//
//  DCColumnSeriesGroup.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 6/3/14.
//
//

#import "DCColumnSeriesGroup.h"
#import "_DCCoordinateSystem.h"
#import "DCXYChartView.h"

@interface DCColumnSeriesGroup()
@property (nonatomic, strong) NSMutableArray* seriesList;
@end

@implementation DCColumnSeriesGroup
-(id)initWithGroupName:(NSString*)groupName coordinateSystem:(_DCCoordinateSystem*)coordinateSystem {
    self = [super init];
    if (self) {
        _groupName = groupName;
        _coordinateSystem = coordinateSystem;
        _seriesList = [[NSMutableArray alloc]init];
    }
    return self;
}
-(NSUInteger)getCount {
    return self.seriesList.count;
}
-(NSArray*)getAllSeries {
    return self.seriesList;
}
-(void)addSeries:(DCXYSeries*)series {
    NSArray* seriesList = self.coordinateSystem.chartView.seriesList;
    if ([self containsSeries:series] || ![seriesList containsObject:series]) return;
    [self.seriesList addObject:series];
    self.seriesList = [[seriesList sortedArrayUsingComparator:^NSComparisonResult(DCXYSeries* obj1, DCXYSeries* obj2) {
        NSUInteger index1 = [seriesList indexOfObject:obj1];
        NSUInteger index2 = [seriesList indexOfObject:obj2];
        return [@(index1) compare:@(index2)];
    }] mutableCopy];
}
-(BOOL)containsSeries:(DCXYSeries*)series {
    return [self.seriesList containsObject:series];
}
-(void)removeSeries:(DCXYSeries*)series {
    if ([self containsSeries:series]) [self.seriesList removeObject:series];
}
@end
