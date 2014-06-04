//
//  DCColumnSeriesGroup.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 6/3/14.
//
//

#import "DCColumnSeriesGroup.h"
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
    if (![self containsSeries:series]) [self.seriesList addObject:series];
}
-(BOOL)containsSeries:(DCXYSeries*)series {
    return [self.seriesList containsObject:series];
}
-(void)removeSeries:(DCXYSeries*)series {
    if ([self containsSeries:series]) [self.seriesList removeObject:series];
}
@end
