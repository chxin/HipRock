//
//  REMBuildingAverageChart.m
//  Blues
//
//  Created by 张 锋 on 8/9/13.
//
//

#import "REMBuildingAverageChart.h"

@implementation REMBuildingAverageChart

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
    
    self.graph=[[CPTXYGraph alloc]initWithFrame:self.hostView.bounds];
    self.graph.plotAreaFrame.paddingTop=0.0f;
    self.graph.plotAreaFrame.paddingRight=100.0f;
    self.graph.plotAreaFrame.paddingBottom=40.0f;
    self.graph.plotAreaFrame.paddingLeft=50.0f;
    
    //Init host view
    self.hostView.hostedGraph = self.graph;
    [self addSubview:self.hostView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning)];
    [self addGestureRecognizer:pan];
}

-(void)panning
{
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
