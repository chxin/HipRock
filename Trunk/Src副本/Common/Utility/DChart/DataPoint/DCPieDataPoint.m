//
//  DCPieDataPoint.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/24/13.
//
//

#import "DCPieDataPoint.h"
#import "DCPieSeries.h"

@implementation DCPieDataPoint
-(id)init {
    self = [super init];
    if (self) {
        _hidden = NO;
    }
    return self;
}

//-(void)setHidden:(BOOL)hidden {
//    if (hidden != self.hidden) {
//        _hidden = hidden;
//        if (self.series) {
//           [((DCPieSeries*)self.series) didPointHiddenChanged:self];
//        }
//    }
//}
@end
