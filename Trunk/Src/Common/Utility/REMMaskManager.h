//
//  REMMaskManager.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by zhangfeng on 7/5/13.
//
//

#import <Foundation/Foundation.h>

@interface REMMaskManager : NSObject

@property (nonatomic,strong) UIActivityIndicatorView *mask;
@property (nonatomic,weak) UIView *container;

- (REMMaskManager *)initWithContainer:(UIView *)container;
- (void) showMask;
- (void) hideMask;

@end
