//
//  REMChartView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/9/13.
//
//

#import "REMChartHeader.h"

@implementation REMPieChartView

-(REMPieChartView*)initWithFrame:(CGRect)frame chartConfig:(REMChartConfig*)config  {
    self = [super initWithFrame:frame];
    if (self) {
        _series = config.series;
        
        CPTXYGraph *graph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
        self.hostedGraph=graph;
        graph.backgroundColor = [UIColor redColor].CGColor;
    }
    return self;
}
@end
