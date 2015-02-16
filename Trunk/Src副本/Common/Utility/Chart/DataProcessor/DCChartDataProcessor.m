//
//  DCChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import "DCChartDataProcessor.h"

@implementation DCChartDataProcessor
-(NSNumber*)processX:(NSDate*)xLocalTime {
    return [NSNumber numberWithInt: [xLocalTime timeIntervalSince1970]];
}
-(NSDate*)deprocessX:(float)x {
    return [NSDate dateWithTimeIntervalSince1970:x];
}
-(NSNumber*)processY:(NSNumber*)yVal {
    return yVal;
}

@end
