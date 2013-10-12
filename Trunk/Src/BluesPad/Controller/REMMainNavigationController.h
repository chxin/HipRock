//
//  REMMainViewController.h
//  Blues
//
//  Created by 张 锋 on 9/26/13.
//
//

#import <UIKit/UIKit.h>

@interface REMMainNavigationController : UINavigationController

-(void)showLoginView:(void (^)(void))completed;
-(void)showInitialView:(void (^)(void))completed;

@end
