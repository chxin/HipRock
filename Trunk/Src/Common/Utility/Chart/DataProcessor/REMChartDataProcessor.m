//
//  REMChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/8/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartDataProcessor

-(NSNumber*)processX:(NSDate*)xLocalTime startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return [NSNumber numberWithInt: [xLocalTime timeIntervalSince1970]];
}
-(NSDate*)deprocessX:(float)x startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return [NSDate dateWithTimeIntervalSince1970:x];
}
-(NSNumber*)processY:(NSNumber*)yVal startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return yVal;
}


@end
