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

static CGFloat leftAxisOffset = 22.0;
static CGFloat bottomAxisOffset = 16.0;
static CGFloat topAxisOffset = 6.0;
static CGFloat rightAxisOffset = 11.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}


-(void)initializeGraph
{
    
    CGRect hostViewFrame = CGRectMake(1, 1, self.bounds.size.width-2, 403);
    
    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:hostViewFrame];
    self.hostView.layer.borderColor = [UIColor blueColor].CGColor;
    self.hostView.layer.borderWidth = 1.0;
    
    self.hostView.hostedGraph=[[CPTXYGraph alloc] init];
    
    self.hostView.hostedGraph.paddingTop = topAxisOffset;
    self.hostView.hostedGraph.paddingBottom = bottomAxisOffset;
    self.hostView.hostedGraph.paddingLeft = leftAxisOffset;
    self.hostView.hostedGraph.paddingRight = rightAxisOffset;
    
    self.hostView.hostedGraph.plotAreaFrame.masksToBorder = NO;
    
    [self addSubview:self.hostView];
}



@end
