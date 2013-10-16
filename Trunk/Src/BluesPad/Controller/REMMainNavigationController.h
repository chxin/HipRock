//
//  REMMainViewController.h
//  Blues
//
//  Created by 张 锋 on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@interface REMMainNavigationController : UINavigationController

-(void)presentLoginView:(void (^)(void))completed;
-(void)presentInitialView:(void (^)(void))completed;

@end
