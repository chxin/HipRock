//
//  DCColumnWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/18/13.
//
//

#import "DCColumnWrapper.h"

@implementation DCColumnWrapper
-(id)init {
    self = [super init];
    if (self) {
        self.defaultSeriesType = DCSeriesTypeColumn;
    }
    return self;
}
-(void)customizeView:(DCXYChartView*)view {
    view.graphContext.showIndicatorLineOnFocus = NO;
}
@end
