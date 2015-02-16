/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDashboard.m
 * Created      : tantan on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMDashboardView.h"

@implementation REMDashboardView


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        self.backgroundView=nil;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.contentInset=UIEdgeInsetsZero;
        self.contentMode=UIViewContentModeScaleToFill;
        self.showsVerticalScrollIndicator=NO;
        
        
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
