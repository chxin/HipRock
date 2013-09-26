//
//  REMDashboard.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardView.h"

@implementation REMDashboardView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        self.backgroundView=nil;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
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
