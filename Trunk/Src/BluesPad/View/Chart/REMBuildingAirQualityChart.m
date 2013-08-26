//
//  REMBuildingAirQualityChart.m
//  Blues
//
//  Created by 张 锋 on 8/23/13.
//
//

#import "REMBuildingAirQualityChart.h"

@implementation REMBuildingAirQualityChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeGraph];
    }
    return self;
}


-(void)initializeGraph
{
    self.hostedGraph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
    self.hostedGraph.plotAreaFrame.paddingTop=0.0f;
    self.hostedGraph.plotAreaFrame.paddingRight=0.0f;
    self.hostedGraph.plotAreaFrame.paddingBottom=40.0f;
    self.hostedGraph.plotAreaFrame.paddingLeft=50.0f;
    self.hostedGraph.plotAreaFrame.masksToBorder = NO;
}


@end
