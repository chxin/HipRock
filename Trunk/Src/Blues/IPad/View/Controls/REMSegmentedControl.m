/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMStepControl.m
 * Date Created : 张 锋 on 8/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSegmentedControl.h"

@interface REMSegmentedControl ()

@property (nonatomic) CGPoint margin;

@end


@implementation REMSegmentedControl

- (id)initWithItems:(NSArray *)items andMargins:(CGPoint)margin
{
    self = [super initWithItems:items];
    
    if(self){
        self.margin = margin;
    }
    
    return self;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect area = CGRectInset(self.bounds, -self.margin.x, -self.margin.y);
    BOOL containsPoint = CGRectContainsPoint(area, point);
    
    //NSLog(@"containsPoint: %hhd", containsPoint);
    
    return containsPoint;
    
    //return (ABS(point.x - CGRectGetMidX(self.bounds)) <= MAX(CGRectGetMidX(self.bounds), 22)) && (ABS(point.y - CGRectGetMidY(self.bounds)) <= MAX(CGRectGetMidY(self.bounds), 22));
}

@end
