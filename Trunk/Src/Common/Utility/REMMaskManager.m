//
//  REMMaskManager.m
//  Blues
//
//  Created by zhangfeng on 7/5/13.
//
//

#import "REMMaskManager.h"

@implementation REMMaskManager


- (REMMaskManager *)initWithContainer:(UIView *)container
{
    REMMaskManager *manager = [super init];
    
    self.mask = [[UIActivityIndicatorView alloc] initWithFrame:container.bounds];
    [self.mask setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.mask setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    self.container = container;
    
    return manager;
}

- (void) showMask
{
    if(self.mask.isHidden == NO)
    {
        [self hideMask];
    }
    
    [self.container addSubview:self.mask];
    [self.mask startAnimating];
}

- (void) hideMask
{
    [self.mask stopAnimating];
    [self.mask removeFromSuperview];
}

@end
