//
//  REMBuildingCoverLegendContainer.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 5/6/14.
//
//

#import "REMBuildingCoverLegendContainer.h"

@implementation REMBuildingCoverLegendContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)addSubview:(UIView *)view {
    view.userInteractionEnabled = NO;
    [super addSubview:view];
}

@end
