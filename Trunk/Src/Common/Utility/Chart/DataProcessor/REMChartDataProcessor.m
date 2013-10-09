//
//  REMChartDataProcessor.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/8/13.
//
//

#import "REMChartHeader.h"

@implementation REMChartDataProcessor

-(NSNumber*)processX:(REMEnergyData*)point startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return [NSNumber numberWithInt: [point.localTime timeIntervalSince1970]];
}
-(NSDate*)deprocessX:(float)x startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return [NSDate dateWithTimeIntervalSince1970:x];
}
-(NSNumber*)processY:(REMEnergyData*)point startDate:(NSDate*)startDate step:(REMEnergyStep)step {
    return point.dataValue;
}


@end
