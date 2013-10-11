//
//  REMAppDelegate.h
//  BluesPad
//
//  Created by zhangfeng on 6/26/13.
//
//

#import <UIKit/UIKit.h>

@interface REMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (REMAppDelegate *) app;

- (void)logout;


@end
