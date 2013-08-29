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
        self.backgroundColor = [UIColor greenColor];
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
    self.hostView.hostedGraph.plotAreaFrame.paddingBottom=0.0f;
    self.hostView.hostedGraph.plotAreaFrame.paddingLeft=38.0f;
    self.hostView.hostedGraph.plotAreaFrame.masksToBorder = YES;
}



@end
