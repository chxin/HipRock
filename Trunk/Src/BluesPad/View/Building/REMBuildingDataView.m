/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingDataView.m
 * Date Created : tantan on 11/21/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingDataView.h"

@implementation REMBuildingDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.panGestureRecognizer.delegate=self;
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]==YES){
        UIPanGestureRecognizer *pan=(UIPanGestureRecognizer *)gestureRecognizer;
        if(pan.delegate == self){
            CGPoint velocity= [pan velocityInView:gestureRecognizer.view];
            
            if(ABS(velocity.x)>ABS(velocity.y)){
                return NO;
            }
        }
    }
    return YES;
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
