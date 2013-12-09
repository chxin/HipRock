//
//  DCColumnWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/18/13.
//
//

#import "DCColumnWrapper.h"

@implementation DCColumnWrapper
@synthesize defaultSeriesClass = _defaultSeriesClass;

-(id)init {
    self = [super init];
    if (self) {
        _defaultSeriesClass = @"DCColumnSeries";
    }
    return self;
}
-(void)customizeView:(DCXYChartView*)view {
    view.graphContext.showIndicatorOnFocus = NO;
}
@end
