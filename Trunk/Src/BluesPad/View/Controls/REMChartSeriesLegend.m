//
//  REMChartSeriesLegend.m
//  Blues
//
//  Created by 张 锋 on 11/4/13.
//
//

#import "REMChartSeriesLegend.h"

@interface REMChartSeriesLegend()

@property (nonatomic,weak) UIView *indicator;
@property (nonatomic,weak) UILabel *label;
@property (nonatomic) UIControlState state;

@end

@implementation REMChartSeriesLegend

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //add tap gesture
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

@end
