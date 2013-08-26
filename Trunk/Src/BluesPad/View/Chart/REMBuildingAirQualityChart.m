//
//  REMBuildingAirQualityChart.m
//  Blues
//
//  Created by 张 锋 on 8/23/13.
//
//

#import "REMBuildingAirQualityChart.h"

@interface REMBuildingAirQualityChart()


@end

@implementation REMBuildingAirQualityChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self initializeGraph];
    }
    return self;
}


-(void)initializeGraph
{
    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    [self addSubview:self.hostView];
    
    
    self.hostView.hostedGraph=[[CPTXYGraph alloc]initWithFrame:self.bounds];
    self.hostView.hostedGraph.plotAreaFrame.paddingTop=0.0f;
    self.hostView.hostedGraph.plotAreaFrame.paddingRight=0.0f;
    self.hostView.hostedGraph.plotAreaFrame.paddingBottom=40.0f;
    self.hostView.hostedGraph.plotAreaFrame.paddingLeft=50.0f;
    self.hostView.hostedGraph.plotAreaFrame.masksToBorder = NO;
}



@end
