//
//  REMMainViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@interface REMMainNavigationController : UINavigationController

-(void)presentLoginView:(void (^)(void))completed;
-(void)presentInitialView:(void (^)(void))completed;

@end
