/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartDataProcessor.m
 * Created      : Zilong-Oscar.Xu on 10/8/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
