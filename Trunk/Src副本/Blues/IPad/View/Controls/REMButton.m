/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnlargedButton.m
 * Date Created : 张 锋 on 7/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMButton.h"

@interface REMButton()

@property (nonatomic) CGRect extendedFrame;

@end

@implementation REMButton



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

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    int errorMargin = 30;
//    CGRect largerFrame = CGRectMake(0 - errorMargin, 0 - errorMargin, self.frame.size.width + errorMargin, self.frame.size.height + errorMargin);
//    return (CGRectContainsPoint(largerFrame, point) == 1) ? self : nil;
    
    return (CGRectContainsPoint(self.extendedFrame, point) == 1) ? self:nil;
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL containsPoint = CGRectContainsPoint(self.extendedFrame, point);
    
    //NSLog(@"containsPoint: %hhd", containsPoint);
    
    return containsPoint;
}

-(CGRect)extendedFrame
{
    UIEdgeInsets insets = self.extendingInsets;
    
    CGRect bounds = self.bounds;
    CGRect extendedFrame = CGRectMake(bounds.origin.x - insets.left, bounds.origin.y - insets.top, bounds.size.width+insets.left+insets.right, bounds.size.height + insets.top + insets.bottom);
    
    return extendedFrame;
}

@end
