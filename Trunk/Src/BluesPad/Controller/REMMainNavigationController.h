/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMainViewController.h
 * Created      : 张 锋 on 9/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>

@interface REMMainNavigationController : UINavigationController

-(void)presentLoginView:(void (^)(void))completed;
-(void)presentInitialView:(void (^)(void))completed;

@end
