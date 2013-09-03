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

static CGFloat leftAxisOffset = 57.0;
static CGFloat bottomAxisOffset = 16.0;
static CGFloat topAxisOffset = 6.0;
static CGFloat rightAxisOffset = 0.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        self.layer.borderColor = [UIColor greenColor].CGColor;
//        self.layer.borderWidth = 1.0;
    }
    return self;
}


-(void)initializeGraph
{
    //NSLog(@"bounds:%@",NSStringFromCGRect(self.bounds));
    
    CGRect hostViewFrame = CGRectMake(0, 0, 710, 405 + topAxisOffset + bottomAxisOffset);
    
//    NSLog(@"bounds:%@",NSStringFromCGRect(self.bounds));
//    NSLog(@"hostbounds:%@",NSStringFromCGRect(self.hostView.bounds));
//    NSLog(@"hostframe:%@",NSStringFromCGRect(self.hostView.frame));
    
    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:hostViewFrame];
//    self.hostView.layer.borderColor = [UIColor blueColor].CGColor;
//    self.hostView.layer.borderWidth = 1.0;
    
    self.hostView.hostedGraph=[[CPTXYGraph alloc] init];
    
    self.hostView.hostedGraph.paddingTop = topAxisOffset;
    self.hostView.hostedGraph.paddingBottom = bottomAxisOffset;
    self.hostView.hostedGraph.paddingLeft = leftAxisOffset;
    self.hostView.hostedGraph.paddingRight = rightAxisOffset;
    
    self.hostView.hostedGraph.plotAreaFrame.paddingTop=0.0;
    self.hostView.hostedGraph.plotAreaFrame.paddingRight=0.0;
    self.hostView.hostedGraph.plotAreaFrame.paddingBottom=1.0;
    self.hostView.hostedGraph.plotAreaFrame.paddingLeft=1.0;
    
    self.hostView.hostedGraph.plotAreaFrame.masksToBorder = NO;
    
    [self addSubview:self.hostView];
}



@end
