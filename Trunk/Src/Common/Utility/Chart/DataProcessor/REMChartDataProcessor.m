//
//  REMChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/8/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartDataProcessor

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
