/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMaskManager.h
 * Created      : zhangfeng on 7/5/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

@interface REMMaskManager : NSObject

@property (nonatomic,strong) UIActivityIndicatorView *mask;
@property (nonatomic,weak) UIView *container;

- (REMMaskManager *)initWithContainer:(UIView *)container;
- (void) showMask;
- (void) hideMask;

@end
