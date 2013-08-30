//
//  REMBuildingAverageChart.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingAverageChart.h"

@implementation REMBuildingAverageChart

static CGFloat leftAxisOffset = 57.0;
static CGFloat rightAxisOffset = 0;
static CGFloat topAxisOffset = 0;
static CGFloat bottomAxisOffset = 56.0;

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
    self.hostView = [[CPTGraphHostingView alloc]initWithFrame:self.bounds];
    
    
    self.graph=[[CPTXYGraph alloc] init];
    
    self.graph.paddingTop = topAxisOffset;
    self.graph.paddingBottom = bottomAxisOffset;
    self.graph.paddingLeft = leftAxisOffset;
    self.graph.paddingRight = rightAxisOffset;
    
    self.graph.plotAreaFrame.paddingTop=0.0;
    self.graph.plotAreaFrame.paddingRight=0.0;
    self.graph.plotAreaFrame.paddingBottom=1.0f;
    self.graph.plotAreaFrame.paddingLeft=1.0f;
    
    self.graph.plotAreaFrame.masksToBorder = NO;
    
    //Init host view
    self.hostView.hostedGraph = self.graph;
    
    [self addSubview:self.hostView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
