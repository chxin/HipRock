//
//  REMWidgetMaxView.m
//  Blues
//
//  Created by TanTan on 7/2/13.
//
//

#import "REMWidgetMaxView.h"

@implementation REMWidgetMaxView {
    UIView* contentView;
}

- (REMModalView*)initWithSuperView:(UIView*)superView widgetCell:(REMDashboardCollectionCellView*)widgetCell
{
    self = [super initWithSuperView:superView];
    if (self) {
        REMDashboardCollectionCellView *cell = widgetCell;
        CGRect location = [cell convertRect:cell.bounds toView:nil];
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        CGFloat x, y;
        x = location.origin.y;
        y = location.origin.x;
        if (orientation == UIInterfaceOrientationLandscapeRight) y = 748 - y - cell.frame.size.height;
        _startFrame = CGRectMake(x, y, cell.frame.size.width, cell.frame.size.height);
    }
    return self;
}

- (void)close:(BOOL)fadeOut {
    if (fadeOut) {
        [UIView animateWithDuration:0.4f animations:^() {
            self.alpha = 0;
            contentView.frame = self.startFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    } else {
        [super close:fadeOut];
    }
}
- (void)show:(BOOL)fadeIn {
    [super show:NO];
    if (fadeIn) {
        [UIView animateWithDuration:0.4f animations:^() {
            self.alpha = 1;
            contentView.frame = self.bounds;
        }];
    } else {
        contentView.frame = self.bounds;
    }
}

-(void)renderContentView {
    contentView = [[UIView alloc]initWithFrame:self.startFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
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
