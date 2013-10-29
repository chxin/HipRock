//
//  REMMaskManager.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
    if(self.mask!=nil && self.mask.superview!=nil){
        [self.mask stopAnimating];
        [self.mask removeFromSuperview];
    }
}

@end
