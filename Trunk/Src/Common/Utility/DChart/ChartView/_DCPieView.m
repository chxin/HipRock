//
//  _DCPieView.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/20/13.
//
//

#import "_DCPieView.h"

@implementation _DCPieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pieLayer = [[DCPieLayer alloc]init];
        [self.layer addSublayer:self.pieLayer];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.pieLayer.frame = self.bounds;
}

-(void)setView:(DCPieChartView *)view {
    _view = view;
    self.pieLayer.view = view;
}
-(void)redraw {
    self.
}

@end
